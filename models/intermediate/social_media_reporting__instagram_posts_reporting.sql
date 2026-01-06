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
           case
               -- For carousel albums, use carousel-specific views (not video_photo which duplicates)
               when carousel_album_views is not null
                   then coalesce(carousel_album_views, carousel_album_impressions, 0)
               -- For reels, use reel views (not video_photo which duplicates)
               when reel_views is not null
                   then reel_views
               -- For stories, use story views
               when story_views is not null
                   then coalesce(story_views, story_impressions, 0)
               -- For regular video/image posts, use video_photo views
               else coalesce(video_photo_views, video_photo_impressions, 0)
           end
       ) as impressions -- *_impressions are DEPRECATED, to be removed at a later time
    from report
    {{ dbt_utils.group_by(8) }}

)

select *
from fields