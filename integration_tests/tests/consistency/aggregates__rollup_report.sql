{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select 
        post_id,
        source_relation,
        count(*) as total_count,
        sum(clicks) as total_clicks,
        sum(impressions) as total_impressions,
        sum(likes) as total_likes,
        sum(shares) as total_shares,
        sum(comments) as total_comments
    from {{ target.schema }}_social_media_prod.social_media_reporting__rollup_report
    group by 1, 2
),

dev as (
    select 
        post_id,
        source_relation,
        count(*) as total_count,
        sum(clicks) as total_clicks,
        sum(impressions) as total_impressions,
        sum(likes) as total_likes,
        sum(shares) as total_shares,
        sum(comments) as total_comments
    from {{ target.schema }}_social_media_dev.social_media_reporting__rollup_report
    group by 1, 2
),

final as (
    select
        prod.post_id as prod_id,
        dev.post_id as dev_id,
        prod.source_relation as prod_source_relation,
        dev.source_relation as dev_source_relation,
        prod.total_count as prod_count,
        dev.total_count as dev_count,
        prod.total_clicks as prod_clicks,
        dev.total_clicks as dev_clicks,
        prod.total_impressions as prod_impressions,
        dev.total_impressions as dev_impressions,
        prod.total_likes as prod_likes,
        dev.total_likes as dev_likes,
        prod.total_shares as prod_shares,
        dev.total_shares as dev_shares,
        prod.total_comments as prod_comments,
        dev.total_comments as dev_comments
    from prod
    full outer join dev
        on dev.post_id = prod.post_id
        and dev.source_relation = prod.source_relation
)

select *
from final
where 1=1
    and prod_count != dev_count
    or prod_clicks != dev_clicks
    or prod_impressions != dev_impressions
    or prod_likes != dev_likes
    or prod_shares != dev_shares
    or prod_comments != dev_comments