- dashboard: table_calc_lookml_error
  title: Table Calc Lookml error
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: test1
    name: test1
    model: sayan_2120_2
    explore: order_items
    type: looker_grid
    fields: [products.brand, products.count]
    sorts: [products.count desc]
    limit: 500
    dynamic_fields: [{category: table_calculation, label: Products_count, value_format: !!null '',
        value_format_name: percent_2, calculation_type: percent_of_previous, table_calculation: products_count,
        args: [products.count], _kind_hint: measure, _type_hint: number}]
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen: {}
    row: 0
    col: 0
    width: 8
    height: 6
