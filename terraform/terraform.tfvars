vpc_main_cidr         = "10.60.20.0/24"            # nodes subnet
gateway               = "10.60.20.1"               # subnet gateway
first_ip              = "11"                     # first ip address of the master-1 node - 10.1.1.11
worker_first_ip       = "21"                     # first ip address of the worker-1 node - 10.1.1.21
proxmox_storage_nvme      = "local-nvme-vm"                    # proxmox storage NVMe
proxmox_storage_hdd      = "local-storage"                   # proxmox storage HDD
k8s_version           = "v1.31.2"                # k8s version
proxmox_image         = "talos"                  # talos image created by packer
talos_version         = "v1.8"                  # talos version for machineconfig gen
cluster_endpoint      = "https://10.60.20.10:6443" # cluster endpoint to fetch via talosctl
region                = "kmi"              # proxmox cluster name
pool                  = "dev"                   # proxmox pool for vms
private_key_file_path = "~/.ssh/id_rsa"          # fluxcd git creds for ssh
public_key_file_path  = "~/.ssh/id_rsa.pub"      # fluxcd git creds for ssh
known_hosts           = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="

kubernetes = {
  podSubnets              = "10.60.120.0/21"      # pod subnet
  serviceSubnets          = "10.60.60.0/22"        # svc subnet
  domain                  = "cluster.local"       # cluster local kube-dns svc.cluster.local
  ipv4_vip                = "10.60.20.10"           # vip ip address
  apiDomain               = "api.cluster.local"   # cluster endpoint
  talos-version           = "v1.8.2"              # talos installer version
  metallb_l2_addressrange = "10.60.20.100-10.60.20.200" # metallb L2 configuration ip range
  registry-endpoint       = "browarski.dev"   # set registry url for cache image pull
  # FLUX ConfigMap settings
  sidero-endpoint = "10.60.20.30"
  cluster-0-vip   = "10.60.20.40"
}