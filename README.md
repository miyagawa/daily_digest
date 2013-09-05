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

Depending on your configuration, `daily_digest` will deliver the generated MOBI file to your destination in either:

* Copy the mobi to `~/Dropbox/Public/Kindle` for [IFTTT](http://ifttt.com) automation if the folder exists
* Send the mobi file as an email attachment if SMTP server authentication is configured (see below)

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

If you want to directly send email to your Kindle Personal Document, you'll need the following environment variables as well:

```
KINDLE_MAILTO=YOU@free.kindle.com
KINDLE_MAILFROM=you@example.com
SMTP_SERVER=smtp.example.com:587
SMTP_USERNAME=you@example.com
SMTP_PASSWORD=43829f4cchRRY8
```

## Copyright

Tatsuhiko Miyagawa

## License

This software is licensed under the MIT License.
