resource "helm_release" "helm_this" {
  name       = var.name
  namespace  = var.namespace
  repository = var.chart_url
  chart      = var.chart_name
  version    = var.chart_version

  create_namespace = var.create_namespace

  values = [
    "${file("./values/values.yaml")}"
  ]

  #values = [<<EOF
#EOF
  #]

  dynamic "set" {
    for_each = var.set_values

    content {
      name   = set.value.name
      value  = set.value.value
      type   = set.value.type
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive_values

    content {
      name   = set_sensitive.value.name
      value  = set_sensitive.value.value
      type   = set_sensitive.value.type
    }
  }

  #depends_on = [
  #]
}
