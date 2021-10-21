with unioned as (

    {{ dbt_utils.union_relations(
        [
            ref('social_media_reporting__facebook_posts_reporting_prep'),
            ref('social_media_reporting__linkedin_posts_reporting_prep'),
            ref('social_media_reporting__twitter_posts_reporting_prep'),
            ref('social_media_reporting__instagram_posts_reporting_prep')
        ]
    )}}

)

select *
from unioned