with report as (

    select *
    from {{ var('twitter_posts_report') }}

), fields as (

    select        
        created_timestamp,
        organic_tweet_id as post_id,
        tweet_text as post_message,
        account_id as page_id,
        account_name as page_name,
        post_url,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(likes) as likes,
        sum(retweets) as shares,
        sum(replies) as comments
    from report
    {{ dbt_utils.group_by(6) }}

)

select *
from fields