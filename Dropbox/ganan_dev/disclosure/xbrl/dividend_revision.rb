module DividendRevision
  def dividend_revision
    h = {}
    %i(first_quarter second_quarter third_quarter year_end annual).each do |quarter|
      h[quarter] = {}
      p :previous
      h[quarter][:previous] = find_value "dividend_per_share", quarter: quarter, consolidated: false, adjustment: :previous, forecast: true
      p :current
      h[quarter][:current] = find_value "dividend_per_share", quarter: quarter, consolidated: false, adjustment: :current, forecast: true
      p :prior
      h[quarter][:prior] = find_value "dividend_per_share", quarter: quarter, consolidated: false, year: :prior, adjustment: :current
      next if quarter == :year_end || quarter == :annual
      p :current_result
      h[quarter][:current_result] = find_value "dividend_per_share", quarter: quarter, consolidated: false, adjustment: :current
    end
    h.symbolize_keys
  end
end