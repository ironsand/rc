#!/usr/local/rbenv/shims/ruby
require_relative 'disclosure'
Disclosure.today_xbrls
Disclosure.all.order("id desc").limit(100).each do |d|
  d.download_xbrl
end
