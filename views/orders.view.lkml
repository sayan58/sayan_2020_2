# The name of this view in Looker is "Orders"
view: orders {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;

  }

  measure: dim_mult_test {
    label: "dim_mult_test"
    type: sum
    sql: 0 ;;
    hidden: yes
    drill_fields: [created_date]
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Status" in Explore.

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    link: {
      label: "Explore Top 2000 Results"
      url: "{{ link }}&limit=2000"
    }
  }



  parameter: test {
    type: string

    allowed_value: {
      label: "a name"
      value: "Donna^_Moore"
    }


  }

  dimension: test_name {
    type: string
    sql: concat(${users.first_name},"_",${users.last_name} ) ;;
  }

  dimension: para_dim {
    type: string
    sql: {% if test._parameter_value == 'Donna^_Moore' %}
          ${test_name}
        {% else %}
          ${users.first_name}
        {% endif %} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      billion_orders.count,
      fakeorders.count,
      hundred_million_orders.count,
      hundred_million_orders_wide.count,
      order_items.count,
      ten_million_orders.count
    ]
  }

  parameter: timeframe {
    view_label: "Period over Period"
    type: unquoted
    allowed_value: {
      label: "Week to Date"
      value: "Week"
    }
    allowed_value: {
      label: "Month to Date"
      value: "Month"
    }
    allowed_value: {
      label: "Quarter to Date"
      value: "Quarter"
    }
    allowed_value: {
      label: "Year to Date"
      value: "Year"
    }
    default_value: "Quarter"
  }

  dimension: first_date_in_period {
    view_label: "Period over Period"
    type: date
    sql: DATE_TRUNC(CURRENT_DATE(), {% parameter timeframe %});;
  }

  dimension: days_in_period {
    view_label: "Period over Period"
    type: number
    sql: DATE_DIFF(CURRENT_DATE(),${first_date_in_period}, DAY) ;;
  }

  dimension: first_date_in_prior_period {
    view_label: "Period over Period"
    type: date
    hidden: no
    sql: DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 {% parameter timeframe %}),{% parameter timeframe %});;
  }

  dimension: last_date_in_prior_period {
    view_label: "Period over Period"
    type: date
    hidden: no
    sql: DATE_ADD(${first_date_in_prior_period}, INTERVAL ${days_in_period} DAY) ;;
  }

  dimension: period_selected {
    view_label: "Period over Period"
    type: string
    sql:
        CASE
          WHEN ${created_date} >=  ${first_date_in_period}
          THEN 'This {% parameter timeframe %} to Date'
          WHEN ${created_date} >= ${first_date_in_prior_period}
          AND ${created_date} <= ${last_date_in_prior_period}
          THEN 'Prior {% parameter timeframe %} to Date'
          ELSE NULL
          END ;;
  }




  }
