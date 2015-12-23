class Chef
  class Resource
    # Resource for the solr Chef provider
    #
    # solr 'solr' do
    #   version '5.4.0'
    #   solr_home '/var/solr/solr5'
    #   port 8985
    #   hostname 'solr.prod'
    #   heap_size '1g'
    #   jvm_params '-Xdebug'
    # end
    #
    class Solr < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :solr
        @provider = Chef::Provider::Solr
        @action = :install
        @allowed_actions = [:install]
      end

      ## Attributes

      def name(arg = nil)
        set_or_return(:name, arg, kind_of: String)
      end

      def version(arg = nil)
        set_or_return(:version, arg, kind_of: String, required: true)
      end

      def solr_home(arg = nil)
        set_or_return(:solr_home, arg, kind_of: String, required: true)
      end

      def port(arg = nil)
        set_or_return(:port, arg, kind_of: Integer, default: 8983)
      end

      def hostname(arg = nil)
        set_or_return(:hostname, arg, kind_of: String, default: node['hostname'])
      end

      def heap_size(arg = nil)
        set_or_return(:heap_size, arg, kind_of: String, default: '512m')
      end

      def java_home(arg = nil)
        set_or_return(:java_home, arg, kind_of: String, required: true)
      end

      def jvm_params(arg = nil)
        set_or_return(:jvm_params, arg, kind_of: String)
      end

      ## Helpers

      def install_dir
        '/opt/solr-%s' % version
      end

      def local_tar_file
        '%s/solr-%s.tgz' % [
          Chef::Config['file_cache_path'],
          version
        ]
      end

      def log_config_file
        ::File.join(solr_home, log_config_file_name)
      end

      def log_config_source
        "solr#{major_version}/log.conf.erb"
      end

      def log_dir
        '/var/log/solr'
      end

      def major_version
        version.split('.').first.to_i
      end

      def remote_tar_file
        '%s/%s/solr-%s.tgz' % [
          node['solr']['mirror'],
          version,
          version
        ]
      end

      def solr_include
        '%s/solr.in.sh' % solr_home
      end

      def start_command
        'bin/solr start -h %{config/hostname} -p %{config/port} -s %{config/solr_home}'
      end

      def stop_command
        'bin/solr stop -p %{config/port}'
      end

      private

      def log_config_file_name
        return 'log4j.properties' if major_version >= 4
        'log.conf'
      end
    end
  end
end
