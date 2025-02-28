{{ config(enabled=var('social_media_rollup__youtube_enabled')) }}

with report as (

    select *
    from {{ var('youtube_videos_report') }}

), fields as (

    select
        video_published_at as created_timestamp,
        cast(video_id as {{ dbt.type_string() }}) as post_id,
        cast(video_description as {{ dbt.type_string() }}) as post_message,
        cast(default_thumbnail_url as {{ dbt.type_string() }}) as post_url,
        cast(channel_id as {{ dbt.type_string() }}) as page_id,
        cast(channel_title as {{ dbt.type_string() }}) as page_name,
        source_relation,
        'youtube' as platform,
        coalesce(sum(views),0) as clicks,
        coalesce(sum(comments),0) as comments,
        coalesce(sum(likes),0) as likes,
        coalesce(sum(shares),0) as shares
    from report
    {{ dbt_utils.group_by(7) }}

)

select *
from fields