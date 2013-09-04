# daily_digest

Generates Daily Digest from Pocket

## Screenshot

![](http://dl.dropbox.com/u/135035/Screenshots/l8fvefgdfrt7.png)

## Prerequisite

* Ruby 1.9 or later
* Bundler
* [calibre](http://calibre-ebook.com/) and `ebook-convert` CLI
* [Readability Parser API Key](http://www.readability.com/developers/api/parser)
* [Pocket API Key and authorized token](http://getpocket.com/developer/docs/authentication)

## Workflow

`rake deliver` will run the following tasks:

* Fetch unread items from [Pocket](http://getpocket.com)
* Parse content with [Readbility](http://www.readability.com)
* Create MOBI with Calibre ebook-convert
* Copy the mobi to `~/Dropbox/Public/Kindle` for [IFTTT](http://ifttt.com) automation

You can let IFTTT watch `/Kindle` subfolder to send to your Kindle personal document free email address.

## How To

```
bundle install
$EDITOR .env
bundle exec rake deliver
```

## Environment

You will have `.env` file that looks like:

```
POCKET_CONSUMER_KEY=1234-abcd
POCKET_ACCESS_TOKEN=a2aa5caa-c000-6ecb-b589-f7daea
READABILITY_PARSER_KEY=2caeae6676796adada6967a5cddcd6a2292
```

You have to manually authenticate against [Pocket OAuth endpoint](http://getpocket.com/developer/docs/authentication) to get the tokens. Sorry.

## Copyright

Tatsuhiko Miyagawa

## License

This software is licensed under the MIT License.
