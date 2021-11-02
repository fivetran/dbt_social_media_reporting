with report as (

    select *
    from {{ var('facebook_posts_report') }}

), fields as (

    select
        created_timestamp,
        post_id,
        post_message,
        post_url,
        page_id,
        page_name,
        source_relation,
        'facebook' as platform,
        coalesce(sum(clicks),0) as clicks,
        coalesce(sum(impressions),0) as impressions,
        coalesce(sum(likes),0) as likes
    from report
    {{ dbt_utils.group_by(8) }}

)

select *
from fields