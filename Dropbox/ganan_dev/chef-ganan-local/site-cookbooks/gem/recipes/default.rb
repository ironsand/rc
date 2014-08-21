#
# Cookbook Name:: gem
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w(daemons).each do |gem|
    execute "gem install #{gem}" do
        command  %Q{bash -c 'export PATH="~/.rbenv/bin:$PATH"; eval "$(rbenv init -)"; gem i #{gem}'}
    end
end
