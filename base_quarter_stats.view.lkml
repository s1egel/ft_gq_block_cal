include: "master_basic_stats.view.lkml"

view: base_quarter_stats {
  dimension_group: _data {
    type: time
    timeframes: ["quarter", "raw"]
    convert_tz: no
    sql: CAST((${TABLE}._data_quarter + '-01') AS DATE) ;;
  }
  dimension: clicks {
    type: number
  }
  dimension: conversions {
    type: number
  }
  dimension: cost {
    type: number
  }
  dimension: impressions {
    type: number
  }
  dimension: interactions {
    type: number
  }
  dimension: _data_last_quarter {
    type: date_quarter
    sql: DATEADD(QUARTER, -1, CAST((${_data_quarter} + '-01') AS DATE)) ;;
  }
  measure: total_impressions {
    drill_fields: [total_impressions]
  }
  measure: total_clicks {
    drill_fields: [total_clicks]
  }
  measure: total_interactions {
    drill_fields: [total_interactions]
  }
  measure: total_conversions {
    drill_fields: [total_conversions]
  }
  measure: total_cost_usd {
    drill_fields: [total_cost_usd]
  }
  measure: average_interaction_rate {
    drill_fields: [average_interaction_rate]
  }
  measure: average_click_rate {
    drill_fields: [average_click_rate]
  }
  measure: average_conversion_rate {
    drill_fields: [average_conversion_rate]
  }
  measure: average_cost_per_click {
    drill_fields: [average_cost_per_click]
  }
  measure: average_cost_per_conversion {
    drill_fields: [average_cost_per_conversion]
  }
}


view: account_quarter_stats {
  extends: [stats, base_quarter_stats]

  derived_table: {
    persist_for: "24 hours"
    indexes: ["_data_quarter", "external_customer_id"]
    explore_source: master_stats {
      column: _data_quarter {}
      column: external_customer_id {}
      column: cost { field: master_stats.total_cost }
      column: clicks { field: master_stats.total_clicks }
      column: conversions { field: master_stats.total_conversions }
      column: impressions { field: master_stats.total_impressions }
      column: interactions { field: master_stats.total_interactions }
      filters: {
        field: master_stats.less_than_current_day_of_quarter
        value: "Yes"
      }
    }
  }
  dimension: external_customer_id {
    type: number
  }
  measure: total_impressions {
    drill_fields: [customer.detail*, total_impressions]
  }
  measure: total_clicks {
    drill_fields: [customer.detail*, total_clicks]
  }
  measure: total_interactions {
    drill_fields: [customer.detail*, total_interactions]
  }
  measure: total_conversions {
    drill_fields: [customer.detail*, total_conversions]
  }
  measure: total_cost_usd {
    drill_fields: [customer.detail*, total_cost_usd]
  }
  measure: average_interaction_rate {
    drill_fields: [customer.detail*, average_interaction_rate]
  }
  measure: average_click_rate {
    drill_fields: [customer.detail*, average_click_rate]
  }
  measure: average_conversion_rate {
    drill_fields: [customer.detail*, average_conversion_rate]
  }
  measure: average_cost_per_click {
    drill_fields: [customer.detail*, average_cost_per_click]
  }
  measure: average_cost_per_conversion {
    drill_fields: [customer.detail*, average_cost_per_conversion]
  }
}


view: campaign_quarter_stats {
  extends: [stats, base_quarter_stats]

  derived_table: {
    persist_for: "24 hours"
    indexes: ["_data_quarter", "campaign_id", "external_customer_id"]
    explore_source: master_stats {
      column: _data_quarter {}
      column: campaign_id {}
      column: external_customer_id {}
      column: cost { field: master_stats.total_cost }
      column: clicks { field: master_stats.total_clicks }
      column: conversions { field: master_stats.total_conversions }
      column: impressions { field: master_stats.total_impressions }
      column: interactions { field: master_stats.total_interactions }
      filters: {
        field: master_stats.less_than_current_day_of_quarter
        value: "Yes"
      }
    }
  }
  dimension: campaign_id {
    type: number
  }
  dimension: external_customer_id {
    type: number
  }
  measure: total_impressions {
    drill_fields: [campaign.detail*, total_impressions]
  }
  measure: total_clicks {
    drill_fields: [campaign.detail*, total_clicks]
  }
  measure: total_interactions {
    drill_fields: [campaign.detail*, total_interactions]
  }
  measure: total_conversions {
    drill_fields: [campaign.detail*, total_conversions]
  }
  measure: total_cost_usd {
    drill_fields: [campaign.detail*, total_cost_usd]
  }
  measure: average_interaction_rate {
    drill_fields: [campaign.detail*, average_interaction_rate]
  }
  measure: average_click_rate {
    drill_fields: [campaign.detail*, average_click_rate]
  }
  measure: average_conversion_rate {
    drill_fields: [campaign.detail*, average_conversion_rate]
  }
  measure: average_cost_per_click {
    drill_fields: [campaign.detail*, average_cost_per_click]
  }
  measure: average_cost_per_conversion {
    drill_fields: [campaign.detail*, average_cost_per_conversion]
  }
}


view: campaign_budget_stats {
  derived_table: {
    explore_source: master_stats {
      column: campaign_id {}
      column: budget_id { field: campaign.budget_id }
      column: _data { field: master_stats._data_raw}
      column: external_customer_id {}
      column: amount { field: campaign.total_amount }
      column: cost { field: master_stats.total_cost }
    }
  }
  dimension: campaign_id {
    type: number
  }
  dimension: external_customer_id {
    type: number
  }
  dimension_group: _data {
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
  }
  dimension: budget_id {}
  dimension: amount {}
  dimension: cost {}
  dimension: amount_usd {
    type: number
    sql: ${amount} ;;
  }
  dimension: cost_usd {
    type: number
    sql: ${cost} ;;
  }
  dimension: remaining_budget {
    type: number
    sql: ${amount_usd} - ${cost_usd} ;;
    value_format_name: usd_0
  }
  dimension: percent_remaining_budget {
    type: number
    sql: ${remaining_budget} / ${amount_usd} ;;
    value_format_name: percent_2
  }
  dimension: percent_used_budget {
    type: number
    sql: COALESCE(1 - ${percent_remaining_budget}, 0) ;;
    value_format_name: percent_2
  }
  dimension: percent_used_budget_tier {
    type: tier
    tiers: [0, 0.2, 0.4, 0.6, 0.8, 1]
    style: interval
    sql: ${percent_used_budget} ;;
    value_format_name: percent_2
  }
  dimension: constrained_budget {
    type: yesno
    description: "Daily spend within 20% of campaign budget"
    sql:  ${percent_remaining_budget} <= .2 ;;
  }
  measure: total_amount_usd {
    type: sum
    sql: ${amount_usd} ;;
    value_format_name: usd_0
  }
  measure: total_cost_usd {
    type: sum
    sql: ${cost_usd} ;;
    value_format_name: usd_0
  }
  measure: count_constrained_budget_days {
    type: count_distinct
    description: "Days with daily spend within 20% of campaign budget"
    sql:  (CAST(${_data_raw} AS VARCHAR) + CAST(${budget_id} AS VARCHAR))  ;;
    filters: {
      field: constrained_budget
      value: "yes"
    }
  }
}
