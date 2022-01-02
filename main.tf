shishir_linux@cloudshell:~/terraform (devopstest-336815)$ cat main.tf
provider "kubernetes" {
  config_path    = "~/terraform/kubeconfig-k8s"
  config_context = "shishir-cluster-k8s"
}
provider "google" {
  version = "~> 3.42.0"
}
module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [module.gke]
  project_id   = "devopstest-336815"
  location     = module.gke.location
  cluster_name = module.gke.name
}
resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}"
}


module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.5"
  project_id   = "devopstest-336815"
  network_name = "${var.network}-${var.env_name}"
  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    },
  ]
  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}

module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id             = "devopstest-336815"
  name                   = "${var.cluster_name}-${var.env_name}"
  regional               = true
  region                 = var.region
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  node_pools = [
    {
      name                      = "node-pool"
      machine_type              = "e2-medium"
      node_locations            = "europe-west1-b,europe-west1-c,europe-west1-d"
      min_count                 = 1
      max_count                 = 1
      disk_size_gb              = 20
    },
  ]
}
#provider "kubernetes" {
 # config_path    = "~/terraform/kubeconfig-k8s"
 # config_context = "shishir-cluster-k8s"
  #depends_on = ["local_file.kubeconfig"]
#}
resource "kubernetes_namespace" "dev" {
  metadata {
      name = "dev"
}
  depends_on = [local_file.kubeconfig]
}
resource "kubernetes_namespace" "stg" {
  metadata {
      name = "stg"
}
  depends_on = [local_file.kubeconfig]
}
resource "kubernetes_namespace" "prd" {
  metadata {
      name = "prd"
}
  depends_on = [local_file.kubeconfig]
}
