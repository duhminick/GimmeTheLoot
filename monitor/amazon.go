package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"regexp"
)

// Amazon is the struct for fetching Amazon products
type Amazon struct{}

// ShouldFetch determines if it should fetch the current monitor
func (f Amazon) ShouldFetch(monitor Monitor) bool {
	return monitor.Type == "amazon"
}

// GetItems returns the output from this fetch
func (f Amazon) GetItems(monitor Monitor) []Item {
	// We are using an array, but it will only contain one item
	var items []Item
	item := Item{
		URL:    monitor.URL,
		Source: "amazon",
	}

	client := &http.Client{}

	req, err := http.NewRequest("GET", monitor.URL, nil)
	if err != nil {
		log.Printf("Error! %s", err)
		return items
	}

	// Set User-Agent to the one used for Chrome macOS
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36")
	req.Header.Set("Accept-Encoding", "deflate")
	req.Header.Set("Proxy-Connection", "keep-alive")
	req.Header.Set("Host", "www.amazon.com:443")

	resp, err := client.Do(req)
	if err != nil {
		log.Printf("Error! %s", err)
		return items
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Printf("Error! %s", err)
		return items
	}

	output := string(body)

	// Using RegEx to get the info we need
	re := regexp.MustCompile(`data-asin-price="([^"]+)"`)
	item.Price = CleanPrice(re.FindStringSubmatch(output)[1])

	re = regexp.MustCompile(`"TURBO_CHECKOUT_HEADER":"Buy now: ([^"]+)`)
	item.Name = re.FindStringSubmatch(output)[1]

	return append(items, item)
}
