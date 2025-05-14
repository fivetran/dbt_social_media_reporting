# dbt_social_media_reporting v0.7.0
[PR #20](https://github.com/fivetran/dbt_social_media_reporting/pull/20) includes the following updates:

## Instagram Business – Breaking Change
- Applied the schema changes below to align with the [April 2025](https://fivetran.com/docs/connectors/applications/instagram-business/changelog#april2025) and [December 2024](https://fivetran.com/docs/connectors/applications/instagram-business/changelog#december2024) Fivetran connector updates:
  - Deprecated metrics are retained for backward compatibility but will be removed in a future release.
  - See the [Instagram API documentation](https://developers.facebook.com/docs/instagram-platform/reference/instagram-media/insights) for more detail on the updated fields.
- Updated the determination of `impressions` in the `social_media_reporting__instagram_posts_reporting` model:
  - As Instagram has deprecated certain "impressions" fields in favor of "views", we now coalesce available `views` and `impressions` into a single field named `impressions`, prioritizing `views`.
  - This approach preserves compatibility with the downstream the `social_media_reporting__rollup_report` model.
  - Note: This may slightly alter reported values for some media types.
  - The decision is also documented in the [DECISIONLOG](https://github.com/fivetran/dbt_social_media_reporting/blob/main/DECISIONLOG.md).

## Schema Changes  
4 total changes • 0 possible breaking changes  

| Data Model | Change type | Old name | New name | Notes |
|------------|-------------|----------|----------|-------|
| [`instagram_business__posts`](https://fivetran.github.io/dbt_instagram_business_source/#!/model/model.instagram_business_source.instagram_business__posts) | New Columns | | `carousel_album_shares`, `carousel_album_views`, `story_shares`, `story_views`, `video_photo_shares`, `video_photo_views`, `reel_views` | |
| [`instagram_business__posts`](https://fivetran.github.io/dbt_instagram_business_source/#!/model/model.instagram_business_source.instagram_business__posts) | Deprecated Columns | `carousel_album_impressions`, `carousel_album_video_views`, `story_impressions`, `video_photo_impressions`, `video_views`, `reel_plays` | | Retained for backward compatibility but will be removed in a future release |
| [`stg_instagram_business__media_insights`](https://fivetran.github.io/dbt_instagram_business_source/#!/model/model.instagram_business_source.stg_instagram_business__media_insights) | New Columns | | `carousel_album_shares`, `carousel_album_views`, `story_shares`, `story_views`, `video_photo_shares`, `video_photo_views`, `reel_views` | |
| [`stg_instagram_business__media_insights`](https://fivetran.github.io/dbt_instagram_business_source/#!/model/model.instagram_business_source.stg_instagram_business__media_insights) | Deprecated Columns | `carousel_album_impressions`, `carousel_album_video_views`, `story_impressions`, `video_photo_impressions`, `video_views`, `reel_plays` | | Retained for backward compatibility but will be removed in a future release  |

## Under the Hood
- Updated the consistency test to only include columns present in both dev and prod, ensuring that the consistency test can run with what is common.
- Moved default `var` definitions in-line within models instead of defining them in the package’s `dbt_project.yml` to prevent conflicts with a user’s own `dbt_project.yml`, aligning with practices used in other packages.
- Standardized the syntax of the `get_staging_files` macro to match conventions used across other packages.

# dbt_social_media_reporting v0.6.0
[PR #16](https://github.com/fivetran/dbt_social_media_reporting/pull/16) includes the following updates:

## Breaking Change: Addition of Youtube Analytics
- We have added Youtube Analytics as a platform in this package via the `youtube__video_report` model from the [dbt_youtube_analytics](https://github.com/fivetran/dbt_youtube_analytics) package. 
  - For Quickstart users, this is enabled/disabled automatically based on the presence of `youtube_analytics` data. 
  - For other users, this is enabled by default. However, if you are not using the Youtube Analytics connection, you may disable it by following [these steps in the README](https://github.com/fivetran/dbt_social_media_reporting/blob/main/README.md#step-4-enablingdisabling-models) or by including the configuration shown below in your `dbt_project.yml` file:

```yml
vars:
    social_media_rollup__youtube_enabled: False

models:
    youtube_analytics:
        enabled: false
    youtube_analytics_source:
        enabled: false
```

## Documentation
- Added Quickstart model counts to README. ([#15](https://github.com/fivetran/dbt_social_media_reporting/pull/15))
- Corrected references to connectors and connections in the README. ([#15](https://github.com/fivetran/dbt_social_media_reporting/pull/15))

## Under the Hood
- Updated Copyright and README format.
- Updated `comparison__rollup_report` validation test to correctly reference `_social_media_dev`.
- Added table variables for the upstream Youtube Analytics package in the `quickstart.yml`.

# dbt_social_media_reporting v0.5.0

## Upstream Breaking Changes (Twitter Organic)
[PR #12](https://github.com/fivetran/dbt_twitter_organic_source/pull/12) from the upstream `dbt_twitter_organic_source` package includes the following breaking change updates:

- The source defined in the `src_twitter_organic.yml` file has been renamed from `twitter_organic` to `twitter` to align with the default schema name used by the upstream Fivetran connector.
    - If you're referencing sources from the upstream Twitter Organic packages, please update your source references as needed. See below for the full scope of source changes.

| **New Source Reference** | **Old Source Reference** |
|----------------------------------|----------------------------------|
| `"{{ source('twitter','account_history') }}"` | `"{{ source('twitter_organic','account_history') }}"` |
| `"{{ source('twitter','organic_tweet_report') }}"` | `"{{ source('twitter_organic','organic_tweet_report') }}"` |
| `"{{ source('twitter','tweet') }}"` | `"{{ source('twitter_organic','tweet') }}"` |
| `"{{ source('twitter','twitter_user_history') }}"` | `"{{ source('twitter_organic','twitter_user_history') }}"` |

- The default schema name has been modified from `twitter_organic` to now be `twitter` to more closely align with the default schema name generated by the Fivetran connector. Please be aware if you were leveraging the previous default schema then you will need to update the `twitter_organic_schema` variable accordingly. 
- All identifier variables in the `src_twitter_organic.yml` file have been renamed. If you’re using any of these in your project, please update them accordingly. The changes include: 
    - Prepending `twitter_organic_*` has been updated to `twitter_*` to align with the schema change.
    - The spelling of `*_identifer` has been corrected to `*_identifier`.

| **New Identifier Variable Name** | **Old Identifier Variable Name** |
|----------------------------------|----------------------------------|
| `twitter_account_history_identifier` | `twitter_organic_account_history_identifer` |
| `twitter_organic_tweet_report_identifier` | `twitter_organic_organic_tweet_report_identifer` |
| `twitter_tweet_identifier` | `twitter_organic_tweet_identifer` |
| `twitter_twitter_user_history_identifier` | `twitter_organic_twitter_user_history_identifer` |

## Under the Hood
- Consistency validation for integration tests has been added for the `social_media_reporting__rollup_report` model. ([PR #11](https://github.com/fivetran/dbt_social_media_reporting/pull/11))
- Updated the maintainer PR, Issue, Feature Request, and Config templates to resemble the most up to date format. ([PR #11](https://github.com/fivetran/dbt_social_media_reporting/pull/11))
- Renamed the Twitter Organic seed files to allow for more testing functionality. ([PR #11](https://github.com/fivetran/dbt_social_media_reporting/pull/11))
- Addition of a section tag within the README so the model descriptions may be accessible within the Fivetran UI for Quickstart. ([PR #10](https://github.com/fivetran/dbt_social_media_reporting/pull/10))

# dbt_social_media_reporting v0.4.0
[PR #8](https://github.com/fivetran/dbt_social_media_reporting/pull/8) includes the following breaking changes:

## 🚨 Breaking Changes 🚨:
- This change is made breaking due to changes made in the [dbt_facebook_pages_source](https://github.com/fivetran/dbt_facebook_pages_source) and [dbt_facebook_pages](https://github.com/fivetran/dbt_facebook_pages) packages. Columns have been removed in the source package (see the [dbt_facebook_pages_source v0.3.0 CHANGELOG](https://github.com/fivetran/dbt_facebook_pages_source/blob/main/CHANGELOG.md#dbt_facebook_pages_source-v030) for more details). 
    - No columns were changed in the end models in this package, however if you use the Facebook Pages staging models independently, you will need to update your downstream use cases accordingly.
    - Columns removed from staging model `stg_facebook_pages__daily_page_metrics_total`:
        - `consumptions`
        - `content_activity`
        - `engaged_users`
        - `places_checkin_mobile`
        - `views_external_referrals`
        - `views_logged_in_total`
        - `views_logout`
    - Columns removed from staging model `stg_facebook_pages__lifetime_post_metrics_total`:
        - `impressions_fan_paid`

## Documentation Update
- Updated documentation to reflect the current schema. 

## Under the Hood:
- Updated the pull request templates.
- Included auto-releaser GitHub Actions workflow to automate future releases.

# dbt_social_media_reporting v0.3.0
[PR #7](https://github.com/fivetran/dbt_social_media_reporting/pull/7) includes the following breaking changes:
## 🚨 Breaking Changes 🚨:
- This update is made breaking due to the following changes in the [Linkedin Company Pages Fivetran Connector](https://fivetran.com/docs/applications/linkedin-company-pages), the [dbt_linkedin_pages_source](https://github.com/fivetran/dbt_linkedin_pages_source) package, and the [dbt_linkedin_pages](https://github.com/fivetran/dbt_linkedin_pages) package.
    - Deprecated source table `ugc_post_share_content_media`
    - Added source table `post_content` 
    - See the [May 2023 release notes](https://fivetran.com/docs/applications/linkedin-company-pages/changelog#may2023), [dbt_linkedin_pages_source CHANGELOG](https://github.com/fivetran/dbt_linkedin_pages_source/blob/main/CHANGELOG.md), and the [dbt_linkedin_pages CHANGELOG](https://github.com/fivetran/dbt_linkedin_pages/blob/main/CHANGELOG.md) for full details. 

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
