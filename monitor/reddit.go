package main

import (
	"fmt"
	"log"
	"regexp"
	"strconv"
	"strings"
	"time"

	snoo "github.com/turnage/graw/reddit"
)

// reddit is the fetching service for reddit.com
type reddit struct{}

func (f reddit) ShouldFetch(monitor Monitor) bool {
	return monitor.Type == "reddit"
}

func getPriceFromTitle(title string) (string, error) {
	re := regexp.MustCompile(`\=\s*\$?(\d+\.?\d+)|\$(\d+\.?\d+)`)
	results := re.FindStringSubmatch(title)
	if len(results) == 0 {
		return "", fmt.Errorf("could not find a price")
	}

	// There are two capture groups in the regular expression
	// if the 1st match is there, then pick this one over the
	// 2nd match
	if results[1] != "" {
		return results[1], nil
	}

	return results[len(results)-1], nil
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
			newItem := Item{
				Name:   post.Title,
				URL:    "https://reddit.com" + post.Permalink,
				Source: "reddit",
			}

			if price, err := getPriceFromTitle(post.Title); err == nil {
				priceFloat, _ := strconv.ParseFloat(price, 32)
				newItem.Price = float32(priceFloat)
			}

			items = append(items, newItem)
		}
	}

	return items
}
