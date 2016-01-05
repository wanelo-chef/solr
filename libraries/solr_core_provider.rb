class Chef
  class Provider
    # Provider for the solr_core Chef provider
    #
    # solr_core 'default' do
    #   version '5.4.0'
    #   solr_home '/var/solr/solr5'
    #   port 8985
    # end
    #
    class SolrCore < Chef::Provider::LWRPBase
      include Chef::Mixin::ShellOut

      def load_current_resource
        @current_resource ||= new_resource.class.new(new_resource.name)
      end

      def action_create
        new_resource.updated_by_last_action(!new_resource.already_exists?)
        new_resource.notifies(:install, new_resource, :delayed)
      end

      def action_install
        create_core
      end

      private

      def create_core
        return if new_resource.already_exists?
        shell_out!(new_resource.create_command, user: 'solr')
      end
    end
  end
end
