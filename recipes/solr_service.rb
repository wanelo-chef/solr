#
# Cookbook Name:: solr
# Recipe:: solr_service
#
# Copyright 2013, Wanelo, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe "ipaddr_extensions::default"
include_recipe "smf::default"

# create/import smf manifest
smf node[:solr][:service_name] do
  credentials_user node[:solr][:solr_user]
  cmd = []
  cmd << "nohup java"

  cmd << node[:solr][:jvm_flags]

  cmd << "-Xms#{node[:solr][:memory][:xms]}" unless node[:solr][:memory][:xms].empty?
  cmd << "-Xmx#{node[:solr][:memory][:xmx]}" unless node[:solr][:memory][:xmx].empty?

  if node[:solr][:service_name] == "solr-replica"
    solr_master = search('node', node[:solr][:replica][:solr_master]).first[node[:solr][:replica][:master_ip_attribute]]
    cmd << "-Dreplication.url=http://#{solr_master}:#{node[:solr][:master][:port]}/solr/replication"
    cmd << "-Djetty.port=#{node[:solr][:replica][:port]}"
    cmd << "-Djava.util.logging.config.file=#{node[:solr][:replica][:home]}/log.conf"
    cmd << "-Dsolr.data.dir=#{node[:solr][:replica][:home]}/solr/data"
    working_directory node[:solr][:replica][:home]
  else
    cmd << "-Djetty.port=#{node[:solr][:master][:port]}"
    cmd << "-Djava.util.logging.config.file=#{node[:solr][:master][:home]}/log.conf"
    cmd << "-Dsolr.data.dir=#{node[:solr][:master][:home]}/solr/data"
    working_directory node[:solr][:master][:home]
  end

  if node[:solr][:only_bind_private_ip]
    cmd << "-Djetty.host=#{node[:privateaddress]}"
  elsif node[:solr][:bind_localhost]
    cmd << "-Djetty.host=127.0.0.1"
  end

  # Add NewRelic to start command if an API key is present
  unless node[:solr][:newrelic][:api_key].to_s.empty?
    cmd << "-javaagent:#{node[:solr][:newrelic][:jar]}"
    cmd << "-Dnewrelic.environment=#{node[:solr][:newrelic][:environment]}"
  end

  cmd << "-jar start.jar &"
  start_command cmd.join(' ')
  start_timeout 300
  stop_timeout 60
  environment "PATH" => node[:solr][:smf_path]
  not_if "svcs #{node[:solr][:service_name]}"
end

# start solr service
service node[:solr][:service_name] do
  action :enable
end
