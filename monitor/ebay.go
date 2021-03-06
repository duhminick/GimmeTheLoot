package main

import (
	"strings"

	"github.com/gocolly/colly"
)

// eBay is the fetching service for eBay.com
type eBay struct{}

// CleanURL takes an eBay item URL and removes any unnecessary bits from the URL
func CleanURL(url string) string {
	if strings.Contains(url, "?epid") {
		return strings.Split(url, "?epid")[0]
	}

	if strings.Contains(url, "?hash") {
		return strings.Split(url, "?hash")[0]
	}

	return url
}

func (f eBay) ShouldFetch(monitor Monitor) bool {
	return monitor.Type == "ebay"
}

func (f eBay) GetItems(monitor Monitor) []Item {
	var items []Item
	c := colly.NewCollector()

	c.OnHTML(".s-item__info", func(e *colly.HTMLElement) {
		name := e.ChildText(".s-item__title")

		if len(monitor.Keywords) == 0 || monitor.KeywordInWord(name) {
			items = append(items, Item{
				Name:   name,
				URL:    CleanURL(e.ChildAttr("a.s-item__link", "href")),
				Price:  CleanPrice(e.ChildText(".s-item__price")),
				Source: "ebay",
			})
		}
	})

	c.Visit(monitor.URL)

	return items
}
