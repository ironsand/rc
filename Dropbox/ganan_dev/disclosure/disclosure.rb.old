# -*- coding: utf-8 -*-
require 'selenium-webdriver'
require 'date'
require 'active_record'
require 'fileutils'

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "disclosure.db")

unless File.exists? "disclosure.db"
  ActiveRecord::Schema.define do
    create_table :disclosures do |t|
      t.column :code, :integer
      t.column :company, :string
      t.column :title, :string
      t.column :url, :string, unique: true
      t.column :published_at, :datetime
    end
    add_index :disclosures, :url
  end
end

class Disclosure < ActiveRecord::Base
  XBRL_ZIP_DIR = "/var/disclosure/recent/zips" #TODO ~ に直す
  def self.today_xbrls
    driver = self.open "https://www.release.tdnet.info/inbs/I_main_00.html"
    driver.switch_to.frame driver.find_element(:name, 'frame_l')
    es = driver.find_elements(:xpath, ".//tr[.//a[@class='style002' and text()='DownLoad']]")
    es.collect do |e|
      time = e.find_element(:xpath, 'td').text()
      code = e.find_element(:xpath, 'td[2]').text()
      company = e.find_element(:xpath, 'td[3]').text()
      title = e.find_element(:xpath, 'td[4]').text()
      url = e.find_element(:xpath, ".//a[@class='style002' and text()='DownLoad']").attribute 'href'
      date = Date.today.strftime("%Y%m%d")
      published_at = Time.strptime("#{date} #{time}", '%Y%m%d %H:%M')
      #p {code: code, company: company, title: title, url: url, published_at: published_at}
      unless find_by(url: url)
        create(code: code, company: company, title: title, url: url, published_at: published_at)
      end
    end
  end
  def self.xbrls_by_date(date)
    end
  def self.xbrls_by_code(code)
    driver = self.open "http://www5.tse.or.jp/tseHpFront/HPLCDS0301.do", :chrome, code
    driver.find_element(:name, 'searchBrandCode').send_keys code
    driver.find_element(:name, 'searchButton').click
    unless code_exists? driver #該当コードの企業が存在しなければ何もしない
      driver.close
      return false
    end
    driver.find_element(:xpath, ".//input[@class='activeButton' and @value='基本情報']").click
    driver.find_element(:xpath, ".//a[contains(text(), '適時開示情報')]").click
    driver.find_elements(:xpath, ".//input[@class='activeButton' and @value='情報を閲覧する場合はこちら']").each{|e| e.click }
    driver.find_elements(:xpath, ".//input[@class='activeButton' and @value='ダウンロード']").each{|e| e.click if e.displayed? }
    pdf_elements = driver.find_elements(:xpath, ".//div[@class='txtLink2']/div[@class='txtLink2_InnerDiv']/a")
    FileUtils.mkdir_p pdf_dir(code) unless File.directory? pdf_dir(code)
    File.open "#{pdf_dir(code)}/index.html", "w" do |f|
      f.write "<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body>"
    end
    pdf_elements.map{|e| [e.text, e.attribute('href')] }.each do |text, url|
      self.download_pdf text, url, code
    end
    File.open("#{pdf_dir(code)}/index.html", "a+"){ |f|  f.write "</body></html>" }

    sleep 3
    driver.quit
  rescue Exception => e
    File.open("retry.txt", "a+"){|f| f.write "retry #{e.message} - #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}\n" }
    system("killall chromedriver")
    retry
  end
  def self.code_exists?(driver)
    return driver.find_element(:xpath, ".//div[@class='boxOptListed01']/p/span").text() != "該当銘柄数：0件"
  rescue
    return true # TODO もうちょっとちゃんと調べたほうがいいか？
  end
  def self.pdf_dir(code)
    "/var/disclosure/pdfs/#{code}"
  end
  def self.download_pdf(text, url, code)
    File.open "#{pdf_dir(code)}/index.html", "a" do |f|
      f.write "<div><a href=#{File.basename url}>#{text}</a></div>"
    end
    `wget #{url} -nc -O #{pdf_dir(code)}/#{File.basename url}`
  end
  def download_xbrl
    FileUtils.mkdir_p XBRL_ZIP_DIR unless File.directory? XBRL_ZIP_DIR
    `wget #{url} -nc -O #{XBRL_ZIP_DIR}/#{filename}`
  end

  def self.open(url, driver=:phantomjs, code=nil)
    driver = case driver
             when :phantomjs
               Selenium::WebDriver.for driver
             when :firefox
               Selenium::WebDriver.for driver, profile: firefox_profile
             when :chrome
               Selenium::WebDriver.for driver, prefs: chrome_prefs(code)
             end
    driver.navigate.to url
    driver
  end
  private
  def filename
    File.basename url
  end
  def self.chrome_prefs(code)
    prefs = {
      download: {
        prompt_for_download: false,
        default_directory: "/var/disclosure/xbrls/#{code}"
      }
    }
  end
  def self.firefox_profile
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = "/tmp/webdriver-downloads"
    profile['browser.download.folderList'] = 2 # 2: the last folder specified for a download
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/x-zip;application/x-zip-compressed;application/octet-stream;application/zip;application/octet"
    #profile['pdfjs.disabled'] = true
    profile['browser.download.dir'] = "/tmp/webdriver-downloads2"
    profile
  end
end
