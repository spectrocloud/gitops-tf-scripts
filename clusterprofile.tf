# If looking up a cluster profile instead of creating a new one
# data "spectrocloud_cluster_profile" "profile" {
#   # id = <uid>
#   name = "eks-basic"
# }
#

locals {
  profile_ids = {
    ProdEKS-1 = spectrocloud_cluster_profile.this.id
    # for k, v in spectrocloud_cluster_profile.this :
    # v.name => v.id
  }
}

data "spectrocloud_pack" "argo-cd" {
  name    = "argo-cd"
  version = "3.3.5"
}

data "spectrocloud_pack" "aws-ssm-agent" {
  name    = "aws-ssm-agent"
  version = "1.0.0"
}

data "spectrocloud_pack" "spectro-rbac" {
  name    = "spectro-rbac"
  version = "1.0.0"
}

data "spectrocloud_pack" "csi" {
  name    = "csi-aws"
  version = "1.0.0"
}

data "spectrocloud_pack" "cni" {
  name    = "cni-aws-vpc-eks"
  version = "1.0"
}

data "spectrocloud_pack" "k8s" {
  name    = "kubernetes-eks"
  version = "1.19"
}

data "spectrocloud_pack" "ubuntu" {
  name    = "amazon-linux-eks"
  version = "1.0.0"
}

resource "spectrocloud_cluster_profile" "this" {
  name        = "ProdEKS-1"
  description = "basic eks cp"
  cloud       = "eks"
  type        = "cluster"

  pack {
    name   = data.spectrocloud_pack.ubuntu.name
    tag    = data.spectrocloud_pack.ubuntu.version
    uid    = data.spectrocloud_pack.ubuntu.id
    values = data.spectrocloud_pack.ubuntu.values
  }
  pack {
    name   = data.spectrocloud_pack.k8s.name
    tag    = data.spectrocloud_pack.k8s.version
    uid    = data.spectrocloud_pack.k8s.id
    values = <<-EOT
      #EKS settings
      managedControlPlane:

        #Controlplane Logging
        logging:

          # Setting to toggle Kubernetes API Server logging (kube-apiserver)
          apiServer: false

          # Setting to toggle the Kubernetes API audit logging
          audit: false

          # Setting to toggle the cluster authentication logging
          authenticator: false

          # Setting to toggle the controller manager (kube-controller-manager) logging
          controllerManager: false

          # Setting to toggle the Kubernetes scheduler (kube-scheduler) logging
          scheduler: false

        # OIDC related config
        # Uncomment below section when the EKS cluster has to be setup with OIDC authentication.
        # Note : Leave the param values in this config as is, so that validation for these params will happen during cluster provisioning
        oidcIdentityProvider:

          #The name of the OIDC provider configuration
          identityProviderConfigName: oidc1

          # The ID for the client application that makes authentication requests to the OpenID identity provider
          clientId: 5ajs8pq0gatbgpjejld96fldrn

          #The URL of the OpenID identity provider that allows the API server to discover public signing keys for verifying tokens
          issuerUrl: https://cognito-idp.us-east-1.amazonaws.com/us-east-1_ajvPoziaS

          usernamePrefix: "-"

          usernameClaim: email

          groupsClaim: cognito:groups
    EOT
  }

  pack {
    name   = data.spectrocloud_pack.cni.name
    tag    = data.spectrocloud_pack.cni.version
    uid    = data.spectrocloud_pack.cni.id
    values = data.spectrocloud_pack.cni.values
  }

  pack {
    name   = data.spectrocloud_pack.csi.name
    tag    = data.spectrocloud_pack.csi.version
    uid    = data.spectrocloud_pack.csi.id
    values = data.spectrocloud_pack.csi.values
  }

  pack {
    name   = data.spectrocloud_pack.aws-ssm-agent.name
    tag    = data.spectrocloud_pack.aws-ssm-agent.version
    uid    = data.spectrocloud_pack.aws-ssm-agent.id
    values = data.spectrocloud_pack.aws-ssm-agent.values
  }

  pack {
    name   = data.spectrocloud_pack.spectro-rbac.name
    tag    = data.spectrocloud_pack.spectro-rbac.version
    uid    = data.spectrocloud_pack.spectro-rbac.id
    values = "# RBAC Permissions specified at the cluster level"
  }

  pack {
    name   = data.spectrocloud_pack.argo-cd.name
    tag    = data.spectrocloud_pack.argo-cd.version
    uid    = data.spectrocloud_pack.argo-cd.id
    values = data.spectrocloud_pack.argo-cd.values
  }
}

resource "spectrocloud_cluster_profile" "ehs-1_5" {
  name        = "EHS-1.5"
  description = "EHS app"
  type        = "add-on"

  pack {
    name   = "manifest-pod"
    type   = "manifest"
    values = <<-EOT
      pack:
        installPriority: 100
    EOT

    manifest {
      name    = "nginx"
      content = <<-EOT
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          creationTimestamp: null
          labels:
            app: foo
          name: foo
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: foo
          strategy: {}
          template:
            metadata:
              creationTimestamp: null
              labels:
                app: foo
            spec:
              containers:
              - image: hellodsfas
                name: hello
                resources: {}
      EOT
    }
  }

  pack {
    name   = "manifest-namespace"
    type   = "manifest"
    values = <<-EOT
      pack:
        installPriority: 1
    EOT

    manifest {

      name    = "namespace"
      content = <<-EOT
        apiVersion: v1
        kind: Namespace
        metadata:
          name: test-delayed-namespace
      EOT
    }
  }
}
