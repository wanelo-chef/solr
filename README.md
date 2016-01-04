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

### Default

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
