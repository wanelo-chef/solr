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

include_recipe 'ipaddr_extensions'
include_recipe 'partial_search_in_env'
include_recipe 'smf'

helper = Solr::ServiceHelper.new(node)
path = [node['solr']['smf_path'], node['paths']['bin_path']].compact.join(':')

# create/import smf manifest
smf node['solr']['service_name'] do
  user node['solr']['solr_user']
  start_command helper.start_command
  start_timeout 300
  stop_timeout 60
  environment 'PATH' => path,
              'LC_ALL' => 'en_US.UTF-8',
              'LANG' => 'en_US.UTF-8'
  working_directory helper.working_directory
end

# start solr service
service node['solr']['service_name'] do
  action 'enable'
end
