# Decision Log

## Transition from Impressions to Views for Instagram Business
As of April 21, 2025, Instagram has officially deprecated the `impressions` metric across its platform, consolidating various engagement metrics—including impressions, plays, and video views—into a singular `views` metric. This change aims to streamline performance measurement across all content types, such as Reels, Stories, photos, and videos ([source](https://developers.facebook.com/docs/instagram-platform/reference/instagram-media/insights)).

**Decision**  
In response to Instagram's metric consolidation, we have updated our data transformation and reporting processes to align with the new `views` metric. While `views` and the deprecated `impressions` are not identical, `views` serves as the most analogous replacement, capturing the number of times content is displayed or played, including repeated views by the same user.

In our transformation layer, we maintain separate fields for the legacy (`*_impressions`) and new (`*_views`) metrics to preserve transparency and auditability. However, for this rollup package, we have chosen to combine these metrics into a unified `impressions` field to ensure continuity with the other social media platforms.