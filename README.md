[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 
# Social Media Reporting

This dbt package aggregates and models data from multiple Fivetran social media connectors. The package standardizes the schemas from the various social media connectors and creates a single reporting model for all activity. It enables you to analyze your post performance by clicks, impressions, shares, likes, and comments.

Currently, this package supports the following social media connector types:
> NOTE: You do _not_ need to have all of these connector types to use this package, though you should have at least two.
* [Facebook Pages](https://github.com/fivetran/dbt_facebook_pages)
* [Instagram Business](https://github.com/fivetran/dbt_instagram_business)
* [LinkedIn Company Pages](https://github.com/fivetran/dbt_linkedin_pages)
* [Twitter Organic](https://github.com/fivetran/dbt_twitter_organic)

## Models

This package contains a number of models, which all build up to the final `social_media_reporting` model. The `social_media_reporting` model combines the data from all of the connectors. A dependency on all the required dbt packages is declared in this package's `packages.yml` file, so it will automatically download them when you run `dbt deps`. The primary outputs of this package are described below.

| **model**    | **description**                                                                                                        |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| [social_media_reporting__rollup_report](https://github.com/fivetran/dbt_social_media_reporting/blob/main/models/social_media_reporting__rollup_report.sql) | Each record represents a post from a social media account across selected connectors, including post metadata and metrics. |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/social_media_reporting
    version: [">=0.1.0", "<0.2.0"]
```

## Package Maintenance
The Fivetran team maintaining this package **only** maintains the latest version. We highly recommend that you keep your `packages.yml` file updated with the [latest version in the dbt hub](https://hub.getdbt.com/fivetran/social_media_reporting/latest/). Read the [CHANGELOG](/CHANGELOG.md) and release notes for more information on changes across versions.

## Configuration

### Connector selection

The package assumes that all connector models are enabled, so it will look to pull data from all of the connectors [listed above](https://github.com/fivetran/dbt_social_media_reporting#social-media-reporting). If you don't want to use certain connectors, disable those connectors' models in this package by setting the relevant variables to `false`:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    social_media_rollup__twitter_enabled: False
    social_media_rollup__facebook_enabled: False
    social_media_rollup__linkedin_enabled: False
    social_media_rollup__instagram_enabled: False
```

Next, you must disable the models in the unwanted connector's related package, which has its own configuration. Disable the relevant models under the models section of your `dbt_project.yml` file by setting the `enabled` value to `false`. 

_Only include the models you want to disable.  Default values are generally `true` but that is not always the case._

```yml
models:
    # disable both instagram business models if not using instagram business
    instagram_business:
        enabled: false
    instagram_business_source:
        enabled: false
  
    # disable both linkedin company pages models if not using linkedin company pages
    linkedin_pages:
        enabled: false
    linkedin_pages_source:
        enabled: false
  
    # disable both twitter organic models if not using twitter organic
    twitter_organic:
        enabled: false
    twitter_organic_source:
        enabled: false
    
    # disable all three facebook pages models if not using facebook pages
    facebook_pages:
        enabled: false
    facebook_pages_source:
        enabled: false
```
### Data Location

By default, this package looks for your social media data in your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your social media data is stored, add the relevant `_database` variables to your `dbt_project.yml` file (see below). 

By default, this package also looks for specific schemas from each of your connectors. The schemas from each connector are highlighted in the code snippet below. If your data is stored in a different schema, add the relevant `_schema` variables to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    ##Facebook Pages schema and database variables
    facebook_pages_schema: facebook_pages_schema
    facebook_pages_database: facebook_pages_database

    ##LinkedIn Pages schema and database variables
    linkedin_pages_schema: linkedin_pages_schema
    linkedin_pages_database: linkedin_pages_database

    ##Instagram Business schema and database variables
    instagram_business_schema: instagram_business_schema
    instagram_business_database: instagram_business_database

    ##Twitter Organic schema and database variables
    twitter_organic_schema: twitter_organic_schema
    twitter_organic_database: twitter_organic_database
```

### Unioning Multiple Social Media Connectors
If you have multiple social media connectors in Fivetran, you can use this package on all of them simultaneously. The package will union all of the data together and then pass the unioned table(s) into the reporting model. You will be able to see which source the data came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `union_schemas` or `union_databases` variables:

> IMPORTANT: You _cannot_ use both the `union_schemas` and `union_databases` variables.

```yml
# dbt_project.yml
...
config-version: 2
vars:
    ##Schemas variables
    facebook_pages_union_schemas: ['facebook_pages_one','facebook_pages_two']
    linkedin_pages_union_schemas: ['linkedin_company_pages_one', 'linkedin_company_pages_two']
    instagram_business_union_schemas: ['instagram_business_one', 'instagram_business_two', 'instagram_business_three']
    twitter_organic_union_schemas: ['twitter_social_one', 'twitter_social_two', 'twitter_social_three', 'twitter_social_four']

    ##Databases variables
    facebook_pages_union_databases: ['facebook_pages_one','facebook_pages_two']
    linkedin_pages_union_databases: ['linkedin_company_pages_one', 'linkedin_company_pages_two']
    instagram_business_union_databases: ['instagram_business_one', 'instagram_business_two', 'instagram_business_three']
    twitter_organic_union_databases: ['twitter_social_one', 'twitter_social_two', 'twitter_social_three', 'twitter_social_four']
```
For more configuration information, see the individual connector dbt packages ([listed above](https://github.com/fivetran/dbt_social_media_reporting#social-media-reporting)).

## Database Support

This package has been tested on BigQuery, Snowflake, Redshift, PostgreSQL, and Databricks.

### Databricks Dispatch Configuration
dbt `v0.20.0` introduced a new project-level dispatch configuration that enables an "override" setting for all dispatched macros. If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
# dbt_project.yml

dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `main`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [using Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate [dbt transformations with Fivetran](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
