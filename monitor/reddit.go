package main

import (
	"log"
	"strings"
	"time"

	snoo "github.com/turnage/graw/reddit"
)

// reddit is the fetching service for reddit.com
type reddit struct{}

func (f reddit) ShouldFetch(monitor Monitor) bool {
	return monitor.Type == "reddit"
}

func (f reddit) GetItems(monitor Monitor) []Item {
	var items []Item

	subreddit := strings.Split(monitor.URL, "reddit.com")[1]

	handle, err := snoo.NewScript("GimmeTheLoot", 5*time.Second)
	if err != nil {
		log.Printf("Error! %s", err)
	}

	harvest, err := handle.Listing(subreddit, "")
	if err != nil {
		log.Printf("Error! %s", err)
	}

	for _, post := range harvest.Posts {
		if len(monitor.Keywords) == 0 || monitor.KeywordInWord(post.Title) {
			items = append(items, Item{
				Name:   post.Title,
				URL:    "https://reddit.com" + post.Permalink,
				Source: "reddit",
			})
		}
	}

	return items
}
