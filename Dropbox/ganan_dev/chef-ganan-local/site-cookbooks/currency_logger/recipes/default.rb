# -*- coding: utf-8 -*-
#
# Cookbook Name:: currency_logger
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# rbenv のsystemインストールが必須

#execute "create currency_logger.git repository" do
#  command "mkdir /var/git-repo/currency_logger.git; git init --bare --shared /var/git-repo/currency_logger.git"
#end

git "/opt/currency_logger" do
    repository "git@bitbucket.org:ironsand/currency_logger.git"
    action :sync
    ignore_failure true
end

%w(/var/log/currency_logger/log /var/log/currency_logger/error /var/currency_logger/data).each do |dir|
    directory dir do
        action :create
        recursive true
    end
end

# Daemonを走らせる
execute "currency_logger deamon" do
    command  %Q{bash -c 'export PATH="~/.rbenv/bin:$PATH"; eval "$(rbenv init -)"; cd /opt/currency_logger; ~/.rbenv/shims/ruby /opt/currency_logger/currency_logger_daemon.rb start'}
end

