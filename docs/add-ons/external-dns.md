# ExternalDNS

[External DNS](https://github.com/kubernetes-sigs/external-dns) is a Kubernetes add-on that can automate the management of DNS records based on Ingress and Service resources. 

For complete project documentation, please visit the [ExternalDNS Github repository](https://github.com/kubernetes-sigs/external-dns).

## Usage

ExternalDNS can be deployed by enabling the add-on via the following.

```hcl
enable_external_dns = true
```

The modules can optionally leverage the `eks_cluster_domain` global property of the `kubernetes_addon` submodule. The value for this property should be a Route53 domain that you own. ExternalDNS will leverage the value supplied for its [zoneIdFilters] property, which will restrict ExternalDNS to only create records for this domain. See docs [here](https://github.com/bitnami/charts/tree/master/bitnami/external-dns).

```
eks_cluster_domain = <cluster_domain>
```

You can optionally customize the Helm chart that deploys `external-dns` via the following configuration.

```hcl
  enable_external_dns = true
  # Optional  agones_helm_config
  external_dns_helm_config = {
    name                       = "external-dns"
    chart                      = "external-dn"
    repository                 = "https://charts.bitnami.com/bitnami"
    version                    = "5.5.0"
    namespace                  = "external-dns"
  }
```

### GitOps Configuration

The following properties are made available for use when managing the add-on via GitOps.

```
external_dns = {
  enable            = true
  zoneFilterIds     = local.zone_filter_ids
  serviceAccontName = local.service_account_name
}
```