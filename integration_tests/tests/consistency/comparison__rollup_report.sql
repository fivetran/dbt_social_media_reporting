{{ config(tags="fivetran_validations", enabled=var('fivetran_validation_tests_enabled', false)) }}

{% set table_name = 'social_media_reporting__rollup_report' %}
{% set exclude_cols = '(' ~ var('exclude_comparison_columns', '_dbt_source_relation')  ~ ')' %}

-- Find the common columns to use in the comparison. This currently only works for BQ.
{% if execute and target.type == 'bigquery' %}
{% set common_cols_query %}
    select column_name
    from {{ target.database }}.{{ target.schema }}_social_media_prod.INFORMATION_SCHEMA.COLUMNS
    where lower(table_name) = '{{ table_name }}'
    and lower(column_name) not in {{ exclude_cols }}

    intersect distinct

    select column_name
    from {{ target.database }}.{{ target.schema }}_social_media_dev.INFORMATION_SCHEMA.COLUMNS
    where lower(table_name) = '{{ table_name }}'
    and lower(column_name) not in {{ exclude_cols }}
{% endset %}

{% set common_cols = run_query(common_cols_query).columns[0].values() %}
{% set column_list = common_cols | join(', ') %}

{% else %}
{% set column_list = '*' %}
{% endif %}

with prod as (
    select {{ column_list }}
    from {{ target.schema }}_social_media_prod.social_media_reporting__rollup_report
),

dev as (
    select {{ column_list }}
    from {{ target.schema }}_social_media_dev.social_media_reporting__rollup_report
),

prod_not_in_dev as (
    -- rows from prod not found in dev
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    -- rows from dev not found in prod
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all -- union since we only care if rows are produced

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final