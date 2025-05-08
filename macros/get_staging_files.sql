{% macro get_staging_files() %}

    {% set staging_file = [] %}

    {% if var('social_media_rollup__twitter_enabled', True) %} 
    {% do staging_file.append(ref('social_media_reporting__twitter_posts_reporting')) %}
    {% endif %}

    {% if var('social_media_rollup__facebook_enabled', True) %} 
    {% do staging_file.append(ref('social_media_reporting__facebook_posts_reporting')) %}
    {% endif %}

    {% if var('social_media_rollup__linkedin_enabled', True) %} 
    {% do staging_file.append(ref('social_media_reporting__linkedin_posts_reporting')) %}
    {% endif %}

    {% if var('social_media_rollup__instagram_enabled', True) %} 
    {% do staging_file.append(ref('social_media_reporting__instagram_posts_reporting')) %}
    {% endif %}

    {% if var('social_media_rollup__youtube_enabled', True) %} 
    {% do staging_file.append(ref('social_media_reporting__youtube_videos_reporting')) %}
    {% endif %}

    {{ return(staging_file) }}

{% endmacro %}