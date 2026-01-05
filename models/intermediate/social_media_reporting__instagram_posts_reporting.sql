{{ config(enabled=var('social_media_rollup__instagram_enabled', True)) }}

with report as (

    select *
    from {{ var('instagram_posts_report') }}

), fields as (

    select
        cast(account_name as {{ dbt.type_string() }}) as page_name,
        cast(user_id as {{ dbt.type_string() }}) as page_id,
        cast(post_caption as {{ dbt.type_string() }}) as post_message,
        created_timestamp,
        cast(post_id as {{ dbt.type_string() }}) as post_id,
        cast(post_url as {{ dbt.type_string() }}) as post_url,
        source_relation,
        'instagram' as platform,
        coalesce(sum(comment_count),0) as comments,
        coalesce(sum(like_count),0) as likes,
        sum(
            CASE 
                -- For carousel albums, use carousel-specific views (not video_photo which duplicates)
                WHEN carousel_album_views IS NOT NULL AND carousel_album_views > 0 
                    THEN coalesce(carousel_album_views, carousel_album_impressions, 0)
                -- For reels, use reel views (not video_photo which duplicates)
                WHEN reel_views IS NOT NULL AND reel_views > 0 
                    THEN reel_views
                -- For stories, use story views
                WHEN story_views IS NOT NULL AND story_views > 0 
                    THEN coalesce(story_views, story_impressions, 0)
                -- For regular video/image posts, use video_photo views
                ELSE coalesce(video_photo_views, video_photo_impressions, 0)
            END
        ) as impressions -- *_impressions are DEPRECATED, to be removed at a later time
    from report
    {{ dbt_utils.group_by(8) }}

)

select *
from fields