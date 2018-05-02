view: ad_criterion_base {
  extension: required

  dimension: unique_key {
    type:  string
    hidden: yes
    sql: (CAST(${ad_group_id} AS VARCHAR) + CAST(${criterion_id} AS VARCHAR)) ;;
  }
}


view: entity_base {
  extension: required

  dimension_group: _data {
    description: "Filter on this field to limit query to a specified date range"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year
    ]
    convert_tz: no
    sql: TIMESTAMP(${_data}) ;;
  }


  dimension: latest {
    type: yesno
    sql: ${TABLE}.date = GETDATE() ;;
  }
}


view: base {
  extends: [entity_base]
  extension: required

  dimension: _data_day_of_quarter {
    hidden: yes
    group_label: "Data Date"
    label: "Day of Quarter"
    type: number
    sql: DATEDIFF(DAY,
           ${_data_date},
          CAST((${_data_quarter} + '-01') as DATE)
            ) + 1
       ;;
  }

  dimension: current_day_of_quarter {
    hidden: yes
    type:  number
    sql: DATEDIFF(DAY, GETDATE() , DATEPART(QUARTER, GETDATE() )) ;;
  }

  dimension: less_than_current_day_of_quarter {
    type: yesno
    sql: ${_data_day_of_quarter} < ${current_day_of_quarter} ;;
  }

  dimension: _data_next_quarter {
    hidden: yes
    type: date
    sql: DATEADD(QUARTER, 1, CAST((${_data_quarter} + '-01') as DATE)) ;;
  }

  dimension:  _data_days_in_quarter {
    hidden: yes
    type: number
    sql: DATEDIFF( DAY,
           ${_data_next_quarter},
           CAST((${_data_quarter} + '-01') as DATE)
            ) ;;
  }

  measure: _data_max_day_of_week_index {
    hidden: yes
    type: max
    sql: ${_data_day_of_week_index} ;;
  }

  measure: _data_max_day_of_month {
    hidden: yes
    type: max
    sql: ${_data_day_of_month} ;;
  }

  measure: _data_max_day_of_quarter {
    hidden: yes
    type: max
    sql: ${_data_day_of_quarter} ;;
  }

  measure: _data_max_day_of_year {
    hidden: yes
    type: max
    sql: ${_data_day_of_year} ;;
  }

  dimension: ad_network_type1 {
    hidden: yes
  }

  dimension: ad_network_type2 {
    hidden: yes
  }

  dimension: ad_network_type {
    type: string
    sql: CASE
      WHEN ${ad_network_type1} = 'SHASTA_AD_NETWORK_TYPE_1_SEARCH' AND ${ad_network_type2} = 'SHASTA_AD_NETWORK_TYPE_2_SEARCH'
        THEN 'Search'
      WHEN ${ad_network_type1} = 'SHASTA_AD_NETWORK_TYPE_1_SEARCH' AND ${ad_network_type2} = 'SHASTA_AD_NETWORK_TYPE_2_SEARCH_PARTNERS'
        THEN 'Search Partners'
      WHEN ${ad_network_type1} = 'SHASTA_AD_NETWORK_TYPE_1_CONTENT'
        THEN 'Content'
      ELSE 'Other'
      END
      ;;
  }

  dimension: device {
    hidden: yes
  }

  dimension: device_type {
    type: string
    sql:  CASE
      WHEN UPPER(${device}) LIKE '%COMPUTER%' THEN 'Desktop'
      WHEN UPPER(${device}) LIKE '%MOBILE%' THEN 'Mobile'
      WHEN UPPER(${device}) LIKE '%TABLET%' THEN 'Tablet'
      ELSE 'Unknown' END;;
  }
}


