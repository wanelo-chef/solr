class Chef
  class Resource
    # Resource for the solr_core Chef provider
    #
    # solr_core 'default' do
    #   version '5.4.0'
    #   solr_home '/var/solr/solr5'
    #   solr_config
    #   port 8985
    # end
    #
    class SolrCore < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :solr_core
        @provider = Chef::Provider::SolrCore
        @action = :create
        @allowed_actions = [:create, :install]
      end

      ## Attributes

      def name(arg = nil)
        set_or_return(:name, arg, kind_of: String)
      end

      def confdir(arg = nil)
        set_or_return(:confdir, arg, kind_of: String, default: 'data_driven_schema_configs')
      end

      def port(arg = nil)
        set_or_return(:port, arg, kind_of: Integer, default: 8983)
      end

      def solr_home(arg = nil)
        set_or_return(:solr_home, arg, kind_of: String, required: true)
      end

      def version(arg = nil)
        set_or_return(:version, arg, kind_of: String, required: true)
      end

      ## Helpers

      def already_exists?
        !(shell_out('test -d %s/%s/core.properties' % [solr_home, name]).error?)
      end

      def create_command
        '%s/bin/solr create -c %s -p %s -d %s' % [install_dir, name, port, confdir]
      end

      private

      def install_dir
        '/opt/solr-%s' % version
      end
    end
  end
end
