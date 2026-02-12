{{ config(enabled=var('social_media_rollup__linkedin_enabled', True)) }}

with report as (

    select *
    from {{ var('linkedin_posts_report') }}

), fields as (

    select        
        cast(organization_id as {{ dbt.type_string() }}) as page_id,
        cast(organization_name as {{ dbt.type_string() }}) as page_name,
        cast(post_id as {{ dbt.type_string() }}) as post_id,
        created_timestamp,
        cast(post_url as {{ dbt.type_string() }}) as post_url,
        source_relation,
        'linkedin' as platform,
        cast(coalesce(post_title, commentary) as {{ dbt.type_string() }}) as post_message,
        coalesce(sum(click_count),0) as clicks,
        coalesce(sum(comment_count),0) as comments,
        coalesce(sum(impression_count),0) as impressions,
        coalesce(sum(like_count),0) as likes,
        coalesce(sum(share_count),0) as shares
    from report
    {{ dbt_utils.group_by(8) }}

)

select *
from fields