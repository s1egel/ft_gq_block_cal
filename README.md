### What does this Block do for me?

**(1) Replicate Existing AdWords Reports + More** - Replicate all your existing AdWords reports and dashboards in a matter of minutes or hours to make the switch to Looker seamless. Plus, enjoy all the additional value-add analysis that comes turney with this plug-and-play model and dashboards. Time-to-value for a new data tool has never been quicker.

**(2) Usable / Shareable Dashboards** - create centralized dashboards for the entire team, and departmental or individual dashboards for each user, and rest easy knowing everyone is looking at the same information at all times. Then schedule the dashboard for emails or alerts, period-end reporting, anomaly detection, or whatever else serves your use-case.

**(3) Expertise** - Leverage analytics expertise of Looker + AdWords product teams, who assembled this Block based on years of AdWords experience with industry-leading companies.


### Block Info

This block is built on top of the Fivetran AdWords data connectors.  _The complete setup from data source to dashboard requires about 20 minutes of work._ More information about Fivetran: www.fivetran.com

The AdWords data model is documented here in [Google's docs](https://developers.google.com/adwords/api/docs/guides/objects-methods). The schema documentation for AdWords can be found in [Google's docs](https://developers.google.com/adwords/api/docs/appendix/reports). Please note that your naming might vary slightly.


### Google AdWords Raw Data Structure

There are several primary entities included in the AdWords data set: ad, ad group, campaign, customer, keyword, etc. Each of these entites has an "Attributes" table and a corresponding "Stats" and "Hourly Stats" table. The Attributes tables are history tables, that contain the state of the ad, ad group, campaign, etc at the end of that day.  The Stats tables are aggregations at a daily or hourly level. For example, the "campaign" table contains attributes for each campaign, such as the campaign name and campaign status. The corresponding stats table - "Campaign Stats" contains metrics such as impressions, clicks, and conversions.


### Block Structure

* **Entity Base** - This file contains all the common entity tables found across all AdWords deployments. If you have additional entities you'd like to include, simply bring them into the Looker and model them the same way. Full documentation on each entity table and each metric can be found in [Google's documentation](https://developers.google.com/adwords/api/docs/appendix/reports).

* **Master Basic Stats** - This file contains all the metrics (measures / aggregations) for each corresponding entity.

* **Base Quarter Stats** - Many customers prefer to view AdWords data at the quarterly level to gauge performance and, more importantly, understand budget implicications. This file contains several quarterly overviews to help users analyze performance and budget spend at the quarter interval.


### Implementation Instructions / Required Customizations

1) Add the Adwords Account connector, while will deliver the `account`, `campaign`, `ad_group`, `ad`, `audience`, and `keyword` tables.

2) Add 9 Adwords Reporting connectors for each of the Pre-Built reports:
- ACCOUNT_STATS
- ACCOUNT_HOURLY_STATS
- AD_STATS
- AD_GROUP_STATS
- AD_GROUP_HOURLY_STATS
- AUDIENCE_STATS
- CAMPAIGN_STATS
- CAMPAIGN_HOURLY_STATS
- KEYWORD_STATS

Note: Use the same schema name for all of the connectors. Use the lower-case names of the Pre-Built reports for table names. Eg: ACCOUNT_STATS uses table name `account_stats`

3) Update the LookML with your schema:

* **sql_schema_name** - in each of the views, the `sql_schema_name` parameter must be changed to match your schema. This is easily accomplished using a global Find & Replace (available in the top right of your screen)

* **Dashboards** - rename the model in each LookML Dashboard element from "google_adwords" to the model name you've selected. We also recommend using a global Find & Replace for this.

### Customization

This block can be extended by replicating the Attributes and Stats tables for other data sources.  You can also add more Fivetran Adwords Reporting connectors with custom configuration to answer different questions. We'd love to hear about the cool ways you are using this block! Reach out to us: support@fivetran.com.

### What if I find an error? Suggestions for improvements?

Great! Blocks were designed for continuous improvement through the help of the entire Looker community, and we'd love your input. To log an error or improvement recommentation, simply create a "New Issue" in the corresponding [Github repo for this Block](https://github.com/fivetran/google_adwords_looker/issues). Please be as detailed as possible in your explanation, and we'll address it as quick as we can.

### Reporting Schema Layout


![image](https://cloud.githubusercontent.com/assets/9888083/26472690/18f621d0-415c-11e7-85fc-e77334847757.png)
