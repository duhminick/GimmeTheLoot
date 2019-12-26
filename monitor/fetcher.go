package main

// Fetcher is the interface in which each fetching service
// should implement
type Fetcher interface {
	ShouldFetch(Monitor) bool
	GetItems(Monitor) []Item
}
