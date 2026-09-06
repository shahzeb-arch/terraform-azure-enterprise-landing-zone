/* 00 Start + 01 Foundation — short 2-slide basics */
Object.assign(SLIDES, {

  "learning-path": [
    {
      title: "How To Use This Playbook",
      subtitle: "Foundation → Deep → Architect",
      points: [
        "STEP 1: 00 Start + 01 Foundation — har resource basic (2 slides each)",
        "STEP 2: Deep sections 02–08 — har topic production depth, YAML, failures",
        "STEP 3: 09–12 — Observability, Delivery, Architect mindset, 24 troubleshooting",
        "STEP 4: 13 Labs — hands-on Kind cluster",
        "Rule: Foundation clear karo PEHLE — phir Deep me jao. Docs mat kholo.",
      ],
      diagram: `Foundation (WHAT)  →  Deep Dive (HOW + YAML + FAIL)
        →  Architect (WHY + DR + COST + DESIGN)  →  Lab (DO)`,
      archNodes: ["deployment", "service", "etcd"],
    },
    {
      title: "8-Section Deep Template",
      subtitle: "Har deep topic isi format me",
      points: [
        "§1 What  §2 Why  §3 How  §4 Prod Use Case",
        "§5 Architecture  §6 YAML  §7 Failure  §8 Interview",
        "Gold standard: Deployment (8-Section) in Workloads Deep",
        "Assistant panel — koi bhi sawal pucho",
      ],
      flowSteps: [
        "01 Foundation padho (1-2 din)",
        "02 Workloads Deep — Deployment (8-Section)",
        "05 Networking Deep — NetPol + Service",
        "08 Platform Internals — etcd + node upgrade",
        "12 Troubleshooting — 24 scenarios",
        "13 Lab — 3-tier break-it",
      ],
      archNodes: ["deployment"],
    },
  ],

  "fnd-pod": [
    { title: "Pod — Basic", subtitle: "Foundation", points: ["Smallest deploy unit — 1+ containers share network/storage", "Ephemeral — restart = new IP often", "Never create Pod directly in prod — use Deployment", "Industry: Pod = cattle not pets"], diagram: `Pod\n ├── container (app)\n └── optional sidecar`, archNodes: ["pods"] },
    { title: "Pod — When & Why", subtitle: "Foundation", points: ["Use: run containers on cluster", "Not for: direct prod management", "Stable IP needed? → Service, not Pod IP", "Next: ReplicaSet Deep"], archNodes: ["pods"] },
  ],

  "fnd-replicaset": [
    { title: "ReplicaSet — Basic", subtitle: "Foundation", points: ["Maintains N identical pods running", "Pod dies → RS creates replacement", "Selector + labels match pods", "You rarely apply RS YAML — Deployment does it"], archNodes: ["replicaset", "pods"] },
    { title: "ReplicaSet — Why", subtitle: "Foundation", points: ["Problem: manual pod count = outage risk", "RS = self-healing replica count", "Deployment wraps RS + rollout strategy", "Next: Deployment Deep"], archNodes: ["replicaset"] },
  ],

  "fnd-deployment": [
    { title: "Deployment — Basic", subtitle: "Foundation", points: ["Stateless apps — web, API, workers", "Declarative: replicas + image version", "Rolling update built-in", "Manages ReplicaSet internally"], diagram: `Deployment → ReplicaSet → Pods`, archNodes: ["deployment", "replicaset", "pods"] },
    { title: "Deployment — When", subtitle: "Foundation", points: ["Use: frontend, API, auth, notifications", "NOT for: database (StatefulSet)", "NOT for: per-node agent (DaemonSet)", "Deep dive: 02 Workloads Deep"], archNodes: ["deployment"] },
  ],

  "fnd-statefulset": [
    { title: "StatefulSet — Basic", subtitle: "Foundation", points: ["Stable pod name: app-0, app-1", "Each pod gets own PVC (disk)", "Ordered start/stop", "Headless Service for direct pod DNS"], archNodes: ["statefulset", "pods"] },
    { title: "StatefulSet — When", subtitle: "Foundation", points: ["Use: PostgreSQL, MySQL, Kafka, Redis cluster", "Why not Deployment: random names + shared storage risk", "Industry: all stateful data workloads", "Deep: StatefulSet Deep"], archNodes: ["statefulset", "postgres"] },
  ],

  "fnd-daemonset": [
    { title: "DaemonSet — Basic", subtitle: "Foundation", points: ["Exactly 1 pod per node (auto)", "New node joins → pod auto scheduled", "Use tolerations for tainted nodes", "Platform team often manages these"], archNodes: ["pods", "nodes"] },
    { title: "DaemonSet — When", subtitle: "Foundation", points: ["Log collector (Fluent Bit)", "Monitoring agent (node-exporter)", "CNI node component", "Deep: DaemonSet Deep + Prometheus example"], archNodes: ["pods"] },
  ],

  "fnd-job": [
    { title: "Job & CronJob — Basic", subtitle: "Foundation", points: ["Job: run to completion once", "CronJob: Job on schedule (0 2 * * *)", "Retries + backoff configurable", "Pod stays until Job success/fail"], archNodes: ["pods"] },
    { title: "Job — When", subtitle: "Foundation", points: ["DB migration, report generation", "Nightly backup CronJob", "NOT for long-running services", "Deep: Job & CronJob Deep"], archNodes: ["pods"] },
  ],

  "fnd-namespace": [
    { title: "Namespace — Basic", subtitle: "Foundation", points: ["Virtual cluster inside cluster", "Isolate teams/apps/resources", "DNS scope: service.ns.svc.cluster.local", "default, kube-system built-in"], archNodes: ["pods"] },
    { title: "Namespace — When", subtitle: "Foundation", points: ["Prod: 1 namespace per team/app/env", "Managed NS: quota + RBAC boundary", "Simple segregation without new cluster", "Deep: Namespace Deep"], archNodes: ["rbac"] },
  ],

  "fnd-service": [
    { title: "Service — Basic", subtitle: "Foundation", points: ["Stable ClusterIP + DNS for pods", "Selector matches pod labels", "Only ready pods in endpoints", "Never put pod IP in app config"], archNodes: ["service", "pods"] },
    { title: "Service Types", subtitle: "Foundation", points: ["ClusterIP: internal (default)", "NodePort: dev/test external port", "LoadBalancer: cloud external IP", "Deep: Service Deep"], archNodes: ["service"] },
  ],

  "fnd-ingress": [
    { title: "Ingress — Basic", subtitle: "Foundation", points: ["HTTP/S routing into cluster", "One URL → multiple services by path", "Needs Ingress Controller installed", "TLS termination at ingress"], archNodes: ["ingress-ctrl", "service"] },
    { title: "Ingress — When", subtitle: "Foundation", points: ["Public web apps in prod", "Alternative: cloud LB per service (costly)", "Deep: Ingress Deep + Front Door", "Deep: Live Website E2E"], archNodes: ["ingress-ctrl"] },
  ],

  "fnd-config-secret": [
    { title: "ConfigMap & Secret", subtitle: "Foundation", points: ["ConfigMap: non-sensitive config", "Secret: passwords, tokens, certs", "Inject via env or volume mount", "Secret base64 in etcd — not encryption"], archNodes: ["keyvault"] },
    { title: "When & Prod Rule", subtitle: "Foundation", points: ["Prod: secrets NOT in Git", "Use Key Vault + CSI in prod", "ConfigMap change may need pod restart", "Deep: Key Vault + CSI"], archNodes: ["keyvault"] },
  ],

  "fnd-storage": [
    { title: "Storage — Basic", subtitle: "Foundation", points: ["emptyDir: dies with pod", "PVC: persistent — survives restart", "PV: actual storage backend", "StorageClass: dynamic provision template"], archNodes: ["csi", "pods"] },
    { title: "When", subtitle: "Foundation", points: ["Database → PVC required", "Cache/temp → emptyDir OK", "Deep: Azure Disk, Files, CSI + MI", "Lab: postgres PVC in 3-tier"], archNodes: ["csi", "postgres"] },
  ],

  "fnd-rbac": [
    { title: "RBAC — Basic", subtitle: "Foundation", points: ["Role = permissions list", "RoleBinding = user/SA → Role", "ClusterRole = cluster-wide", "Least privilege: minimum verbs needed"], archNodes: ["rbac"] },
    { title: "When", subtitle: "Foundation", points: ["Every human + app gets scoped access", "Namespace scope = your prod reality", "Deep: RBAC + Entra ID", "Test: kubectl auth can-i"], archNodes: ["rbac"] },
  ],

  "fnd-networkpolicy": [
    { title: "NetworkPolicy — Basic", subtitle: "Foundation", points: ["Firewall rules for pods", "Default: all pods talk freely (risky)", "Best: default deny + explicit allow", "Needs CNI support (Calico, Cilium)"], archNodes: ["np", "cni"] },
    { title: "When", subtitle: "Foundation", points: ["Prod: zero trust between tiers", "frontend → backend only, not DB direct", "Deep: NetworkPolicy Deep — all rule types", "Lab: 05-network-policies.yaml"], archNodes: ["np"] },
  ],

  "fnd-probes": [
    { title: "Probes — Basic", subtitle: "Foundation", points: ["liveness: alive? fail → restart", "readiness: ready for traffic? fail → no endpoints", "startup: slow apps — delay liveness", "HTTP / exec / tcpSocket"], archNodes: ["pods"] },
    { title: "PDB — Basic", subtitle: "Foundation", points: ["PodDisruptionBudget: min pods during drain", "Node upgrade / cluster maintenance", "Without PDB: all pods down at once", "Deep: Probes & PDB Deep"], archNodes: ["pods"] },
  ],

});
