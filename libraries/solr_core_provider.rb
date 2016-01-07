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
        install_dependencies
        new_resource.updated_by_last_action(true)
        new_resource.notifies(:install, new_resource, :delayed)
      end

      def action_install
        create_core
        configure_core
      end

      def action_reload
        shell_out!(new_resource.reload_command, user: 'solr')
        new_resource.updated_by_last_action(true)
      end

      private

      def configure_core
        config_files = []
        new_resource.config_files.each do |config_file|
          config_files << template(config_file.path) do
            source config_file.source_template
            cookbook config_file.source_cookbook
            owner 'solr'
            mode config_file.template_mode
            variables config_file.template_variables.merge(
                'version' => new_resource.version
              )
          end
        end
        config_files.each { |f| f.run_action(:create) }
        new_resource.notifies(:reload, new_resource, :delayed) if config_files.any?(&:updated_by_last_action?)
      end

      def create_core
        return if new_resource.already_exists?
        shell_out!(new_resource.create_command, user: 'solr')
        new_resource.updated_by_last_action(true)
      end

      def install_dependencies
        package 'unzip'
      end
    end
  end
end
