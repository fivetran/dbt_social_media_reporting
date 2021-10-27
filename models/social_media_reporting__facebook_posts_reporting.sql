with report as (

    select *
    from {{ var('facebook_posts_report') }}

), fields as (

    select
        created_timestamp,
        post_id,
        post_message,
        page_id,
        page_name,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(likes) as likes
    from report
    {{ dbt_utils.group_by(5) }}

)

select *
from fields