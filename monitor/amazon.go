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
	req.Header.Set("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36")

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
	re := regexp.MustCompile(`"buyboxPrice":"(\$[^"]+)"`)
	item.Price = CleanPrice(re.FindStringSubmatch(output)[1])

	re = regexp.MustCompile(`"TURBO_CHECKOUT_HEADER":"Buy now: ([^"]+)`)
	item.Name = re.FindStringSubmatch(output)[1]

	return append(items, item)
}