view: ad {
  extends: [entity_base]
  sql_table_name: adwords.adads_stats ;;

  dimension: _data {
    sql: ${TABLE}.date ;;
  }

  dimension: _latest {
    sql: TIMESTAMP(GETDATE()) ;;
  }

  dimension: ad_group_ad_disapproval_reasons {
    type: string
    sql: ${TABLE}.ad_group_ad_disapproval_reasons ;;
  }

  dimension: ad_group_ad_trademark_disapproved {
    type: yesno
    sql: ${TABLE}.ad_group_ad_trademark_disapproved ;;
  }

  dimension: ad_group_id {
    type: number
    sql: ${TABLE}.ad_group_id ;;
  }

  dimension: ad_type {
    type: string
    sql: ${TABLE}.ad_type ;;
  }

  dimension: business_name {
    type: string
    sql: ${TABLE}.business_name ;;
  }

  dimension: call_only_phone_number {
    type: string
    sql: ${TABLE}.call_only_phone_number ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: creative_approval_status {
    type: string
    sql: ${TABLE}.creative_approval_status ;;
  }

  dimension: creative_destination_url {
    type: string
    sql: ${TABLE}.creative_destination_url ;;
  }

  dimension: creative_final_app_urls {
    type: string
    sql: ${TABLE}.creative_final_app_urls ;;
  }

  dimension: creative_final_mobile_urls {
    type: string
    sql: ${TABLE}.creative_final_mobile_urls ;;
  }

  dimension: creative_final_urls {
    type: string
    sql: ${TABLE}.creative_final_urls ;;
  }

  dimension: creative_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: creative_tracking_url_template {
    type: string
    sql: ${TABLE}.creative_tracking_url_template ;;
  }

  dimension: creative_url_custom_parameters {
    type: string
    sql: ${TABLE}.creative_url_custom_parameters ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: description1 {
    type: string
    sql: ${TABLE}.description1 ;;
  }

  dimension: description2 {
    type: string
    sql: ${TABLE}.description2 ;;
  }

  dimension: device_preference {
    type: number
    sql: ${TABLE}.device_preference ;;
  }

  dimension: display_url {
    type: string
    sql: ${TABLE}.display_url ;;
  }

  dimension: enhanced_display_creative_logo_image_media_id {
    type: number
    sql: ${TABLE}.enhanced_display_creative_logo_image_media_id ;;
  }

  dimension: enhanced_display_creative_marketing_image_media_id {
    type: number
    sql: ${TABLE}.enhanced_display_creative_marketing_image_media_id ;;
  }

  dimension: external_customer_id {
    type: number
    sql: ${TABLE}.external_customer_id ;;
  }

  dimension: headline {
    type: string
    sql: ${TABLE}.headline ;;
  }

  dimension: headline_part1 {
    type: string
    sql: ${TABLE}.headline_part_1 ;;
  }

  dimension: headline_part2 {
    type: string
    sql: ${TABLE}.headline_part_2 ;;
  }

  dimension: image_ad_url {
    type: string
    sql: ${TABLE}.image_ad_url ;;
  }

  dimension: image_creative_image_height {
    type: number
    sql: ${TABLE}.image_creative_image_height ;;
  }

  dimension: image_creative_image_width {
    type: number
    sql: ${TABLE}.image_creative_image_width ;;
  }

  dimension: image_creative_name {
    type: string
    sql: ${TABLE}.image_creative_name ;;
  }

  dimension: label_ids {
    type: string
    sql: ${TABLE}.label_ids ;;
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: long_headline {
    type: string
    sql: ${TABLE}.long_headline ;;
  }

  dimension: path1 {
    type: string
    sql: ${TABLE}.path_1 ;;
  }

  dimension: path2 {
    type: string
    sql: ${TABLE}.path_2 ;;
  }

  dimension: short_headline {
    type: string
    sql: ${TABLE}.short_headline ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: trademarks {
    type: string
    sql: ${TABLE}.trademarks ;;
  }

  dimension: creative {
    type: string
    sql:
        COALESCE((${headline} + '\n'),'')
      + COALESCE((${headline_part1} + '\n'),'')
      + COALESCE((${headline_part2} + '\n'),'')
      + COALESCE((${description} + '\n'),'')
      + COALESCE((${description1} + '\n'),'')
      + COALESCE((${description2} + '\n'),'')
       ;;
    link: {
      url: "https://adwords.google.com"
      icon_url: "https://www.gstatic.com/awn/awsm/brt/awn_awsm_20171108_RC00/aw_blend/favicon.ico"
      label: "Change Bid"
    }
  }

  dimension: display_headline {
    type: string
    sql:
        COALESCE((${headline} + "\n"),"")
      + COALESCE((${headline_part1} + "\n"),"") ;;
  }

  measure: count {
    type: count_distinct
    sql: ${ad_group_id} ;;
    drill_fields: [detail*]
  }

  # ----- Detail ------
  set: detail {
    fields: [creative_id, status, ad_type, creative]
  }
}


view: ad_group {
  extends: [entity_base]
  sql_table_name: adwords.adgroup_stats;;

  dimension: _data {
    sql: ${TABLE}.date ;;
  }

  dimension: _latest {
    sql: TIMESTAMP(GETDATE()) ;;
  }

  dimension: ad_group_desktop_bid_modifier {
    type: number
    sql: ${TABLE}.ad_group_desktop_bid_modifier ;;
  }

  dimension: ad_group_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.ad_group_id ;;
  }

  dimension: ad_group_mobile_bid_modifier {
    type: number
    sql: ${TABLE}.ad_group_mobile_bid_modifier ;;
  }

  dimension: ad_group_name {
    type: string
    sql: ${TABLE}.ad_group_name ;;
    link: {
      label: "Ad Group Dashboard"
      url: "/dashboards/google_adwords::ad_performance?Ad%20Group%20Name={{ value | encode_uri }}&Campaign%20Name={{ campaign.campaign_name._value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
    required_fields: [campaign.campaign_name]
  }

  dimension: ad_group_status {
    type: string
    sql: ${TABLE}.ad_group_status ;;
  }

  dimension: ad_group_tablet_bid_modifier {
    type: number
    sql: ${TABLE}.ad_group_tablet_bid_modifier ;;
  }

  dimension: bid_type {
    type: string
    sql: ${TABLE}.bid_type ;;
  }

  dimension: bidding_strategy_id {
    type: number
    sql: ${TABLE}.bidding_strategy_id ;;
  }

  dimension: bidding_strategy_name {
    type: string
    sql: ${TABLE}.bidding_strategy_name ;;
  }

  dimension: bidding_strategy_source {
    type: string
    sql: ${TABLE}.bidding_strategy_source ;;
  }

  dimension: bidding_strategy_type {
    type: string
    sql: ${TABLE}.bidding_strategy_type ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: content_bid_criterion_type_group {
    type: string
    sql: ${TABLE}.content_bid_criterion_type_group ;;
  }

  dimension: cpc_bid {
    hidden: yes
    type: string
    sql: ${TABLE}.cpc_bid ;;
  }

  dimension: cpm_bid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.cpm_bid ;;
  }

  dimension: cpv_bid {
    hidden: yes
    type: string
    sql: ${TABLE}.cpv_bid ;;
  }

  dimension: enhanced_cpc_enabled {
    type: yesno
    sql: ${TABLE}.enhanced_cpc_enabled ;;
  }

  dimension: enhanced_cpv_enabled {
    type: yesno
    sql: ${TABLE}.enhanced_cpv_enabled ;;
  }

  dimension: external_customer_id {
    type: number
    sql: ${TABLE}.external_customer_id ;;
  }

  dimension: label_ids {
    type: string
    sql: ${TABLE}.label_ids ;;
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: target_cpa {
    hidden: yes
    type: number
    sql: ${TABLE}.target_cpa ;;
  }

  dimension: target_cpa_bid_source {
    type: string
    sql: ${TABLE}.target_cpa_bid_source ;;
  }

  dimension: tracking_url_template {
    type: string
    sql: ${TABLE}.tracking_url_template ;;
  }

  dimension: url_custom_parameters {
    type: string
    sql: ${TABLE}.url_custom_parameters ;;
  }

  measure: count {
    type: count_distinct
    sql: ${ad_group_id} ;;
    drill_fields: [detail*]
  }

  dimension: cpc_bid_usd {
    type: number
    sql: ${cpc_bid}  ;;
  }

  dimension: cpm_bid_usd {
    type: number
    sql: ${cpm_bid} ;;
  }

  dimension: cpv_bid_usd {
    type: number
    sql: ${cpv_bid} ;;
  }

  dimension: target_cpa_usd {
    type: number
    sql: ${target_cpa} ;;
  }

  # ----- Detail ------
  set: detail {
    fields: [ad_group_id, ad_group_name, ad_group_status, cpc_bid, ad.count, keyword.count]
  }
}


view: audience {
  extends: [entity_base]
  sql_table_name: adwords.adaudience_stats;;

  dimension: _data {
    sql: ${TABLE}.date ;;
  }

  dimension: _latest {
    sql: TIMESTAMP(GETDATE()) ;;
  }

  dimension: unique_key {
    type: string
    primary_key: yes
    hidden: yes
    sql: (CAST(${ad_group_id} AS VARCHAR) + CAST(${criterion_id} AS VARCHAR)) ;;
  }

  dimension: ad_group_id {
    type: number
    sql: ${TABLE}.ad_group_id ;;
  }

  dimension: base_ad_group_id {
    type: number
    sql: ${TABLE}.base_ad_group_id ;;
  }

  dimension: base_campaign_id {
    type: number
    sql: ${TABLE}.base_campaign_id ;;
  }

  dimension: bid_modifier {
    type: number
    sql: ${TABLE}.bid_modifier ;;
  }

  dimension: bid_type {
    type: string
    sql: ${TABLE}.bid_type ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: cpc_bid {
    type: string
    sql: ${TABLE}.cpc_bid ;;
  }

  dimension: cpc_bid_source {
    type: string
    sql: ${TABLE}.cpc_bid_source ;;
  }

  dimension: cpm_bid {
    type: number
    value_format_name: id
    sql: ${TABLE}.cpm_bid ;;
  }

  dimension: cpm_bid_source {
    type: string
    sql: ${TABLE}.cpm_bid_source ;;
  }

  dimension: criteria {
    type: string
    sql: ${TABLE}.criteria ;;
  }

  dimension: criteria_destination_url {
    type: string
    sql: ${TABLE}.criteria_destination_url ;;
  }

  dimension: criterion_id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: external_customer_id {
    type: number
    sql: ${TABLE}.external_customer_id ;;
  }

  dimension: final_app_urls {
    type: string
    sql: ${TABLE}.final_app_urls ;;
  }

  dimension: final_mobile_urls {
    type: string
    sql: ${TABLE}.final_mobile_urls ;;
  }

  dimension: final_urls {
    type: string
    sql: ${TABLE}.final_urls ;;
  }

  dimension: is_negative {
    type: yesno
    sql: ${TABLE}.is_negative ;;
  }

  dimension: is_restrict {
    type: yesno
    sql: ${TABLE}.is_restrict ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: tracking_url_template {
    type: string
    sql: ${TABLE}.tracking_url_template ;;
  }

  dimension: url_custom_parameters {
    type: string
    sql: ${TABLE}.url_custom_parameters ;;
  }

  dimension: user_list_name {
    type: string
    sql: ${TABLE}.user_list_name ;;
  }

  measure: count {
    type: count_distinct
    sql:  ${criterion_id} ;;
    drill_fields: [detail*]
  }

  # ----- Detail ------
  set: detail {
    fields: [criteria]
  }
}


view: customer {
  extends: [entity_base]
  sql_table_name: adwords.adcustomer;;

  dimension: _data {
    sql: ${TABLE}.date ;;
  }

  dimension: _latest {
    sql: TIMESTAMP(GETDATE()) ;;
  }

  dimension: account_currency_code {
    type: string
    sql: ${TABLE}.account_currency_code ;;
  }

  dimension: account_descriptive_name {
    type: string
    sql: ${TABLE}.account_descriptive_name ;;
  }

  dimension: account_time_zone_id {
    type: string
    sql: ${TABLE}.account_time_zone_id ;;
  }

  dimension: can_manage_clients {
    type: yesno
    sql: ${TABLE}.can_manage_clients ;;
  }

  dimension: customer_descriptive_name {
    type: string
    sql: ${TABLE}.customer_descriptive_name ;;
    link: {
      label: "Account Dashboard"
      url: "/dashboards/google_adwords::account_performance?Customer%20Name={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
  }

  dimension: external_customer_id {
    type: number
    sql: ${TABLE}.external_customer_id ;;
  }

  dimension: is_auto_tagging_enabled {
    type: yesno
    sql: ${TABLE}.is_auto_tagging_enabled ;;
  }

  dimension: is_test_account {
    type: yesno
    sql: ${TABLE}.is_test_account ;;
  }

  dimension: primary_company_name {
    type: string
    sql: ${TABLE}.primary_company_name ;;
  }

  measure: count {
    type: count_distinct
    sql: ${external_customer_id} ;;
    drill_fields: [detail*]
  }

  # ----- Detail ------
  set: detail {
    fields: [external_customer_id, primary_company_name]
  }
}


view: campaign {
  extends: [entity_base]
  sql_table_name: adwords.adcampaign_stats;;

  dimension: _data {
    sql: ${TABLE}.date;;
  }

  dimension: _latest {
    sql: TIMESTAMP(GETDATE()) ;;
  }

  dimension: advertising_channel_sub_type {
    type: string
    sql: ${TABLE}.advertising_channel_sub_type ;;
  }

  dimension: advertising_channel_type {
    type: string
    sql: ${TABLE}.advertising_channel_type ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: bid_type {
    type: string
    sql: ${TABLE}.bid_type ;;
  }

  dimension: bidding_strategy_id {
    type: number
    sql: ${TABLE}.bidding_strategy_id ;;
  }

  dimension: bidding_strategy_name {
    type: string
    sql: ${TABLE}.bidding_strategy_name ;;
  }

  dimension: bidding_strategy_type {
    type: string
    sql: ${TABLE}.bidding_strategy_type ;;
  }

  dimension: budget_id {
    type: number
    sql: ${TABLE}.budget_id ;;
  }

  dimension: campaign_desktop_bid_modifier {
    type: number
    sql: ${TABLE}.campaign_desktop_bid_modifier ;;
  }

  dimension: campaign_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_mobile_bid_modifier {
    type: number
    sql: ${TABLE}.campaign_mobile_bid_modifier ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
    link: {
      label: "Campaign Dashboard"
      url: "/dashboards/google_adwords::campaign_performance?Campaign%20Name={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
  }

  dimension: campaign_status {
    type: string
    sql: ${TABLE}.campaign_status ;;
  }

  dimension: campaign_tablet_bid_modifier {
    type: number
    sql: ${TABLE}.campaign_tablet_bid_modifier ;;
  }

  dimension: campaign_trial_type {
    type: string
    sql: ${TABLE}.campaign_trial_type ;;
  }

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.end_date ;;
  }

  dimension: enhanced_cpc_enabled {
    type: yesno
    sql: ${TABLE}.enhanced_cpc_enabled ;;
  }

  dimension: enhanced_cpv_enabled {
    type: yesno
    sql: ${TABLE}.enhanced_cpv_enabled ;;
  }

  dimension: external_customer_id {
    type: number
    sql: ${TABLE}.external_customer_id ;;
  }

  dimension: is_budget_explicitly_shared {
    type: yesno
    sql: ${TABLE}.is_budget_explicitly_shared ;;
  }

  dimension: label_ids {
    type: string
    sql: ${TABLE}.label_ids ;;
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: period {
    type: string
    sql: ${TABLE}.period ;;
  }

  dimension: serving_status {
    type: string
    sql: ${TABLE}.serving_status ;;
  }

  dimension_group: start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: (TIMESTAMP(${TABLE}.start_date)) ;;
  }

  dimension: tracking_url_template {
    type: string
    sql: ${TABLE}.tracking_url_template ;;
  }

  dimension: url_custom_parameters {
    type: string
    sql: ${TABLE}.url_custom_parameters ;;
  }

  measure: count {
    type: count_distinct
    sql: ${campaign_id} ;;
    drill_fields: [campaign_name, campaign_basic_stats.total_impressions, campaign_basic_stats.total_interactions, campaign_basic_stats.total_conversions, campaign_basic_stats.total_cost_usd, campaign_basic_stats.average_interaction_rate, campaign_basic_stats.average_conversion_rate, campaign_basic_stats.average_cost_per_click, campaign_basic_stats.average_cost_per_conversion]
  }

  dimension: amount_usd {
    description: "Daily Budget in USD"
    type: number
    sql: ${amount} ;;
  }

  measure: total_amount {
    type: sum
    sql: ${amount} ;;
  }

  measure: total_amount_usd {
    type: sum
    sql: ${amount_usd} ;;
    value_format_name: usd_0
  }

  # ----- Detail ------
  set: detail {
    fields: [campaign_id, campaign_name, campaign_status, ad_group.count, ad.count, keyword.count]
  }
}


view: keyword {
  extends: [ad_criterion_base, entity_base]
  sql_table_name: adwords.adkeyword_stats;;

  dimension: _data {
    sql: ${TABLE}.date ;;
  }

  dimension: _latest {
    sql: TIMESTAMP(GETDATE()) ;;
  }

  dimension: ad_group_id {
    type: number
    sql: ${TABLE}.ad_group_id ;;
  }

  dimension: approval_status {
    type: string
    sql: ${TABLE}.approval_status ;;
  }

  dimension: bid_type {
    type: string
    sql: ${TABLE}.bid_type ;;
  }

  dimension: bidding_strategy_id {
    type: number
    sql: ${TABLE}.bidding_strategy_id ;;
  }

  dimension: bidding_strategy_name {
    type: string
    sql: CASE
      WHEN ${TABLE}.bidding_strategy_name IS NOT NULL THEN "Advanced"
      ELSE NULL END ;;
  }

  dimension: bidding_strategy_source {
    type: string
    sql: ${TABLE}.bidding_strategy_source ;;
  }

  dimension: bidding_strategy_type {
    type: string
    sql: ${TABLE}.bidding_strategy_type ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: cpc_bid {
    hidden: yes
    type: number
    sql: ${TABLE}.cpc_bid ;;
  }

  dimension: cpc_bid_source {
    type: string
    sql: ${TABLE}.cpc_bid_source ;;
  }

  dimension: cpm_bid {
    hidden: yes
    type: number
    sql: ${TABLE}.cpm_bid ;;
  }

  dimension: creative_quality_score {
    type: string
    sql: ${TABLE}.creative_quality_score ;;
  }

  dimension: criteria {
    type: string
    sql: ${TABLE}.criteria ;;
    link: {
      icon_url: "https://www.google.com/images/branding/product/ico/googleg_lodp.ico"
      label: "Google Search"
      url: "https://www.google.com/search?q={{ value | encode_uri}}"
    }
  }

  dimension: criteria_destination_url {
    type: string
    sql: ${TABLE}.criteria_destination_url ;;
  }

  dimension: criterion_id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: enhanced_cpc_enabled {
    type: yesno
    sql: ${TABLE}.enhanced_cpc_enabled ;;
  }

  dimension: estimated_add_clicks_at_first_position_cpc {
    type: number
    sql: ${TABLE}.estimated_add_clicks_at_first_position_cpc ;;
  }

  dimension: estimated_add_cost_at_first_position_cpc {
    type: number
    sql: ${TABLE}.estimated_add_cost_at_first_position_cpc ;;
  }

  dimension: external_customer_id {
    type: number
    sql: ${TABLE}.external_customer_id ;;
  }

  dimension: final_app_urls {
    type: string
    sql: ${TABLE}.final_app_urls ;;
  }

  dimension: final_mobile_urls {
    type: string
    sql: ${TABLE}.final_mobile_urls ;;
  }

  dimension: final_urls {
    type: string
    sql: ${TABLE}.final_urls ;;
  }

  dimension: first_page_cpc {
    type: string
    sql: ${TABLE}.first_page_cpc ;;
  }

  dimension: first_position_cpc {
    type: string
    sql: ${TABLE}.first_position_cpc ;;
  }

  dimension: has_quality_score {
    type: yesno
    sql: ${TABLE}.has_quality_score ;;
  }

  dimension: is_negative {
    type: yesno
    sql: ${TABLE}.is_negative ;;
  }

  dimension: keyword_match_type {
    type: string
    sql: ${TABLE}.keyword_match_type ;;
  }

  dimension: label_ids {
    type: string
    sql: ${TABLE}.label_ids ;;
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: post_click_quality_score {
    type: string
    sql: ${TABLE}.post_click_quality_score ;;
  }

  dimension: quality_score {
    type: number
    sql: ${TABLE}.quality_score ;;
  }

  dimension: search_predicted_ctr {
    type: string
    sql: ${TABLE}.search_predicted_ctr ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: system_serving_status {
    type: string
    sql: ${TABLE}.system_serving_status ;;
  }

  dimension: top_of_page_cpc {
    type: string
    sql: ${TABLE}.top_of_page_cpc ;;
  }

  dimension: tracking_url_template {
    type: string
    sql: ${TABLE}.tracking_url_template ;;
  }

  dimension: url_custom_parameters {
    type: string
    sql: ${TABLE}.url_custom_parameters ;;
  }

  measure: count {
    type: count_distinct
    sql: ${criterion_id} ;;
    drill_fields: [detail*, ad_group.detail*]
  }

  dimension: cpc_bid_usd {
    type: number
    sql: coalesce(${cpc_bid}, ${ad_group.cpc_bid_usd}) ;;
  }

  dimension: cpm_bid_usd {
    type: number
    sql: coalesce(${cpm_bid}, ${ad_group.cpm_bid_usd}) ;;
  }

  # ----- Detail ------
  set: detail {
    fields: [criterion_id, criteria, status, quality_score, post_click_quality_score, cpc_bid]
  }
}