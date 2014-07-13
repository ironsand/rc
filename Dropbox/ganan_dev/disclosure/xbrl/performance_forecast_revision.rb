module PerformanceForecastRevision
  def performance_forecast_revision
    h = {}

    [[true,true],[true, false],[false,true],[false,false]].each do |accumulated2q, consolidated|
      next if empty?("net_sales", context({adjustment: :current, forecast: true, accumulated2q: accumulated2q, consolidated: consolidated}))
      key = hash_key(accumulated2q, consolidated)
      h[key] = {}
      %w(net_sales operating_income ordinary_income net_income net_income_per_share).each do |name|
        next if (not consolidated) and name == "operating_income"
        h[key][name] = {}
        h[key][name][:current] = find_value name, accumulated2q: accumulated2q, adjustment: :current, forecast: true, consolidated: consolidated
        h[key][name][:previous] = find_value name, accumulated2q: accumulated2q, adjustment: :previous, forecast: true, consolidated: consolidated
        h[key][name][:prior] = find_value name, year: :prior, accumulated2q: accumulated2q, adjustment: :current, consolidated: consolidated
      end
    end
    h.symbolize_keys
  end
  def hash_key(accumulated2q, consolidated)
    a = accumulated2q ? "accumulated2q" : "year"
    b = consolidated ? "consolidated" : "non_consolidated"
    "#{a}_#{b}".to_sym
  end
end

