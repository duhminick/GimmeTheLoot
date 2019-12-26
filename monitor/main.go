package main

import (
	"context"
	"log"
	"strings"

	"github.com/machinebox/graphql"
)

const (
	// GraphQLEndpoint is the URL to the GraphQL endpoint
	GraphQLEndpoint = "http://localhost:5000"

	// RetrieveMonitors is the query to retrieve the monitors
	RetrieveMonitors = `
		{
			monitors {
				name
				type
				keywords
				url
			}
		}`

	// AddItem is the mutation to add a new fetched item
	AddItem = `
		mutation ($name: String!, $url: String!, $price: Float, $source: String) {
			createItem(
				name: $name
				url: $url
				price: $price
				source: $source
			)
		}`
)

// Monitor is the response structure for our call to GraphQL
type Monitor struct {
	Name     string   `json:"name"`
	Type     string   `json:"type"`
	Keywords []string `json:"keywords"`
	URL      string   `json:"url"`
}

// MonitorsResponse is the response structure
type MonitorsResponse struct {
	Monitors []Monitor
}

// Item is the schema for the fetched items
type Item struct {
	ID     string
	Name   string
	URL    string
	Price  float32
	Source string
}

// KeywordInWord checks to see if the inputted word has a keyword from the keywords array
func (m *Monitor) KeywordInWord(word string) bool {
	for _, keyword := range m.Keywords {
		if strings.Contains(strings.ToLower(word), strings.ToLower(keyword)) {
			return true
		}
	}

	return false
}

var client *graphql.Client
var fetchers []Fetcher

func init() {
	client = graphql.NewClient(GraphQLEndpoint)
	fetchers = []Fetcher{
		&eBay{},
		&reddit{},
	}
}

func main() {
	ctx := context.Background()

	log.Printf("Retrieving monitors")
	queryReq := graphql.NewRequest(RetrieveMonitors)

	var response MonitorsResponse
	if err := client.Run(ctx, queryReq, &response); err != nil {
		log.Panic(err)
	}

	for _, monitor := range response.Monitors {
		for _, fetcher := range fetchers {
			// Check to see if the current fetcher should be used on this monitor
			if fetcher.ShouldFetch(monitor) {
				log.Printf("Fetching items for '%s' with type '%s'", monitor.Name, monitor.Type)

				// Get all the items from the fetcher
				items := fetcher.GetItems(monitor)

				// Iterate through the items
				for _, item := range items {
					addReq := graphql.NewRequest(AddItem)

					addReq.Var("name", item.Name)
					addReq.Var("url", item.URL)
					addReq.Var("price", item.Price)
					addReq.Var("source", item.Source)

					if err := client.Run(ctx, addReq, nil); err == nil {
						log.Printf("Added item '%s'", item.Name)
					}
				}
			}
		}
	}
}
