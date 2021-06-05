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
    values = data.spectrocloud_pack.k8s.values
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
    name = "manifest-pod"
    type = "manifest"
    # values = <<-EOT
    #   pack:
    #     installPriority: 0
    # EOT

    manifest {
      name    = "nginx"
      content = <<-EOT
        apiVersion: v1
        kind: Pod
        metadata:
          creationTimestamp: null
          labels:
            run: foo
          name: foo
        spec:
          containers:
          - image: nginx
            name: foo
            resources: {}
          dnsPolicy: ClusterFirst
          restartPolicy: Always
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
