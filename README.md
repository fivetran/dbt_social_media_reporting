<!--section="social-media-reporting_transformation_model"-->
# Social Media Reporting dbt Package

This dbt package transforms data from Fivetran's Social Media Reporting connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 6
- Connector documentation
  - [Facebook Pages connector documentation](https://fivetran.com/docs/connectors/applications/facebook-pages)
  - [Instagram Business connector documentation](https://fivetran.com/docs/connectors/applications/instagram-business)
  - [Twitter Organic connector documentation](https://fivetran.com/docs/connectors/applications/twitter)
  - [Linkedin Pages connector documentation](https://fivetran.com/docs/connectors/applications/linkedin-company-pages)
  - [Youtube Analytics connector documentation](https://fivetran.com/docs/connectors/applications/youtube-analytics)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_social_media_reporting)
  - [dbt Docs](https://fivetran.github.io/dbt_social_media_reporting/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_social_media_reporting/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_social_media_reporting/blob/main/CHANGELOG.md)
- dbt Core™ supported versions
  - `>=1.3.0, <3.0.0`

## What does this dbt package do?
This package enables you to aggregate and model data from multiple Fivetran social media connections, standardize schemas from various social media connections, and analyze post performance by clicks, impressions, shares, likes, and comments. It creates enriched models with metrics focused on unified social media reporting across platforms.

Currently, this package supports the following social media connector types:
  - [Facebook Pages](https://github.com/fivetran/dbt_facebook_pages)
  - [Instagram Business](https://github.com/fivetran/dbt_instagram_business)
  - [LinkedIn Company Pages](https://github.com/fivetran/dbt_linkedin_pages)
  - [Twitter Organic](https://github.com/fivetran/dbt_twitter_organic)
  - [Youtube Analytics](https://github.com/fivetran/dbt_youtube_analytics)
> NOTE: You do _not_ need to have all of these connector types to use this package, though you should have at least two.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_social_media_reporting
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [social_media_reporting__rollup_report](https://fivetran.github.io/dbt_social_media_reporting/#!/model/model.social_media_reporting.social_media_reporting__rollup_report) | Consolidates post performance across multiple social media platforms (Facebook, Instagram, LinkedIn, Twitter, and YouTube Analytics) to compare engagement, reach, and content effectiveness in one unified view. <br></br>**Example Analytics Questions:**<ul><li>Which social media platform drives the highest engagement and reach for your content?</li><li>How does content performance compare across different platforms and account types?</li><li>What posting strategies work best across your entire social media presence?</li></ul>|

### Materialized Models
Each Quickstart transformation job run materializes the following model counts for each selected connector. The total model count represents all staging, intermediate, and final models, materialized as `view`, `table`, or `incremental`:

| **Connector** | **Model Count** |
| ------------- | --------------- |
| Social Media Reporting | 6 |
| [Facebook Pages](https://github.com/fivetran/dbt_facebook_pages) | 11 |
| [Instagram Business](https://github.com/fivetran/dbt_instagram_business) | 7 |
| [LinkedIn Company Pages](https://github.com/fivetran/dbt_linkedin_pages) | 23 |
| [Twitter Organic](https://github.com/fivetran/dbt_twitter_organic) | 11 |
| [Youtube Analytics](https://github.com/fivetran/dbt_youtube_analytics) | 11 |

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Social Media Reporting connection syncing data into your destination.
- A BigQuery, Snowflake, Redshift, Postgres, or Databricks destination.

**Connector**: Have at least one of the below supported Fivetran social media platform connections syncing data into your destination. This package currently supports:
- [Facebook Pages](https://fivetran.com/docs/connectors/applications/facebook-pages)
- [Instagram Business](https://fivetran.com/docs/connectors/applications/instagram-business)
- [LinkedIn Company Pages](https://fivetran.com/docs/connectors/applications/linkedin-company-pages)
- [Twitter Organic](https://fivetran.com/docs/connectors/applications/twitter)
- [Youtube Analytics](https://fivetran.com/docs/connectors/applications/youtube-analytics)

> While you need only one of the above connections to utilize this package, we recommend having at least two to gain the rollup benefit of this package.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_social_media_reporting/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Installing the Package
Include the following github package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/social_media_reporting
    version: [">=1.6.0", "<1.7.0"] # we recommend using ranges to capture non-breaking changes automatically
```
Do NOT include the upstream social media packages in this file. The transformation package itself has a dependency on it and will install the upstream packages as well.

Do NOT include the individual social media packages in this file. This package has dependencies on the packages and will install them as well.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Define database and schema variables
#### Option A: Single connection(s)
By default, this package looks for your Social Media data in your target database. If this is not where your Social Media data is stored, add the relevant `<connector>_database` variables to your `dbt_project.yml` file (see below).

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

#### Option B: Union multiple connections
If you have multiple social media platform connections of the same type in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

To use this functionality, you will need to set the below variables in your root `dbt_project.yml` file:
```yml
# dbt_project.yml

vars:
  facebook_pages_sources:
    - database: connection_1_destination_name # Required
      schema: connection_1_schema_name # Required
      name: connection_1_source_name # Required only if following the step in the following subsection

    - database: connection_2_destination_name
      schema: connection_2_schema_name
      name: connection_2_source_name

  instagram_business_sources:
    - database: connection_1_destination_name # Required
      schema: connection_1_schema_name # Required
      name: connection_1_source_name # Required only if following the step in the following subsection

    - database: connection_2_destination_name
      schema: connection_2_schema_name
      name: connection_2_source_name

  twitter_organic_sources:
    - database: connection_1_destination_name # Required
      schema: connection_1_schema_name # Required
      name: connection_1_source_name # Required only if following the step in the following subsection

    - database: connection_2_destination_name
      schema: connection_2_schema_name
      name: connection_2_source_name

  linkedin_pages_sources:
    - database: connection_1_destination_name # Required
      schema: connection_1_schema_name # Required
      name: connection_1_source_name # Required only if following the step in the following subsection

    - database: connection_2_destination_name
      schema: connection_2_schema_name
      name: connection_2_source_name

  youtube_analytics_sources:
    - database: connection_1_destination_name # Required
      schema: connection_1_schema_name # Required
      name: connection_1_source_name # Required only if following the step in the following subsection

    - database: connection_2_destination_name
      schema: connection_2_schema_name
      name: connection_2_source_name
```

> Previous versions of this package employed two separate, mutually exclusive variables for unioning for each platform: (eg. `facebook_pages_union_schemas` and `facebook_pages_union_databases`). While these variables are still supported, the new approach shared above are the recommended variables to configure.

#### Optional: Incorporate unioned sources into DAG

If you use [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore) and are unioning multiple social media platform connections of the same type, you can define your sources in a property `.yml` file. Set the variable `has_defined_sources: true` in your `dbt_project.yml`. Otherwise, your connections won't appear in your DAG. See the `union_connections` macro [documentation](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#optional-union-connections-defined-sources-configuration) for full configuration details.

### Enabling/Disabling Models
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
        +enabled: false

    # disable linkedin company pages models if not using linkedin company pages
    linkedin_pages:
        +enabled: false

    # disable twitter organic models if not using twitter organic
    twitter_organic:
        +enabled: false

    # disable facebook pages models if not using facebook pages
    facebook_pages:
        +enabled: false

    # disable youtube analytics models if not using youtube analytics
    youtube_analytics:
        +enabled: false
```

### (Optional) Additional configurations
#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See the Facebook Pages [`dbt_project.yml`](https://github.com/fivetran/dbt_facebook_pages/blob/main/dbt_project.yml), Instagram Business [`dbt_project.yml`](https://github.com/fivetran/dbt_instagram_business/blob/main/dbt_project.yml), LinkedIn Company Pages [`dbt_project.yml`](https://github.com/fivetran/dbt_linkedin_pages/blob/main/dbt_project.yml), Twitter Organic [`dbt_project.yml`](https://github.com/fivetran/dbt_twitter_organic/blob/main/dbt_project.yml), and Youtube Analytics [`dbt_project.yml`](https://github.com/fivetran/dbt_youtube_analytics/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    <default_source_table_name>_identifier: your_table_name 
```

#### Source casing for case-sensitive destinations
By default, the package applies case-insensitive comparisons when resolving `source_relation` values. If your destination is case-sensitive and you want downstream transformations to respect the exact casing of your source database and schema names, set the following variable:

```yml
vars:
    fivetran_using_source_casing: true
```

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
```yml
packages:
    - package: fivetran/facebook_pages
      version: [">=1.3.0", "<1.4.0"]

    - package: fivetran/instagram_business
      version: [">=1.2.0", "<1.3.0"]

    - package: fivetran/twitter_organic
      version: [">=1.2.0", "<1.3.0"]

    - package: fivetran/linkedin_pages
      version: [">=1.4.0", "<1.5.0"]

    - package: fivetran/youtube_analytics
      version: [">=1.2.0", "<1.3.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

<!--section="social-media-reporting_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/social_media_reporting/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_social_media_reporting/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

<!--section-end-->

## Are there any resources available?
- If you encounter any questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_social_media_reporting/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran, or would like to request a future dbt package to be developed, then feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
