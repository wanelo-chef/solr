default[:solr][:java_dir] = '/usr/java/default'
default[:solr][:java_options] = '-Dsolr.solr.home=/opt/solr/solr $JAVA_OPTIONS'
default[:solr][:java_executable] = 'java'
default[:solr][:solr_home] = '/opt/solr'
default[:solr][:solr_user] = 'solr'
default[:solr][:solr_log_dir] = '/var/log/solr'
default[:solr][:solr_log_size] = 1_000_000_000
default[:solr][:solr_log_count] = 4

default[:solr][:smf_path] = '/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin'
default[:solr][:uses_sunspot_schema] = true

default[:solr][:only_bind_private_ip] = false
default[:solr][:bind_localhost] = false

default[:solr][:users] = []
default[:solr][:master][:hostname] = 'localhost'
default[:solr][:master][:port] = 9985
default[:solr][:master][:home] = '/opt/solr/master'
default[:solr][:master][:replicated_configs] = ["schema.xml", "stopwords.txt"]

default[:solr][:replica][:port] = 8983
default[:solr][:replica][:home] = '/opt/solr/replica'
default[:solr][:replica][:solr_master] = nil
# pick a chef attribute to use when configuring replication from master:
default[:solr][:replica][:master_ip_attribute] = "privateaddress"

default[:solr][:newrelic] = {}
default[:solr][:newrelic][:environment] = 'demo'
default[:solr][:newrelic][:api_key] = ''
default[:solr][:newrelic][:app_name] = 'Solr application'
default[:solr][:newrelic][:jar] = "/opt/solr/newrelic/newrelic.jar"
default[:solr][:newrelic][:jar_checksum] = nil     # calculate with `openssl dgst -sha256 $filename`
default[:solr][:newrelic][:remote_jar_file] = ""

default[:solr][:memory][:xmx] = ""
default[:solr][:memory][:xms] = ""

default[:solr][:jvm_flags] = ""

default[:solr][:version] = "3.6.2"
default[:solr][:source_url] = "http://www.us.apache.org/dist/lucene/solr/#{node[:solr][:version]}/apache-solr-#{node[:solr][:version]}.tgz"


default[:solr][:config][:auto_commit][:max_docs] = nil
default[:solr][:config][:auto_commit][:max_time] = nil

default[:solr][:config][:query_result_window_size] = 20
default[:solr][:config][:query_result_max_docs_cached] = 200

default[:solr][:config][:filter_cache][:class] = "solr.FastLRUCache"
default[:solr][:config][:filter_cache][:size] = "512"
default[:solr][:config][:filter_cache][:initial_size] = "512"
default[:solr][:config][:filter_cache][:auto_warm_count] = "0"

default[:solr][:config][:query_result_cache][:class] = "solr.LRUCache"
default[:solr][:config][:query_result_cache][:size] = "512"
default[:solr][:config][:query_result_cache][:initial_size] = "512"
default[:solr][:config][:query_result_cache][:auto_warm_count] = "0"

default[:solr][:config][:document_cache][:class] = "solr.LRUCache"
default[:solr][:config][:document_cache][:size] = "512"
default[:solr][:config][:document_cache][:initial_size] = "512"
default[:solr][:config][:document_cache][:auto_warm_count] = "0"
