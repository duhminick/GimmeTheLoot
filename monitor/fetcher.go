package main

import (
	"strconv"
	"strings"
)

// Fetcher is the interface in which each fetching service
// should implement
type Fetcher interface {
	ShouldFetch(Monitor) bool
	GetItems(Monitor) []Item
}

// CleanPrice takes in a price and removes any unnecessary parts and returns a float
func CleanPrice(price string) float32 {
	if strings.Contains(price, "to") {
		price = strings.Split(price, " to ")[0]
	}

	if strings.Contains(price, "$") {
		price = strings.Split(price, "$")[1]
	}

	numerical, _ := strconv.ParseFloat(price, 32)

	return float32(numerical)
}
