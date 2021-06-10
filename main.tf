resource "helm_release" "prometheus" {
  count = var.prometheus_enable ? 1 : 0

  name       = var.release_name
  chart      = var.chart_name
  repository = var.chart_repository
  version    = var.chart_version
  namespace  = var.chart_namespace

  max_history = var.max_history

  values = [
    templatefile("${path.module}/templates/general.yaml", local.general_values),
    templatefile("${path.module}/templates/pushgateway.yaml", local.pushgateway_values),
    templatefile("${path.module}/templates/server.yaml", local.server_values),
  ]
}

locals {
  general_values = {
    pod_security_policy_enable = var.pod_security_policy_enable

    image_pull_secrets = jsonencode(var.image_pull_secrets)

    configmap_name              = var.configmap_name
    configmap_image_repo        = var.configmap_image_repo
    configmap_image_tag         = var.configmap_image_tag
    configmap_image_pull_policy = var.configmap_pull_policy

    configmap_extra_args    = jsonencode(var.configmap_extra_args)
    configmap_extra_volumes = jsonencode(var.configmap_extra_volumes)
    configmap_resources     = jsonencode(var.configmap_resources)

    extra_scrape_configs  = jsonencode(var.extra_scrape_configs)
    enable_network_policy = var.enable_network_policy

    pushgateway_service_account = var.pushgateway_service_account
    server_service_account      = var.server_service_account

    pushgateway_service_account_annotations = jsonencode(var.pushgateway_service_account_annotations)
    server_service_account_annotations      = jsonencode(var.server_service_account_annotations)
  }

  pushgateway_values = {
    enable = var.pushgateway_enable

    repository  = var.pushgateway_repository
    tag         = var.pushgateway_tag
    pull_policy = var.pushgateway_pull_policy

    replica   = var.pushgateway_replica
    resources = jsonencode(var.pushgateway_resources)

    annotations   = jsonencode(var.pushgateway_annotations)
    tolerations   = jsonencode(var.pushgateway_tolerations)
    node_selector = jsonencode(var.pushgateway_node_selector)

    security_context = coalesce(
      var.pushgateway_security_context_json,
      jsonencode(var.pushgateway_security_context),
    )

    priority_class_name = var.pushgateway_priority_class_name
    extra_args          = jsonencode(var.pushgateway_extra_args)
    extra_env           = jsonencode(var.pushgateway_extra_env)

    service_annotations      = jsonencode(var.pushgateway_service_annotations)
    service_labels           = jsonencode(var.pushgateway_service_labels)
    service_cluster_ip       = jsonencode(var.pushgateway_service_cluster_ip)
    service_external_ips     = jsonencode(var.pushgateway_service_external_ips)
    service_lb_ip            = jsonencode(var.pushgateway_service_lb_ip)
    service_lb_source_ranges = jsonencode(var.pushgateway_service_lb_source_ranges)
    service_port             = var.pushgateway_service_port
    service_type             = var.pushgateway_service_type

    ingress_enabled      = var.pushgateway_ingress_enabled
    ingress_annotations  = jsonencode(var.pushgateway_ingress_annotations)
    ingress_extra_labels = jsonencode(var.pushgateway_ingress_extra_labels)
    ingress_hosts        = jsonencode(var.pushgateway_ingress_hosts)
    ingress_tls          = jsonencode(var.pushgateway_ingress_tls)

    pv_enabled        = var.pushgateway_pv_enabled
    pv_access_modes   = jsonencode(var.pushgateway_pv_access_modes)
    pv_annotations    = jsonencode(var.pushgateway_pv_annotations)
    pv_existing_claim = var.pushgateway_pv_existing_claim
    pv_size           = var.pushgateway_pv_size

    pod_security_policy_annotations = jsonencode(var.pushgateway_pod_security_policy_annotations)

    pdb_enable          = var.pushgateway_pdb_enable
    pdb_max_unavailable = jsonencode(var.pushgateway_pdb_max_unavailable)
  }

  server_values = {
    enable = var.server_enable

    repository  = var.server_repository
    tag         = var.server_tag
    pull_policy = var.server_pull_policy

    sidecar_containers = jsonencode(var.server_sidecar_containers)

    replica   = var.server_replica
    resources = jsonencode(var.server_resources)

    enable_service_links = var.server_enable_service_links

    annotations   = jsonencode(var.server_annotations)
    tolerations   = jsonencode(var.server_tolerations)
    node_selector = jsonencode(var.server_node_selector)
    affinity      = jsonencode(var.server_affinity)

    security_context = coalesce(
      var.server_security_context_json,
      jsonencode(var.server_security_context),
    )

    statefulset_annotations   = jsonencode(var.server_statefulset_annotations)
    termination_grace_seconds = var.server_termination_grace_seconds

    prefix_url = var.server_prefix_url
    base_url   = var.server_base_url

    priority_class_name = var.server_priority_class_name
    extra_args          = jsonencode(var.server_extra_args)
    extra_env           = jsonencode(var.server_extra_env)
    extra_volume_mounts = jsonencode(var.server_extra_volume_mounts)

    extra_volumes          = jsonencode(var.server_extra_volumes)
    extra_host_path_mounts = jsonencode(var.server_extra_host_path_mounts)
    extra_configmap_mounts = jsonencode(var.server_extra_configmap_mounts)
    extra_secret_mounts    = jsonencode(var.server_extra_secret_mounts)

    headless_annotations = jsonencode(var.server_headless_annotations)
    headless_labels      = jsonencode(var.server_headless_labels)

    service_annotations      = jsonencode(var.server_service_annotations)
    service_labels           = jsonencode(var.server_service_labels)
    service_cluster_ip       = jsonencode(var.server_service_cluster_ip)
    service_external_ips     = jsonencode(var.server_service_external_ips)
    service_lb_ip            = jsonencode(var.server_service_lb_ip)
    service_lb_source_ranges = jsonencode(var.server_service_lb_source_ranges)
    service_port             = var.server_service_port
    service_type             = var.server_service_type

    ingress_enabled      = var.server_ingress_enabled
    ingress_annotations  = jsonencode(var.server_ingress_annotations)
    ingress_extra_labels = jsonencode(var.server_ingress_extra_labels)
    ingress_hosts        = jsonencode(var.server_ingress_hosts)
    ingress_tls          = jsonencode(var.server_ingress_tls)

    pv_enabled        = var.server_pv_enabled
    pv_access_modes   = jsonencode(var.server_pv_access_modes)
    pv_annotations    = jsonencode(var.server_pv_annotations)
    pv_existing_claim = var.server_pv_existing_claim
    pv_size           = var.server_pv_size

    extra_flags         = jsonencode(local.server_extra_flags)
    scrape_interval     = var.server_scrape_interval
    scrape_timeout      = var.server_scrape_timeout
    evaluation_interval = var.server_evaluation_interval
    retention           = jsonencode(var.server_data_retention)
    additional_global   = var.server_additional_global

    alerts = var.server_enable ? indent(6, var.server_alerts) : "[]"
    rules  = var.server_enable ? indent(6, var.server_rules) : "[]"

    remote_write_configs = var.prometheus_remote_write_api_url != null ? indent(4, yamlencode({
      remote_write = [
        {
          url = var.prometheus_remote_write_api_url
        }
      ]
    })) : ""

    remote_read_configs = var.prometheus_remote_read_api_url != null ? indent(4, yamlencode({
      remote_read = [
        {
          url = var.prometheus_remote_read_api_url
        }
      ]
    })) : ""

    self_scrape_config = var.server_enable ? indent(6, yamlencode(local.self_scrape_config)) : ""
    scrape_configs     = var.server_enable ? indent(6, templatefile("${path.module}/templates/scrape_configs.yaml", local.scrape_config_values)) : ""

    pod_security_policy_annotations = jsonencode(var.server_pod_security_policy_annotations)

    pdb_enable          = var.server_pdb_enable
    pdb_max_unavailable = jsonencode(var.server_pdb_max_unavailable)

    readiness_probe_initial_delay = var.server_readiness_probe_initial_delay
    readiness_probe_timeout       = var.server_readiness_probe_timeout
    liveness_probe_initial_delay  = var.server_liveness_probe_initial_delay
    liveness_probe_timeout        = var.server_liveness_probe_timeout
  }
}
