class Chef
  class Provider
    # Provider for the solr Chef provider
    #
    # solr 'solr' do
    #   version '5.4.0'
    #   solr_home '/var/solr/solr5'
    #   port 8985
    #   hostname 'solr.prod'
    #   heap_size '1g'
    #   java_home '/opt/local/java/openjdk7'
    #   jvm_params '-Xdebug'
    # end
    #
    class Solr < Chef::Provider::LWRPBase
      def load_current_resource
        @current_resource ||= new_resource.class.new(new_resource.name)
      end

      def action_install
        run_dependencies
        download_solr_tar
        ensure_solr_directories
        extract_tar_file
        configure_logging
        configure_solr
        configure_service
      end

      private

      def configure_logging
        template new_resource.log_config_file do
          source new_resource.log_config_source
          cookbook 'solr'
          owner user
          mode '0644'
          variables 'logname' => new_resource.name
        end
      end

      def configure_service
        smf new_resource.name do
          user 'solr'
          start_command new_resource.start_command
          stop_command new_resource.stop_command
          start_timeout 300
          stop_timeout 60
          environment 'PATH' => node['paths']['bin_path'],
            'JAVA_HOME' => new_resource.java_home,
            'LC_ALL' => 'en_US.UTF-8',
            'LANG' => 'en_US.UTF-8',
            'SOLR_INCLUDE' => new_resource.solr_include
          property_groups({
              'config' => {
                'hostname' => new_resource.hostname,
                'port' => new_resource.port,
                'solr_home' => new_resource.solr_home
              }
            })
          working_directory new_resource.install_dir
        end
      end

      def configure_solr
        template '%s/solr.xml' % new_resource.solr_home do
          source 'solr%s/solr.xml.erb' % new_resource.major_version
          cookbook 'solr'
          owner 'root'
          mode 0644
        end

        template new_resource.solr_include do
          source 'solr%s/solr.in.sh.erb' % new_resource.major_version
          cookbook 'solr'
          owner 'root'
          mode 0644
          variables 'heap_size' => new_resource.heap_size
        end
      end

      def download_solr_tar
        remote_file new_resource.local_tar_file do
          source new_resource.remote_tar_file
        end
      end

      def ensure_solr_directories
        [new_resource.install_dir, new_resource.solr_home, new_resource.log_dir].each do |directory|
          directory directory do
            owner 'solr'
            mode 0755
          end
        end
      end

      def extract_tar_file
        execute 'extract solr %s tar file' % new_resource.version do
          command 'tar xzf %s' % new_resource.local_tar_file
          cwd '/opt'
          user 'solr'
          not_if 'test -d %s/bin' % new_resource.install_dir
        end
      end

      def run_dependencies
        run_context.include_recipe 'paths'
        run_context.include_recipe 'smf'
        run_context.include_recipe 'java'
        run_context.include_recipe 'solr::user'
      end
    end
  end
end
