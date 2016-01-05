Solr Chef Cookbook
==================

## DESCRIPTION:

Install Solr as either a master or a replica.

This configures Solr to be used with Sunspot by default.

## REQUIREMENTS:

This cookbook has only been tested on SmartOS.

The following cookbooks are expected to exist in the Chef server:

* java
* smf
* paths

## ATTRIBUTES:

## PROVIDERS:

### solr

Install a specific version of Solr, explicitly configured via the provider attributes.

```ruby
solr 'solr' do
  version '5.4.0'
  solr_home '/var/solr/solr5'
  port 8985
  hostname 'solr.prod'
  heap_size '1g'
  jvm_params '-Xdebug'
  notifies :enable, 'solr[solr]'
end
```

Available actions:

* `:create` - default
* `:enable`
* `:restart`

### solr_core

Creates a solr core in a running Solr instance. Note that Solr must already be running. This provider uses Chef
notifications to delay the core creation until an `:enable` delayed notification has time to run on the service
itself.

```ruby
solr 'solr' do
  version '5.4.0'
  solr_home '/var/solr/solr5'
  port 8985
  hostname 'solr.prod'
  heap_size '1g'
  jvm_params '-Xdebug'
  notifies :enable, 'solr[solr]'
end

solr_core 'default' do
  version '5.4.0'
  solr_home '/var/solr/solr5'
  port 8985
  confdir 'basic_configs'
end
```

Available actions:

* `:create`
* `:install` - used internally to delay core creation. Not intended to be run manually.

Attributes:

* `confdir` - [`basic_configs`, `data_driven_schema_configs`, `sample_techproducts_configs`], default: `data_driven_schema_configs`.
  Can also be used to pass the path to a configuration directory.

## RECIPES:

### Solr Master

```ruby
include_recipe "solr::master"
```

This will create a service in SMF named `solr-master` on port 9985.

### Solr Replica

```ruby
include_recipe "solr::replica"
```

This will create a service in SMF named `solr-replica` on port 8983. By default it will look for
a master on localhost. This can be configured by updating the `solr.master.hostname` attribute on
a host.

## Attribution

Based on work originally found in the ModCloth solr cookbook.
