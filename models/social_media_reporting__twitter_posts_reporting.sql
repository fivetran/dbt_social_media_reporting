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
        source_relation,
        'twitter' as platform,
        coalesce(sum(clicks),0) as clicks,
        coalesce(sum(impressions),0) as impressions,
        coalesce(sum(likes),0) as likes,
        coalesce(sum(retweets),0) as shares,
        coalesce(sum(replies),0) as comments
    from report
    {{ dbt_utils.group_by(8) }}

)

select *
from fields