/* Topic catalog — Foundation → Deep → Architect */
const SLIDES = {};

const SLIDE_SECTIONS = {
  1: "What",
  2: "Why",
  3: "How",
  4: "Prod Use Case",
  5: "Architecture",
  6: "YAML",
  7: "Failure",
  8: "Interview",
};

const LEARNING_PATH = [
  { step: 1, label: "Start", topics: ["learning-path", "think-like-architect"] },
  { step: 2, label: "Foundation", group: "01 · Foundation" },
  { step: 3, label: "Deep Dive", groups: ["02 · Workloads Deep", "03 · Namespace Deep", "04 · Storage Deep", "05 · Networking Deep", "06 · Cluster Design Deep", "07 · Security Deep", "08 · Platform Internals"] },
  { step: 4, label: "Operate", groups: ["09 · Observability", "10 · Delivery", "11 · Architect", "12 · Troubleshooting", "13 · Labs"] },
];

const TOPICS = [
  // ── 00 Start ──
  { id: "learning-path", title: "Learning Path", icon: "LP", color: "#326ce5", group: "00 · Start Here",
    brief: "Foundation → Deep → Architect. Is order me padho — docs ki zaroorat nahi." },

  // ── 01 Foundation (basic only — 2 slides each) ──
  { id: "fnd-pod", title: "Pod", icon: "PO", color: "#56ccf2", group: "01 · Foundation",
    brief: "Smallest unit — containers run inside pod." },
  { id: "fnd-replicaset", title: "ReplicaSet", icon: "RS", color: "#56ccf2", group: "01 · Foundation",
    brief: "Keeps N pod copies running — self-healing." },
  { id: "fnd-deployment", title: "Deployment", icon: "DP", color: "#56ccf2", group: "01 · Foundation",
    brief: "Stateless apps — rolling update + scale." },
  { id: "fnd-statefulset", title: "StatefulSet", icon: "SS", color: "#56ccf2", group: "01 · Foundation",
    brief: "Stable name + disk — databases." },
  { id: "fnd-daemonset", title: "DaemonSet", icon: "DS", color: "#56ccf2", group: "01 · Foundation",
    brief: "1 pod per node — agents, monitoring." },
  { id: "fnd-job", title: "Job & CronJob", icon: "JB", color: "#56ccf2", group: "01 · Foundation",
    brief: "Run once or on schedule — batch work." },
  { id: "fnd-namespace", title: "Namespace", icon: "NS", color: "#56ccf2", group: "01 · Foundation",
    brief: "Logical isolation — teams/apps separate." },
  { id: "fnd-service", title: "Service", icon: "SV", color: "#56ccf2", group: "01 · Foundation",
    brief: "Stable DNS/IP for pods — never use pod IP." },
  { id: "fnd-ingress", title: "Ingress", icon: "IN", color: "#56ccf2", group: "01 · Foundation",
    brief: "HTTP entry — route URL to services." },
  { id: "fnd-config-secret", title: "ConfigMap & Secret", icon: "CS", color: "#56ccf2", group: "01 · Foundation",
    brief: "Config vs passwords — inject to pods." },
  { id: "fnd-storage", title: "Storage (PV/PVC)", icon: "ST", color: "#56ccf2", group: "01 · Foundation",
    brief: "Persistent data — survives pod restart." },
  { id: "fnd-rbac", title: "RBAC", icon: "RB", color: "#56ccf2", group: "01 · Foundation",
    brief: "Who can do what — Role + Binding." },
  { id: "fnd-networkpolicy", title: "NetworkPolicy", icon: "NP", color: "#56ccf2", group: "01 · Foundation",
    brief: "Firewall for pods — allow/deny traffic." },
  { id: "fnd-probes", title: "Probes & PDB", icon: "PD", color: "#56ccf2", group: "01 · Foundation",
    brief: "Health checks + safe maintenance." },

  // ── 02 Workloads Deep ──
  { id: "deployment-architect", title: "Deployment (8-Section)", icon: "DA", color: "#3dd68c", group: "02 · Workloads Deep",
    brief: "Gold template: What/Why/How/Prod/Fail/Interview." },
  { id: "deploy-fields-deep", title: "Deployment Every Field", icon: "DF", color: "#3dd68c", group: "02 · Workloads Deep",
    brief: "Resources, probes, affinity, security, rollout — har field." },
  { id: "statefulset-deep", title: "StatefulSet Deep", icon: "SD", color: "#3dd68c", group: "02 · Workloads Deep",
    brief: "Postgres, Kafka — stable identity + PVC per pod." },
  { id: "daemonset-deep", title: "DaemonSet Deep", icon: "DD", color: "#3dd68c", group: "02 · Workloads Deep",
    brief: "Prometheus node agent — industry example." },
  { id: "job-cronjob-deep", title: "Job & CronJob Deep", icon: "JC", color: "#3dd68c", group: "02 · Workloads Deep",
    brief: "Batch, backup jobs — retries, deadlines." },
  { id: "hpa", title: "HPA", icon: "HP", color: "#3dd68c", group: "02 · Workloads Deep",
    brief: "Auto scale pods on CPU/memory/custom metrics." },
  { id: "vpa", title: "VPA", icon: "VP", color: "#3dd68c", group: "02 · Workloads Deep",
    brief: "Vertical scale — right-size requests/limits." },
  { id: "probes-pdb", title: "Probes & PDB Deep", icon: "PB", color: "#3dd68c", group: "02 · Workloads Deep",
    brief: "Liveness, readiness, startup + disruption budget." },

  // ── 03 Namespace Deep ──
  { id: "namespace-deep", title: "Namespace Deep", icon: "ND", color: "#56ccf2", group: "03 · Namespace Deep",
    brief: "Quota, LimitRange, managed NS, member access." },
  { id: "entra-rbac", title: "Entra ID + K8s RBAC", icon: "ER", color: "#56ccf2", group: "03 · Namespace Deep",
    brief: "Azure AD groups → namespace least privilege." },

  // ── 04 Storage Deep ──
  { id: "storage-azure-disk", title: "Azure Disk (CSI)", icon: "AD", color: "#a78bfa", group: "04 · Storage Deep",
    brief: "RWO database storage — MI permissions flow." },
  { id: "storage-azure-files", title: "Azure Files (RWX)", icon: "AF", color: "#a78bfa", group: "04 · Storage Deep",
    brief: "Shared storage — multiple pods same volume." },
  { id: "storage-flow", title: "Storage End-to-End", icon: "SF", color: "#a78bfa", group: "04 · Storage Deep",
    brief: "StorageClass → PVC → mount — full prereq." },

  // ── 05 Networking Deep ──
  { id: "service-deep", title: "Service Deep", icon: "SY", color: "#f5a623", group: "05 · Networking Deep",
    brief: "ClusterIP, NodePort, LoadBalancer — har type." },
  { id: "ingress-yaml-deep", title: "Ingress Deep", icon: "IY", color: "#f5a623", group: "05 · Networking Deep",
    brief: "TLS, paths, cert-manager, AGIC vs nginx." },
  { id: "netpol-deep", title: "NetworkPolicy Deep", icon: "NP", color: "#f5a623", group: "05 · Networking Deep",
    brief: "ingress/egress rules — podSelector, ipBlock, ports." },
  { id: "dns-coredns", title: "DNS & CoreDNS", icon: "DN", color: "#f5a623", group: "05 · Networking Deep",
    brief: "Cluster DNS + custom dnsConfig/dnsPolicy." },
  { id: "cni-deep", title: "CNI Deep", icon: "CN", color: "#f5a623", group: "05 · Networking Deep",
    brief: "Calico, Cilium, ACNS — Azure CNI overlay." },
  { id: "frontdoor-waf", title: "Front Door + WAF", icon: "FD", color: "#f5a623", group: "05 · Networking Deep",
    brief: "Edge security before cluster." },
  { id: "service-mesh", title: "Service Mesh", icon: "SM", color: "#f5a623", group: "05 · Networking Deep",
    brief: "Istio — mTLS, canary, observability." },
  { id: "website-live-e2e", title: "Live Website E2E", icon: "WB", color: "#f5a623", group: "05 · Networking Deep",
    brief: "Internet → pod full production flow." },

  // ── 06 Cluster Design Deep ──
  { id: "vnet-cidr-design", title: "VNet & CIDR Design", icon: "VN", color: "#326ce5", group: "06 · Cluster Design Deep",
    brief: "Node IP, pod CIDR, service CIDR — Azure CNI." },
  { id: "public-private-cluster", title: "Public vs Private Cluster", icon: "PP", color: "#326ce5", group: "06 · Cluster Design Deep",
    brief: "API access, CI/CD, break-glass — industry choice." },
  { id: "multi-az", title: "Multi-AZ Design", icon: "AZ", color: "#326ce5", group: "06 · Cluster Design Deep",
    brief: "Zone spread — HA architect pattern." },

  // ── 07 Security Deep ──
  { id: "rbac", title: "RBAC Deep", icon: "RB", color: "#ff6b6b", group: "07 · Security Deep",
    brief: "Role, ClusterRole, Binding — least privilege." },
  { id: "serviceaccount", title: "Service Account Deep", icon: "SA", color: "#ff6b6b", group: "07 · Security Deep",
    brief: "Pod identity — token, automount." },
  { id: "workload-identity", title: "Workload Identity", icon: "WI", color: "#ff6b6b", group: "07 · Security Deep",
    brief: "K8s SA → Azure MI — no static keys." },
  { id: "keyvault-flow", title: "Key Vault + CSI", icon: "KV", color: "#ff6b6b", group: "07 · Security Deep",
    brief: "SecretProviderClass full flow." },
  { id: "security-hardening", title: "PSS, OPA, Kyverno", icon: "SH", color: "#ff6b6b", group: "07 · Security Deep",
    brief: "Policy engines + image scanning." },

  // ── 08 Platform Internals ──
  { id: "control-plane-deep", title: "Control Plane", icon: "CP", color: "#326ce5", group: "08 · Platform Internals",
    brief: "API server, scheduler, controller — system node." },
  { id: "etcd-ops", title: "etcd Backup & Restore", icon: "ET", color: "#326ce5", group: "08 · Platform Internals",
    brief: "Snapshot, store, restore, DR to new cluster." },
  { id: "worker-node-deep", title: "Worker Node Deep", icon: "WN", color: "#326ce5", group: "08 · Platform Internals",
    brief: "kubelet, containerd, labels, taints, kube-proxy." },
  { id: "node-upgrade-e2e", title: "Node Upgrade E2E", icon: "NU", color: "#326ce5", group: "08 · Platform Internals",
    brief: "Cordon, drain, upgrade — prereq to completion." },
  { id: "cluster-autoscaler", title: "Cluster Autoscaler", icon: "CA", color: "#326ce5", group: "08 · Platform Internals",
    brief: "Pending pods → new nodes." },

  // ── 09 Observability ──
  { id: "monitoring", title: "Monitoring", icon: "MO", color: "#56ccf2", group: "09 · Observability",
    brief: "Prometheus, Grafana, alerts, SLOs." },
  { id: "logging", title: "Logging", icon: "LG", color: "#56ccf2", group: "09 · Observability",
    brief: "Fluent Bit, Loki, Azure Monitor." },

  // ── 10 Delivery ──
  { id: "delivery-deep", title: "CI/CD Full Pipeline", icon: "CD", color: "#a78bfa", group: "10 · Delivery",
    brief: "ADO, GHA, GitLab, Jenkins + WIF + OWASP." },
  { id: "helm", title: "Helm Deep", icon: "HM", color: "#a78bfa", group: "10 · Delivery",
    brief: "Charts, values, rollback." },
  { id: "gitops-argocd", title: "GitOps & ArgoCD", icon: "AG", color: "#a78bfa", group: "10 · Delivery",
    brief: "Git source of truth — sync, drift, rollback." },

  // ── 11 Architect ──
  { id: "think-like-architect", title: "Think Like Architect", icon: "TA", color: "#326ce5", group: "11 · Architect",
    brief: "5 questions every design — fail, traffic, scale, secure, recover." },
  { id: "architect-checklist", title: "Architect Checklist", icon: "AC", color: "#326ce5", group: "11 · Architect",
    brief: "Prod-ready review before go-live." },
  { id: "disaster-recovery", title: "Disaster Recovery", icon: "DR", color: "#326ce5", group: "11 · Architect",
    brief: "RTO/RPO, Velero, rebuild cluster." },
  { id: "cost-optimization", title: "Cost Optimization", icon: "CO", color: "#326ce5", group: "11 · Architect",
    brief: "Rightsizing, spot nodes, FinOps." },

  // ── 12 Troubleshooting ──
  { id: "troubleshooting", title: "24 Prod Scenarios", icon: "TS", color: "#ff6b6b", group: "12 · Troubleshooting",
    brief: "Symptom → diagnose → fix — interview + on-call." },

  // ── 13 Labs ──
  { id: "three-tier", title: "3-Tier Hands-On Lab", icon: "3T", color: "#3dd68c", group: "13 · Labs",
    brief: "nginx → Flask → PostgreSQL on Kind." },
];

