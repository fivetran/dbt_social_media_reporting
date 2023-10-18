# dbt_social_media_reporting v0.3.0
[PR #7](https://github.com/fivetran/dbt_social_media_reporting/pull/7) includes the following breaking changes:
## 🚨 Breaking Changes 🚨:
- This update is made breaking due to the following changes in the [Linkedin Company Pages Fivetran Connector](https://fivetran.com/docs/applications/linkedin-company-pages), the [dbt_linkedin_pages_source](https://github.com/fivetran/dbt_linkedin_pages_source) package, and the [dbt_linkedin_pages](https://github.com/fivetran/dbt_linkedin_pages) package.
    - Deprecated source table `ugc_post_share_content_media`
    - Added source table `post_content` 
    - See the [May 2023 release notes](https://fivetran.com/docs/applications/linkedin-company-pages/changelog#may2023), [dbt_linkedin_pages_source CHANGELOG](https://github.com/fivetran/dbt_linkedin_pages_source/blob/main/CHANGELOG.md), and the [dbt_linkedin_pages CHANGELOG](https://github.com/fivetran/dbt_linkedin_pages_source/blob/main/CHANGELOG.md) for full details. 

## Features
- In `social_media_reporting__linkedin_posts_reporting`:
    - removed deprecated columns:
        - `title_text`
        - `specific_content_share_commentary_text`
    - replaced with new columns:
        - `post_title` 
        - `commentary` 
- Added source identifiers to give users more dynamic flexibility. Please see [this section](https://github.com/fivetran/dbt_social_media_reporting#change-the-source-table-references) of the README for more details. 
- Updated README documentation to most current format. 

## Under the Hood:
- Updated seeds to reflect the above changes. 

[PR #6](https://github.com/fivetran/dbt_social_media_reporting/pull/6) includes the following updates:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).

# dbt_social_media_reporting v0.2.0

## 🚨 Breaking Changes 🚨:
[PR #4](https://github.com/fivetran/dbt_social_media_reporting/pull/4) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_social_media_reporting v0.1.0

The original release! This dbt package aggregates and models data from multiple Fivetran social media connectors. The package standardizes the schemas from the various social media connectors and creates a single reporting model for all activity. It enables you to analyze your post performance via clicks, impressions, shares, likes and comments.

Currently, this package supports the following social media connector types:
> NOTE: You do _not_ need to have all of these connector types to use this package, though you should have at least two.
* [Facebook Pages](https://github.com/fivetran/dbt_facebook_pages)
* [Instagram Business](https://github.com/fivetran/dbt_instagram_business)
* [LinkedIn Company Pages](https://github.com/fivetran/dbt_linkedin_pages)
* [Twitter Organic](https://github.com/fivetran/dbt_twitter_organic)