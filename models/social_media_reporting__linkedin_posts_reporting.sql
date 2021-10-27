with report as (

    select *
    from {{ var('linkedin_posts_report') }}

), fields as (

    select        
        organization_id as page_id,
        organization_name as page_name,
        ugc_post_id as post_id,
        created_timestamp,
        post_url,
        coalesce(title_text, specific_content_share_commentary_text) as post_message,
        sum(click_count) as clicks,
        sum(comment_count) as comments,
        sum(impression_count) as impressions,
        sum(like_count) as likes,
        sum(share_count) as shares
    from report
    {{ dbt_utils.group_by(6) }}

)

select *
from fields