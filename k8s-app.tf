resource "kubernetes_namespace_v1" "app" {
  metadata {
    name = "app"
  }
}

resource "kubernetes_deployment_v1" "ngin" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
    labels    = { app = "nginx" }
  }

  spec {
    replicas = 1
    selector {
      match_labels = { app = "nginx" }
    }

    template {
      metadata {
        labels = { app = "nginx" }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginxinc/nginx-unprivileged:stable"
          port {
            container_port = var.nginx_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "service" {
  metadata {
    name      = "nginx-lb"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
    labels    = { app = "nginx" }
  }

  spec {
    selector = { app = "nginx" }
    port {
      port        = var.nginx_port
      target_port = var.nginx_port
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}