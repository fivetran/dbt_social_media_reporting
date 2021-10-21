with report as (

    select *
    from {{ var('linkedin_posts_report') }}

), fields as (

    select        
        ugc_post_id as post_id,
        created_timestamp,
        title_text as post_message,
        original_url as post_url,
        sum(click_count) as clicks,
        sum(comment_count) as comments,
        sum(impression_count) as impressions,
        sum(like_count) as likes,
        sum(share_count) as shares
    from report
    {{ dbt_utils.group_by(4) }}

)

select *
from fields