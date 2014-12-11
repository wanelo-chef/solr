## DESCRIPTION:

Install Solr as either a master or a replica.

This configures Solr to be used with Sunspot by default.

## REQUIREMENTS:

This cookbook has only been tested on SmartOS.

## ATTRIBUTES:

## USAGE:

### Solr Master

```
include_recipe "solr::master"
```

This will create a service in SMF named `solr-master` on port 9985.

### Solr Replica

```
include_recipe "solr::replica"
```

This will create a service in SMF named `solr-replica` on port 8983. By default it will look for
a master on localhost. This can be configured by updating the `solr.master.hostname` attribute on
a host.

## Attribution

Based on work originally found in the ModCloth solr cookbook.
