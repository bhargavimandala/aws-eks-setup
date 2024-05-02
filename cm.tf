 resource "kubernetes_namespace" "cm" {
  metadata {
    name = "mbr-ns"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "scalable-nginx-example"
    namespace        = "mbr-ns"  
    labels = {
      App = "ScalableNginxExample"
      namespace = "mbr-ns"
     
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableNginxExample"
        namespace = "mbr-ns"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
          namespace = "mbr-ns"

         
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "example"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}


