{{ config(enabled=var('social_media_rollup__facebook_enabled', True)) }}

with report as (

    select *
    from {{ var('facebook_posts_report') }}
    where is_most_recent_record = True

), fields as (

    select
        created_timestamp,
        cast(post_id as {{ dbt.type_string() }}) as post_id,
        cast(post_message as {{ dbt.type_string() }}) as post_message,
        cast(post_url as {{ dbt.type_string() }}) as post_url,
        cast(page_id as {{ dbt.type_string() }}) as page_id,
        cast(page_name as {{ dbt.type_string() }}) as page_name,
        source_relation,
        'facebook' as platform,
        coalesce(sum(clicks),0) as clicks,
        coalesce(sum(impressions),0) as impressions, -- Deprecated as of November, 2025. Will be removed in future release.
        coalesce(sum(likes),0) as likes
    from report
    {{ dbt_utils.group_by(8) }}

)

select *
from fields