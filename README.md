# Discourse Wellfed [![Build Status](https://travis-ci.org/discourse/discourse-rss-polling.svg?branch=master)](https://travis-ci.org/discourse/discourse-rss-polling)

Import RSS feeds from different sources into your Discourse.

## Install

Add `git clone https://github.com/discourse/discourse-ress-polling.git` to the plugin section in your `app.yml` file.

Please refer to [Install Plugins in Discourse](https://meta.discourse.org/t/install-plugins-in-discourse/19157) for the detailed instructions.

## Setup

In  `Plugins > Wellfed` , you’ll find the settings for the different feeds. Click on the bottom right plus ( `+` ) icon to add a new feed, and click on the top right disk icon to save the settings.

![wellfed_settings](https://user-images.githubusercontent.com/6376558/61013920-d48a7400-a352-11e9-9a33-d56e13143cea.png)

After setting up the feeds from which you want to poll, go to  `Customize > Embedding`  to set them as "Allowed Hosts". Note, you will also set the desired destination category here.

![customize embedding](https://user-images.githubusercontent.com/6376558/61013928-dbb18200-a352-11e9-957e-c57a184d9295.png)

## Site Settings

There are only two other Site Settings, which are quite straightforward. The default polling frequency is 30 minutes. I don’t recommend setting this to less than 10 minutes.

![site settings](https://user-images.githubusercontent.com/6376558/61013931-dfdd9f80-a352-11e9-9e44-2f531002a69e.png)

When a topic is first created, it is likely that the content is crawled from the webpage. This is because the feed polling operation is rate limited for performance reasons. However, when the feed is polled the next time, the topic will be automatically be updated with the feed content.
