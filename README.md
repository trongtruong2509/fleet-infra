# Flux Repository for AKS

This is repository for FluxCD in AKS with terraform `azurerm_kubernetes_flux_configuration`


Repo structure

```bash
├── apps
│   ├── argocd
│   │   ├── kustomization.yaml
│   │   ├── namespace.yaml
│   │   ├── release.yaml
│   │   └── repository.yaml
│   └── podinfo
│       ├── kustomization.yaml
│       ├── namespace.yaml
│       ├── release.yaml
│       └── repository.yaml
└── clusters
    ├── cluster-2
    │   ├── argocd
    │   │   ├── argo-values.yaml
    │   │   └── kustomization.yaml
    │   └── podinfo
    │       ├── kustomization.yaml
    │       └── podinfo-values.yaml
    └── minikube
        ├── argocd
        │   └── kustomization.yaml
        └── podinfo
            ├── kustomization.yaml
            └── podinfo-values.yaml
```

1. `apps` folder will store applications in each folder. And each app will have its own kustomization file. 
2. `clusters` folder will store cluster in each folder. And in each cluster will have overlay for apps as folder.

In resource `azurerm_kubernetes_flux_configuration`, there is a `kustomizations` to define flux kustomizations will be applied to the cluster. The path of kustomization should refer to each app in the cluster folder. For instance, if you want to deploy argocd app in `cluster-2`. The `kustomizations` should look like this

```bash
resource "azurerm_kubernetes_flux_configuration" "example" {
  name       = "example-fc"
  cluster_id = azurerm_kubernetes_cluster.test.id
  namespace  = "flux"

  git_repository {
    url             = "https://github.com/trongtruong2509/fleet-infra"
    reference_type  = "branch"
    reference_value = "master"
  }

  kustomizations {
    name = "argocd"
    path = "./clusters/cluster-2/argocd"
    sync_interval_in_seconds  = 120
    retry_interval_in_seconds = 120
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.example
  ]
}
```