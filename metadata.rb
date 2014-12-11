name 'solr'
maintainer 'Wanelo, Inc.'
maintainer_email 'dev@wanelo.com'
license 'Apache 2.0'
description 'Installs/Configures solr.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '4.1.2'

depends 'java'
depends 'smf', '>= 1.0.0'
depends 'ipaddr_extensions'
