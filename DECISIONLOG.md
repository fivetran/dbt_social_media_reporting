# Decision Log

## Transition from Impressions to Views for Instagram Business
As of April 21, 2025, Instagram has officially deprecated the `impressions` metric across its platform, consolidating various engagement metrics—including impressions, plays, and video views—into a singular `views` metric. This change aims to streamline performance measurement across all content types, such as Reels, Stories, photos, and videos ([source](https://developers.facebook.com/docs/instagram-platform/reference/instagram-media/insights)).

**Decision**  
In response to Instagram's metric consolidation, we have updated our data transformation and reporting processes to align with the new `views` metric. While `views` and the deprecated `impressions` are not identical, `views` serves as the most analogous replacement, capturing the number of times content is displayed or played, including repeated views by the same user.

In our transformation layer, we maintain separate fields for the legacy (`*_impressions`) and new (`*_views`) metrics to preserve transparency and auditability. However, for this rollup package, we have chosen to combine these metrics into a unified `impressions` field, by using `coalesce(*_views, *_impressions)`, to ensure continuity with the other social media platforms.

**Important Note on Duplicate Values**  
Fivetran's Instagram Connector populates multiple fields with the same value for certain media types:
- `CAROUSEL_ALBUM` posts: Both `carousel_album_views` AND `video_photo_views` contain identical values
- `VIDEO` (Reels): Both `reel_views` AND `video_photo_views` contain identical values

To prevent double-counting, the `impressions` calculation in `social_media_reporting__instagram_posts_reporting` counts only `video_photo_views` or `video_photo_impressions`, which is the basis for both `carousel_album` and `reel` impressions/views.
