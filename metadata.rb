name 'solr'
maintainer 'Wanelo, Inc.'
maintainer_email 'dev@wanelo.com'
license 'Apache 2.0'
description 'Installs/Configures solr.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '5.2.1'

depends 'ipaddr_extensions'
depends 'java'
depends 'partial_search_in_env'
depends 'paths'
depends 'smf', '>= 1.0.0'
