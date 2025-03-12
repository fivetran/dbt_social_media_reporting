# Social Media Reporting dbt Package ([Docs](https://fivetran.github.io/dbt_social_media_reporting/))
<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_social_media_reporting/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

## What does this dbt package do?

This dbt package aggregates and models data from multiple Fivetran social media connections. The package standardizes the schemas from the various social media connections and creates a single reporting model for all activity. It enables you to analyze your post performance by clicks, impressions, shares, likes, and comments.

Currently, this package supports the following social media connector types:
  - [Facebook Pages](https://github.com/fivetran/dbt_facebook_pages)
  - [Instagram Business](https://github.com/fivetran/dbt_instagram_business)
  - [LinkedIn Company Pages](https://github.com/fivetran/dbt_linkedin_pages)
  - [Twitter Organic](https://github.com/fivetran/dbt_twitter_organic)
  - [Youtube Analytics](https://github.com/fivetran/dbt_youtube_analytics)
> NOTE: You do _not_ need to have all of these connector types to use this package, though you should have at least two.
- Generates a comprehensive data dictionary of your source and modeled Social Media Reporting data via the [dbt docs site](https://fivetran.github.io/dbt_social_media_reporting/)

<!--section="social_media_reporting_transformation_model-->
This package contains a number of tables, which all build up to the final `social_media_reporting` table. The `social_media_reporting` table combines the data from all of the connections.

| **Table**    | **Description**                                                                                                        |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| [social_media_reporting__rollup_report](https://github.com/fivetran/dbt_social_media_reporting/blob/main/models/social_media_reporting__rollup_report.sql) | Each record represents a post from a social media account across selected connections, including post metadata and metrics. |

### Materialized Models
Each Quickstart transformation job run materializes the following model counts for each selected connector. The total model count represents all staging, intermediate, and final models, materialized as `view`, `table`, or `incremental`:

| **Connector** | **Model Count** |
| ------------- | --------------- |
| Social Media Reporting | 5 |
| [Facebook Pages](https://github.com/fivetran/dbt_facebook_pages) | 11 |
| [Instagram Business](https://github.com/fivetran/dbt_instagram_business) | 7 |
| [LinkedIn Company Pages](https://github.com/fivetran/dbt_linkedin_pages) | 15 |
| [Twitter Organic](https://github.com/fivetran/dbt_twitter_organic) | 11 |
| [Youtube Analytics](https://github.com/fivetran/dbt_youtube_analytics) | 11 |
<!--section-end-->

## How do I use the dbt package?
### Step 1: Pre-Requisites
**Connector**: Have at least one of the below supported Fivetran ad platform connections syncing data into your destination. This package currently supports:
- [Facebook Pages](https://fivetran.com/docs/connectors/applications/facebook-pages)
- [Instagram Business](https://fivetran.com/docs/connectors/applications/instagram-business)
- [LinkedIn Company Pages](https://fivetran.com/docs/connectors/applications/linkedin-company-pages)
- [Twitter Organic](https://fivetran.com/docs/connectors/applications/twitter)
- [Youtube Analytics](https://fivetran.com/docs/connectors/applications/youtube-analytics)

> While you need only one of the above connections to utilize this package, we recommend having at least two to gain the rollup benefit of this package.

- **Database support**: This package has been tested on **BigQuery**, **Snowflake**, **Redshift**, **Postgres** and **Databricks**. Ensure you are using one of these supported databases.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Installing the Package
Include the following github package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/social_media_reporting
    version: [">=0.6.0", "<0.7.0"] # we recommend using ranges to capture non-breaking changes automatically
```
Do NOT include the upstream social media packages in this file. The transformation package itself has a dependency on it and will install the upstream packages as well.

Do NOT include the individual social media packages in this file. This package has dependencies on the packages and will install them as well.

### Step 3: Configure Database and Schema Variables
By default, this package looks for your social media reporting data in your target database. If this is not where your app platform data is stored, add the relevant `<connection>_database` variables to your `dbt_project.yml` file (see below).

```yml
vars:
    ##Facebook Pages schema and database variables
    facebook_pages_schema: facebook_pages_schema
    facebook_pages_database: facebook_pages_database

    ##Instagram Business schema and database variables
    instagram_business_schema: instagram_business_schema
    instagram_business_database: instagram_business_database

    ##LinkedIn Pages schema and database variables
    linkedin_pages_schema: linkedin_pages_schema
    linkedin_pages_database: linkedin_pages_database

    ##Twitter Organic schema and database variables
    twitter_organic_schema: twitter_organic_schema
    twitter_organic_database: twitter_organic_database

    ##Youtube Analytics schema and database variables
    youtube_analytics_schema: youtube_analytics_schema
    youtube_analytics_database: youtube_analytics_database
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See the Facebook Pages [`dbt_project.yml`](https://github.com/fivetran/dbt_facebook_pages_source/blob/main/dbt_project.yml), Instagram Business [`dbt_project.yml`](https://github.com/fivetran/dbt_instagram_business_source/blob/main/dbt_project.yml), LinkedIn Company Pages [`dbt_project.yml`](https://github.com/fivetran/dbt_linkedin_pages_source/blob/main/dbt_project.yml), Twitter Organic [`dbt_project.yml`](https://github.com/fivetran/dbt_twitter_organic_source/blob/main/dbt_project.yml), and Youtube Analytics [`dbt_project.yml`](https://github.com/fivetran/dbt_youtube_analytics_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    <default_source_table_name>_identifier: your_table_name 
```

### Step 4: Enabling/Disabling Models
The package assumes that all connector models are enabled, so it will look to pull data from all of the connections [listed above](https://github.com/fivetran/dbt_social_media_reporting#social-media-reporting). If you don't want to use certain connections, disable those connections' models in this package by setting the relevant variables to `false`:

```yml
vars:
    social_media_rollup__twitter_enabled: False
    social_media_rollup__facebook_enabled: False
    social_media_rollup__linkedin_enabled: False
    social_media_rollup__instagram_enabled: False
    social_media_rollup__youtube_enabled: False
```

Next, you must disable the models in the unwanted connection's related package, which has its own configuration. Disable the relevant models under the models section of your `dbt_project.yml` file by setting the `enabled` value to `false`.

_Only include the models you want to disable.  Default values are generally `true` but that is not always the case._

```yml
models:
    # disable instagram business models if not using instagram business
    instagram_business:
        enabled: false
    instagram_business_source:
        enabled: false
  
    # disable linkedin company pages models if not using linkedin company pages
    linkedin_pages:
        enabled: false
    linkedin_pages_source:
        enabled: false
  
    # disable twitter organic models if not using twitter organic
    twitter_organic:
        enabled: false
    twitter_organic_source:
        enabled: false
    
    # disable facebook pages models if not using facebook pages
    facebook_pages:
        enabled: false
    facebook_pages_source:
        enabled: false
    
    # disable youtube analytics models if not using youtube analytics
    youtube_analytics:
        enabled: false
    youtube_analytics_source:
        enabled: false
```

### (Optional) Step 5: Additional configurations
#### Unioning Multiple Social Media Connections
If you have multiple social media connections in Fivetran, you can use this package on all of them simultaneously. The package will union all of the data together and then pass the unioned table(s) into the reporting model. You will be able to see which source the data came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `union_schemas` or `union_databases` variables:

> IMPORTANT: You _cannot_ use both the `union_schemas` and `union_databases` variables.

```yml
vars:
    ##Schemas variables
    facebook_pages_union_schemas: ['facebook_pages_one','facebook_pages_two']
    linkedin_pages_union_schemas: ['linkedin_company_pages_one', 'linkedin_company_pages_two']
    instagram_business_union_schemas: ['instagram_business_one', 'instagram_business_two', 'instagram_business_three']
    twitter_organic_union_schemas: ['twitter_social_one', 'twitter_social_two', 'twitter_social_three', 'twitter_social_four']
    youtube_analytics_union_schemas: ['youtube_analytics_one','youtube_analytics_two']

    ##Databases variables
    facebook_pages_union_databases: ['facebook_pages_one','facebook_pages_two']
    linkedin_pages_union_databases: ['linkedin_company_pages_one', 'linkedin_company_pages_two']
    instagram_business_union_databases: ['instagram_business_one', 'instagram_business_two', 'instagram_business_three']
    twitter_organic_union_databases: ['twitter_social_one', 'twitter_social_two', 'twitter_social_three', 'twitter_social_four']
    youtube_analytics_union_databases: ['youtube_analytics_one','youtube_analytics_two']
```
For more configuration information, see the individual connector dbt packages ([listed above](https://github.com/fivetran/dbt_social_media_reporting#social-media-reporting)).

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
```yml
packages:
    - package: fivetran/facebook_pages
      version: [">=0.3.0", "<0.4.0"]

    - package: fivetran/facebook_pages_source
      version: [">=0.3.0", "<0.4.0"]

    - package: fivetran/instagram_business
      version: [">=0.2.0", "<0.3.0"]

    - package: fivetran/instagram_business_source
      version: [">=0.2.0", "<0.3.0"]

    - package: fivetran/twitter_organic
      version: [">=0.3.0", "<0.4.0"]

    - package: fivetran/twitter_organic_source
      version: [">=0.3.0", "<0.4.0"]

    - package: fivetran/linkedin_pages
      version: [">=0.3.0", "<0.4.0"]

    - package: fivetran/linkedin_pages_source
      version: [">=0.3.0", "<0.4.0"]

    - package: fivetran/youtube_analytics
      version: [">=0.5.0", "<0.6.0"]

    - package: fivetran/youtube_analytics_source
      version: [">=0.5.0", "<0.6.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package **only** maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/github/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_social_media_reporting/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
These dbt packages are developed by a small team of analytics engineers at Fivetran. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Are there any resources available?
- If you encounter any questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_social_media_reporting/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran, or would like to request a future dbt package to be developed, then feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
