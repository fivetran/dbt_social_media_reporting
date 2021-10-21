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
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(likes) as likes,
        sum(retweets) as shares
    from report
    {{ dbt_utils.group_by(5) }}

)

select *
from fields