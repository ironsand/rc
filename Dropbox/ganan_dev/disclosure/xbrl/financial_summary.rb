module FinancialSummary
  def financial_summary
    h = {}
    %i(consolidated_management_performance consolidated_financial_condition consolidated_cash_flow_statement
    dividend_statement consolidated_performance_forecast stock_numbers unconsolidated_management_performance
    unconsolidated_financial_condition unconsolidated_performance_forecast).each do |func|
      h[func] = send func
    end
    h
  end
  # 連結経営成績
  def consolidated_management_performance
    h = {}

    %w(net_sales operating_income ordinary_income net_income comprehensive_income).each do |name|
      name = "operating_revenues" if name == "net_sales" and empty?(name)
      h[name] = {}
      h[name][:current] = find_value_with_change(name)
      h[name][:prior] = find_value_with_change(name, year: :prior)
    end
    %w(net_income_per_share diluted_net_income_per_share net_income_to_shareholders_equity_ratio
    ordinary_income_to_total_assets_ratio operating_income_to_net_sales_ratio
    investment_profit_loss_on_equity_method).map do |name|
      name = "operating_income_to_operating_revenues_ratio" if name == "operating_income_to_net_sales_ratio" and empty? name
      h[name] = {}
      h[name][:current] = find_value name
      h[name][:prior] = find_value name, year: :prior
    end
    h.symbolize_keys
  end
  # 連結財政状態
  def consolidated_financial_condition
    h = {}
    %w(total_assets net_assets capital_adequacy_ratio net_assets_per_share owners_equity).each do |name|
      h[name] = {}
      h[name][:current] = find_value name, period: :instant
      h[name][:prior] = find_value name, period: :instant, year: :prior
    end
    h.symbolize_keys
  end
  # 連結キャッシュ・フローの状況
  def consolidated_cash_flow_statement
    h = {}
    %w(cash_flows_from_operating_activities cash_flows_from_investing_activities cash_flows_from_financing_activities).each do |name|
      h[name] = {}
      h[name][:current] = find_value name
      h[name][:prior] = find_value name, year: :prior
    end
    name = "cash_and_equivalents_end_of_period"
    h[name] = {}
    h[name][:current] = find_value name, period: :instant
    h[name][:prior] = find_value name, period: :instant, year: :prior
    h.symbolize_keys
  end
  # 配当の状況(英訳見つからず)
  def dividend_statement
    h = {}
    %w(first_quarter second_quarter third_quarter year_end annual).each do |quarter|
      h[quarter.to_sym] = {}
      h[quarter.to_sym][:current] = find_value "dividend_per_share", quarter: quarter.to_sym, consolidated: false
      h[quarter.to_sym][:prior] = find_value "dividend_per_share", quarter: quarter.to_sym, consolidated: false, year: :prior
      h[quarter.to_sym][:next] = find_value "dividend_per_share", quarter: quarter.to_sym, consolidated: false, year: :next
    end
    name = "total_dividend_paid_annual"
    h[name] = {}
    h[name][:current] = find_value name, quarter: :annual, consolidated: false
    h[name][:prior] = find_value name, quarter: :annual, consolidated: false, year: :prior
    name = "payout_ratio"
    h[name] = {}
    h[name][:current] = find_value name, quarter: :annual
    h[name][:prior] = find_value name, quarter: :annual, year: :prior
    h[name][:next] = find_value name, quarter: :annual, year: :next
    name = "ratio_of_total_amount_of_dividends_to_net_assets"
    h[name] = {}
    h[name][:current] = find_value name, quarter: :annual
    h[name][:prior] = find_value name, quarter: :annual, year: :prior
    h.symbolize_keys
  end
  # 連結業績予想
  def consolidated_performance_forecast
    h = {}
    %w(net_sales operating_income ordinary_income net_income).each do |name|
      name = "operating_revenues" if name == "net_sales" and empty?(name)
      h[name] = {}
      #h[name][:accumulated2q] = find_value_with_change name, year: :next, accumulated2q: true
      h[name][:next_year] = find_value_with_change name, year: :next
    end
    name = "net_income_per_share"
    h[name] = {}
    #h[name][:accumulated2q] = find_value name, year: :next, accumulated2q: true
    h[name][:next_year] = find_value name, year: :next
    h.symbolize_keys
  end
  def stock_numbers
    h = {}
    %w(number_of_issued_and_outstanding_shares_at_the_end_of_fiscal_year_including_treasury_stock
       number_of_treasury_stock_at_the_end_of_fiscal_year).each do |name|
      h[name] = {}
      h[name][:current] = find_value name, period: :instant, consolidated: false
      h[name][:prior] = find_value name, period: :instant, consolidated: false, year: :prior
    end
    name = "average_number_of_shares"
    h[name] = {}
    h[name][:current] = find_value name, consolidated: false
    h[name][:prior]   = find_value name, consolidated: false, year: :prior
    h.symbolize_keys
  end
  # 個別経営成績
  def unconsolidated_management_performance
    h = {}
    %w(net_sales operating_income ordinary_income net_income).each do |name|
      name = "operating_revenues" if name == "net_sales" and empty?(name)
      h[name] = {}
      h[name][:current] = find_value_with_change name, consolidated: false
      h[name][:prior] = find_value_with_change name, consolidated: false, year: :prior
    end
    %w(net_income_per_share diluted_net_income_per_share).each do |name|
      h[name] = {}
      h[name][:current] = find_value name, consolidated: false
      h[name][:prior] = find_value name, consolidated: false, year: :prior
    end
    h.symbolize_keys
  end
  # 個別財政状態
  def unconsolidated_financial_condition
=begin
    h = {}
    %w(total_assets net_assets capital_adequacy_ratio net_assets_per_share owners_equity).each do |name|
      h[name] = {}
      h[name][:current] = find_value name, period: :instant, consolidated: false
      h[name][:prior] = find_value name, period: :instant, consolidated: false, year: :prior
    end
    h.symbolize_keys
=end
  end
  # 個別業績予想
  def unconsolidated_performance_forecast
=begin
    h = {}
    %w(net_sales ordinary_income net_income).each do |name|
      h[name] = {}
      h[name][:accumulated2q] = find_value_with_change name, year: :next, consolidated: false, accumulated2q: true
      h[name][:next_year] = find_value_with_change name, year: :next, consolidated: false
    end
    name = "net_income_per_share"
    h[name] = {}
    h[name][:accumulated2q] = find_value name, year: :next, consolidated: false, accumulated2q: true
    h[name][:next_year] = find_value name, year: :next, consolidated: false
    h.symbolize_keys
=end
  end
end