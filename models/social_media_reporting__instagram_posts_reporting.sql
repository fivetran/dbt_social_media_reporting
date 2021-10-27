with report as (

    select *
    from {{ var('instagram_posts_report') }}

), fields as (

    select
        account_name as page_name,
        user_id as page_id,
        post_caption as post_message,
        created_timestamp,
        post_id,
        post_url,
        sum(comment_count) as comments,
        sum(like_count) as likes,
        sum(coalesce(carousel_album_impressions,0) + coalesce(story_impressions,0) + coalesce(video_photo_impressions, 0)) as impressions
    from report
    {{ dbt_utils.group_by(6) }}

)

select *
from fields