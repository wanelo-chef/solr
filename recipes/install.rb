#
# Cookbook Name:: solr
# Recipe:: install
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

include_recipe 'java::default'
include_recipe 'solr::user'

# download and extract solr

solr_tarball = "#{Chef::Config['file_cache_path']}/solr.tgz"

remote_file solr_tarball do
  source node['solr']['source_url']
  mode '0744'
  not_if "ls #{solr_tarball}"
end

execute 'extract solr archive' do
  command "mkdir -p /var/tmp/solr && tar -C /var/tmp/solr -xzf #{solr_tarball} --strip 1"
  not_if 'ls -d /var/tmp/solr'
end

directory node['solr']['solr_home'] do
  owner node['solr']['solr_user']
end

execute 'copy example solr home into master' do
  command "mkdir -p #{node['solr']['solr_home']}/home_example/ " \
          "&& cp -pr /var/tmp/solr/example/* #{node['solr']['solr_home']}/home_example/"
  not_if "svcs #{node['solr']['service_name']}"
end

directory "#{node['solr']['solr_home']}/home_example/solr/data" do
  recursive true
  owner node['solr']['solr_user']
end

directory node['solr']['solr_log_dir'] do
  owner node['solr']['solr_user']
end
