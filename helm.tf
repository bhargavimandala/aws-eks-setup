resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress-controller"
  }
}

resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.9.1"
  namespace  = "ingress-controller"
  max_history = "5"
  depends_on = [kubernetes_namespace.ingress]

  set {
    name  = "controller.ingressClassResource.name"
    value = "ingress-dev"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
    type = "string"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type"
    value = "ip"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "tcp"
  }
  
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-subnets"
    value = "subnet-0074a38c60ffa6e35"
  }






  #values = [
   # "${file("ingress-values.yaml")}"
  #]

}