const ARCH_LAYERS = [
  { label: "Control Plane", nodes: [
    { id: "api-server", name: "API Server" }, { id: "etcd", name: "etcd" },
    { id: "scheduler", name: "Scheduler" }, { id: "controller", name: "Controller" },
  ]},
  { label: "Workload Chain", nodes: [
    { id: "deployment", name: "Deployment" }, { id: "replicaset", name: "ReplicaSet" },
    { id: "statefulset", name: "StatefulSet" }, { id: "pods", name: "Pod" },
  ]},
  { label: "Traffic & Scale", nodes: [
    { id: "service", name: "Service" }, { id: "dns", name: "CoreDNS" },
    { id: "ingress-ctrl", name: "Ingress" }, { id: "lb", name: "Load Balancer" },
    { id: "hpa", name: "HPA" },
  ]},
  { label: "Security & Platform", nodes: [
    { id: "rbac", name: "RBAC" }, { id: "np", name: "NetPolicy" },
    { id: "mi", name: "Managed ID" }, { id: "keyvault", name: "Key Vault" },
    { id: "cni", name: "CNI" }, { id: "csi", name: "CSI" }, { id: "argocd", name: "ArgoCD" },
  ]},
  { label: "Nodes", nodes: [
    { id: "nodes", name: "Worker Node" }, { id: "kubelet", name: "kubelet" },
  ]},
  { label: "Your Lab", nodes: [
    { id: "frontend", name: "frontend" }, { id: "backend", name: "backend" }, { id: "postgres", name: "postgres" },
  ]},
];
