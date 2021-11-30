# dbt_social_media_reporting v0.1.0

The original release! This dbt package aggregates and models data from multiple Fivetran social media connectors. The package standardizes the schemas from the various social media connectors and creates a single reporting model for all activity. It enables you to analyze your post performance via clicks, impressions, shares, likes and comments.

Currently, this package supports the following social media connector types:
> NOTE: You do _not_ need to have all of these connector types to use this package, though you should have at least two.
* [Facebook Pages](https://github.com/fivetran/dbt_facebook_pages)
* [Instagram Business](https://github.com/fivetran/dbt_instagram_business)
* [LinkedIn Company Pages](https://github.com/fivetran/dbt_linkedin_pages)
* [Twitter Organic](https://github.com/fivetran/dbt_twitter_organic)