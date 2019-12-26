package main

// reddit is the fetching service for reddit.com
type reddit struct{}

func (f reddit) ShouldFetch(monitor Monitor) bool {
	return monitor.Type == "reddit"
}

func (f reddit) GetItems(monitor Monitor) []Item {
	return []Item{}
}
