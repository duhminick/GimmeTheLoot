# Gimme The Loot
> Periodically checks for new listings/links defined by the user on select services

## Setup
1. Rename all the .example files to their proper names and fill in the files
* `.env.example` to `.env`
* `ios/GimmeTheLoot/Info.plist.example` to  `ios/GimmeTheLoot/Info.plist`

2. Run
```
$ docker-compose up
```

3. Periodically run `monitor/`. I just use cron.

## Setting up Apple Push Notification
* Requires Apple Developer Program
* Enable Push Notification in https://developer.apple.com/account/resources/identifiers/list
  * Add Push Notification compatability in Xcode for `ios/`
* Add certificates (`cert.pem` and `key.pem`) into `api/`. Instructions available at https://github.com/node-apn/node-apn/wiki/Preparing-Certificates

## Incomplete
`web/` and `mobile/` are incomplete and are likely to be scrapped for a better solution. The current
best way to interface with the API is `ios/`

## Supported Services
* reddit
* eBay