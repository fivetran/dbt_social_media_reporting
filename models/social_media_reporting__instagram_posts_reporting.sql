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
        source_relation,
        'instagram' as platform,
        coalesce(sum(comment_count),0) as comments,
        coalesce(sum(like_count),0) as likes,
        sum(coalesce(carousel_album_impressions,0) + coalesce(story_impressions,0) + coalesce(video_photo_impressions, 0)) as impressions
    from report
    {{ dbt_utils.group_by(8) }}

)

select *
from fields