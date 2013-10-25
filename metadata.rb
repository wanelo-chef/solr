maintainer       "Wanelo, Inc."
maintainer_email "dev@wanelo.com"
license          "Apache 2.0"
description      "Installs/Configures solr.  Based on work originally found in the ModCloth solr cookbook."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.1"

depends "java"
depends "smf", '>= 1.0.0'
depends "ipaddr_extensions"
