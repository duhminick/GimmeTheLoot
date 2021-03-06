package main

import (
	"context"
	"log"
	"net/http"
	"strings"
	"sync"

	"github.com/machinebox/graphql"
)

const (
	// GraphQLEndpoint is the URL to the GraphQL endpoint
	GraphQLEndpoint = "http://localhost:5000"

	// Token is the access key
	Token = "aiwhaIO%HOIAGH"

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

// HTTPRoundTripper represents the ability to execute an HTTP transaction
type HTTPRoundTripper struct {
	r http.RoundTripper
}

// RoundTrip is the function that is used to implement RoundTripper
// alongside the addition of our Authorization header
func (rt HTTPRoundTripper) RoundTrip(r *http.Request) (*http.Response, error) {
	r.Header.Add("Authorization", "Bearer "+Token)
	return rt.r.RoundTrip(r)
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

var httpClient *http.Client
var client *graphql.Client
var fetchers []Fetcher

func init() {
	httpClient = &http.Client{
		Transport: HTTPRoundTripper{
			r: http.DefaultTransport,
		},
	}
	client = graphql.NewClient(GraphQLEndpoint, graphql.WithHTTPClient(httpClient))
	fetchers = []Fetcher{
		&eBay{},
		&reddit{},
		&Amazon{},
	}
}

func GetItems(ic chan<- Item, monitor Monitor) {
	for _, fetcher := range fetchers {
		// Check to see if the current fetcher should be used on this monitor
		if fetcher.ShouldFetch(monitor) {
			log.Printf("Fetching items for '%s' with type '%s'", monitor.Name, monitor.Type)

			// Get all the items from the fetcher
			items := fetcher.GetItems(monitor)

			for _, item := range items {
				ic <- item
			}
		}
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

	items := make(chan Item)
	var wg sync.WaitGroup
	for _, monitor := range response.Monitors {
		wg.Add(1)
		go func(monitor Monitor) {
			GetItems(items, monitor)
			wg.Done()
		}(monitor)
	}

	go func() {
		wg.Wait()
		close(items)
	}()

	// Iterate through the items
	for item := range items {
		log.Printf("Looking at item %s", item.Name)
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
