module Solr
  #
  # Wraps up logic by which the SMF service for solr is configured
  #
  class ServiceHelper < Struct.new(:node)
    def start_command
      cmd = []
      cmd << 'nohup'
      cmd << config['java_executable']
      cmd << config['jvm_flags']
      cmd << memory_flags
      cmd << replica_flags
      cmd << master_flags
      cmd << jetty_flags
      cmd << newrelic_flags
      cmd << '-jar start.jar &'
      cmd.compact.join(' ')
    end

    def working_directory
      return replica_config['home'] if replica?
      master_config['home']
    end

    def replica?
      config['service_name'] == 'solr-replica'
    end

    private

    def jetty_flags
      ip = node['privateaddress'] if config['only_bind_private_ip']
      ip = '127.0.0.1' if config['bind_localhost']
      return "-Djetty.host=#{ip}" if ip
    end

    def memory_flags
      xms = config['memory']['xms']
      xmx = config['memory']['xmx']
      [].tap do |flags|
        flags << "-Xms#{xms}" unless xms.empty?
        flags << "-Xmx#{xmx}" unless xmx.empty?
      end.join(' ')
    end

    def master_flags
      return nil if replica?
      cmd << "-Djetty.port=#{master_config['port']}"
      cmd << "-Djava.util.logging.config.file=#{master_config['home']}/log.conf"
      cmd << "-Dsolr.data.dir=#{master_config['home']}/solr/data"
    end

    def newrelic_flags
      return nil if config['newrelic']['api_key'].to_s.empty?
      "-javaagent:#{config[:newrelic][:jar]} " \
      "-Dnewrelic.environment=#{config[:newrelic][:environment]}"
    end

    def replica_flags
      return nil unless replica?
      cmd << "-Dreplication.url=http://#{solr_master_ip}:#{master_config['port']}/solr/replication"
      cmd << "-Djetty.port=#{replica_config['port']}"
      cmd << "-Djava.util.logging.config.file=#{replica_config['home']}/log.conf"
      cmd << "-Dsolr.data.dir=#{replica_config['home']}/solr/data"
    end

    def master_config
      config['master']
    end

    def replica_config
      config['replica']
    end

    def config
      node['solr']
    end

    def solr_master_ip
      search_string = config['replica']['solr_master']
      ip_attr = config['replica']['master_ip_attribute']
      search('node', search_string).first[ip_attr] # ~FC003
    end
  end
end
