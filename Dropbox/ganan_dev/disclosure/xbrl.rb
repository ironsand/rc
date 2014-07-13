# -*- coding: utf-8 -*-
require 'nokogiri'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'
require_relative 'xbrl/financial_summary'
require_relative 'xbrl/performance_forecast_revision'
require_relative 'xbrl/dividend_revision'
# 対応するドキュメント
# 決算短信
# 業績予想の修正
# 配当予想の修正
#
class XBRL
  include FinancialSummary
  include PerformanceForecastRevision
  include DividendRevision  
  attr_accessor :doc, :ns, :html
  def initialize(file)
    @html = File.read file
    @doc = Nokogiri::XML @html
    @ns = @doc.collect_namespaces
  end
  def document_name
    @doc.xpath("//ix:nonNumeric[@name='tse-ed-t:DocumentName']").text
  end
  def filling_date
    @doc.xpath("//ix:nonNumeric[@name='tse-ed-t:FilingDate']").text
  end
  def read
    case document_name
    when /決算短信/
      financial_summary
    when /業績予想の修正/
      performance_forecast_revision
    when /配当予想の修正に関するお知らせ/
      dividend_revision
    end
  end
  def unconsolidated_exists?
    @html =~ /個別業績予想数値の修正/
  end
  
  def find_value_with_change(name, options={})
    h = {}
    h[:value] = find name, context(options)
    h[:change] = find "change_in_#{name}", context(options)
    h
  end
  def find_value(name, options={})
    h = {}
    h[:value] = find name, context(options)
    h
  end
  def context(year: :current, period: :duration, quarter: nil, consolidated: true, accumulated2q: false, adjustment: nil, forecast: false)
    context = "#{year}".camelize
    context += accumulated2q ? "AccumulatedQ2" : "Year"
    context += period.to_s.camelize + "_"
    context += quarter.nil? ? "" : "#{quarter.to_s.camelize}Member_"
    context += "Non" unless consolidated
    context += "ConsolidatedMember_"
    context += "#{adjustment}".camelize + "Member_" if adjustment.present?
    context += year == :next || forecast ? "ForecastMember" : "ResultMember"
    end
  def empty?(name, context=context)
    not present? name, context=context
  end
    
  def present?(name, context=context)
    @doc.xpath("//ix:nonFraction[@name='tse-ed-t:#{name.camelize}' and @contextRef='#{context}']", @ns).present?
  end
  def find(name, context=context)
    p name, context
    e = @doc.xpath("//ix:nonFraction[@name='tse-ed-t:#{name.camelize}' and @contextRef='#{context}']", @ns)
    negative = true if e.attr("sign").present? && e.attr("sign").value == "-"
    return nil if e.attr("nil").present? && e.attr("nil").value == "true"
    number = e.text.delete(",").to_f
    negative ? -number : number
  end
end




