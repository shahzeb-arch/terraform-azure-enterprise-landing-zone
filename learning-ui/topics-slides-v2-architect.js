Object.assign(SLIDES, {

  "think-like-architect": [
    {
      section: 1,
      title: "Architect vs CKA Engineer",
      subtitle: "Mindset shift",
      points: [
        "CKA engineer: YAML likhna, resource create karna, exam pass",
        "Architect: WHY decide karna — trade-offs, failure, cost, security, recovery",
        "Hamara goal: 'Production me Kubernetes kaise SOCHA jata hai' — docs nahi padhana",
        "Har topic pe 5 questions pucho (next slide)",
        "Ye platform unique isliye banega — YouTube theory nahi, war stories + decisions",
      ],
      diagram: `Engineer thinks:  "How to apply Deployment?"
Architect thinks: "Should this BE a Deployment?
                   What if node dies?
                   How do users reach it?
                   How do we scale & recover?"`,
      archNodes: ["deployment", "service", "ingress-ctrl"],
    },
    {
      section: 2,
      title: "5 Questions — Har Design Pe",
      subtitle: "Think Like Architect framework",
      points: [
        "① FAIL: Agar ye resource mar jaye to kya hoga?",
        "② TRAFFIC: User request pod tak kaise pahunchegi?",
        "③ SCALE: Load badhe to kya scale hoga — pod? node?",
        "④ SECURE: Kaun access karega? secret kahan? attack surface?",
        "⑤ RECOVER: Backup? rollback? RTO kitna acceptable?",
      ],
      flowSteps: [
        "Service delete ho gayi → frontend backend se kaise baat karega? → DNS fail",
        "Deployment rollout fail → maxUnavailable + rollback strategy?",
        "etcd corrupt → poora cluster?",
        "Traffic 10x → HPA enough ya node bhi chahiye?",
        "Secret Git me leak → Key Vault + policy?",
      ],
      prodTip: "Interview me diagram draw karo + ye 5 questions aloud bolo.",
      archNodes: ["deployment", "service", "etcd", "hpa", "keyvault"],
    },
    {
      section: 3,
      title: "8-Section Template",
      subtitle: "Har topic isi format me",
      points: [
        "1 What → 2 Why → 3 How → 4 Prod Use Case → 5 Architecture → 6 YAML → 7 Failure → 8 Interview",
        "Pehla gold standard topic: Deployment (Architect) — 8 slides",
        "Baaki topics gradually is format me convert honge",
        "Overview topics (short) + Architect topics (deep) — dono rahenge",
      ],
      diagram: `Concept → Use Case → Architecture → YAML
    → Failure → Troubleshooting → Design Decision

"Deployment (Architect)" = template copy for all topics`,
      archNodes: ["deployment"],
    },
  ],

  "deployment-architect": [
    {
      section: 1,
      title: "What — Deployment kya hai?",
      subtitle: "Section 1/8",
      points: [
        "Deployment = stateless app ko cluster me run karne ka declarative way",
        "Tum desired state likho (3 replicas, image v2) — cluster match karta rehta hai",
        "Internally ReplicaSet banata hai jo pods manage karta hai",
        "Rolling update built-in — naya version gradually deploy",
      ],
      diagram: `Deployment (desired: 3 pods, image v2)
    └── ReplicaSet
          ├── Pod-1
          ├── Pod-2
          └── Pod-3`,
      archNodes: ["deployment", "replicaset", "pods"],
    },
    {
      section: 2,
      title: "Why — Deployment kyun? Alternatives kyun nahi?",
      subtitle: "Section 2/8",
      points: [
        "Sirf Pod? → crash pe gayab, scale manual, no rollout",
        "ReplicaSet direct? → update strategy nahi, history nahi — Deployment better",
        "StatefulSet? → stable name + disk chahiye (DB) — web API ke liye overkill",
        "DaemonSet? → har node pe 1 — log agent, not web app",
        "Industry: Frontend, Backend API, Auth, Notifications = Deployment",
      ],
      diagram: `Web API, Auth, Frontend  → Deployment ✅
Postgres, Kafka, Redis    → StatefulSet ✅
Log agent on every node   → DaemonSet ✅
One-time migration        → Job ✅`,
      prodTip: "DB ko Deployment me mat daalo — data loss guarantee.",
      archNodes: ["deployment", "statefulset", "pods"],
    },
    {
      section: 3,
      title: "How — Kaise kaam karta hai?",
      subtitle: "Section 3/8",
      points: [
        "kubectl apply → API server → etcd store",
        "Deployment controller → ReplicaSet create/update",
        "ReplicaSet controller → pods create/delete to match replicas",
        "RollingUpdate: new RS scale up → old RS scale down",
        "Readiness fail → pod endpoints se hat jata hai — users safe",
      ],
      flowSteps: [
        "kubectl apply Deployment YAML",
        "Controller creates ReplicaSet",
        "Scheduler places pods on nodes",
        "kubelet starts containers",
        "Readiness pass → Service endpoints updated",
        "Old pods terminated after new ones ready",
      ],
      archNodes: ["deployment", "replicaset", "pods", "service", "scheduler"],
    },
    {
      section: 4,
      title: "Production Use Case",
      subtitle: "Section 4/8 — Real company",
      points: [
        "E-commerce: frontend (nginx) 5 replicas, cart-api 10 replicas, payment-api 3 replicas",
        "Har ek alag Deployment — independent scale + deploy",
        "Peak sale: HPA cart-api 10→50 replicas",
        "Payment deploy Friday: maxUnavailable 0 — zero downtime",
        "Auth service: separate Deployment + NetworkPolicy — blast radius kam",
      ],
      diagram: `Namespace: production
├── deploy/frontend      (5 replicas)
├── deploy/cart-api      (10 replicas, HPA)
├── deploy/payment-api   (3 replicas)
└── deploy/auth-api      (3 replicas)

Each = separate Deployment + Service + NP`,
      archNodes: ["deployment", "hpa", "service", "np"],
    },
    {
      section: 5,
      title: "Architecture Diagram",
      subtitle: "Section 5/8",
      points: [
        "User → Ingress → frontend Service → frontend pods (Deployment)",
        "frontend nginx → backend Service → backend pods (Deployment)",
        "Har Deployment apna Service + SA + NP",
        "Pods spread across nodes (anti-affinity) + zones (topology)",
      ],
      diagram: `Internet
   │
   ▼
Ingress
   ├── /     → Svc frontend → Deploy frontend (Pod×N)
   └── /api  → Svc backend  → Deploy backend  (Pod×N)
                      │
                      ▼
                 Deploy postgres → StatefulSet (NOT Deployment)`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["ingress-ctrl", "service", "deployment", "pods", "frontend", "backend"],
    },
    {
      section: 6,
      title: "YAML — Production Reference",
      subtitle: "Section 6/8",
      points: [
        "Full commented YAML repo me hai — har line samjho",
        "Critical rules: selector labels = template labels",
        "maxUnavailable: 0 prod me | resources hamesha set",
        "probes mandatory | runAsNonRoot | imagePullSecrets for private registry",
      ],
      diagram: `# Full file: k8s/examples/deployment-production.yaml
Key blocks:
  spec.replicas + strategy.rollingUpdate
  spec.template.spec.containers[]
    → image, resources, probes, securityContext
    → affinity, serviceAccountName`,
      labFile: "k8s/examples/deployment-production.yaml",
      archNodes: ["deployment"],
    },
    {
      section: 7,
      title: "Failure Scenarios",
      subtitle: "Section 7/8 — What breaks?",
      points: [
        "Node dies → pods reschedule other nodes (if resources + PDB allow)",
        "ImagePullBackOff → wrong tag, registry auth, corporate proxy",
        "Rollout stuck → readiness never passes — new pods never get traffic",
        "OOMKilled → memory limit cross — app or limit fix",
        "All pods same node → anti-affinity missing — node die = full outage",
      ],
      diagram: `Symptom              → Check
CrashLoopBackOff     → kubectl logs, probes
ImagePullBackOff     → describe pod Events
Rollout stuck        → kubectl rollout status
502 from users       → endpoints empty? readiness?`,
      prodTip: "Always: kubectl describe pod + kubectl get endpoints",
      archNodes: ["pods", "deployment"],
    },
    {
      section: 8,
      title: "Interview Questions",
      subtitle: "Section 8/8",
      points: [
        "Q: Deployment vs StatefulSet? → stateless vs stable identity+disk",
        "Q: Rolling update kaise control? → maxSurge, maxUnavailable",
        "Q: Rollback? → kubectl rollout undo / revisionHistoryLimit",
        "Q: Zero downtime deploy? → readiness probe + maxUnavailable:0 + PDB",
        "Q: Kab Deployment NA? → database, Kafka, any stateful data on pod",
      ],
      diagram: `Bonus architect Q:
"If I delete a Deployment but not its Service,
 what happens to traffic?"
→ Endpoints empty → connection refused/timeout`,
      archNodes: ["deployment", "service"],
    },
  ],

  hpa: [
    { section: 1, title: "What — HPA", subtitle: "Horizontal Pod Autoscaler", points: ["HPA automatically pod count badhata/ghatata hai metrics pe", "Horizontal = more pod copies (vertical = bigger pod — VPA alag)", "metrics-server CPU/memory ya custom metrics (Prometheus)", "Industry: har public-facing service pe HPA common"], diagram: `CPU 80% sustained → HPA → Deployment replicas 3→8`, archNodes: ["hpa", "deployment", "pods"] },
    { section: 2, title: "Why — Kyun chahiye?", subtitle: "Problem first", points: ["Traffic spike (sale, viral) → 3 pods enough nahi → 503 errors", "Manual scale slow — 2am pager ke baad kubectl scale?", "Cost: kam traffic pe scale down — paisa bachao", "HPA ≠ Cluster Autoscaler — pods vs nodes alag"], archNodes: ["hpa"] },
    { section: 4, title: "Prod Use Case", subtitle: "E-commerce sale", points: ["Normal: cart-api 5 replicas", "Sale: CPU 70% → HPA scales to 30", "Sale end: scales back to 5", "Must set resource requests — bina requests HPA kaam nahi karta"], diagram: `apiVersion: autoscaling/v2\nkind: HorizontalPodAutoscaler\n  minReplicas: 3\n  maxReplicas: 50\n  metrics: CPU 70%`, archNodes: ["hpa", "deployment"] },
    { section: 7, title: "Failure", subtitle: "HPA not scaling", points: ["No metrics-server installed", "resources.requests missing on pods", "maxReplicas too low", "Cooldown period — slow to scale"], archNodes: ["hpa"] },
    { section: 8, title: "Interview", subtitle: "Common Q", points: ["HPA vs VPA vs Cluster Autoscaler?", "Custom metrics se scale?", "requests/limits HPA se relation?"], archNodes: ["hpa", "nodes"] },
  ],

  "cluster-autoscaler": [
    { section: 1, title: "What — Cluster Autoscaler", subtitle: "Node level scale", points: ["Pods pending (no node fit) → cloud me naya node add", "Node underutilized → node remove (safely)", "AKS: cluster-autoscaler on node pool", "Pod scale (HPA) aur Node scale (CA) — dono alag"], diagram: `Pods pending → CA adds node → scheduler places pods`, archNodes: ["nodes", "hpa", "pods", "scheduler"] },
    { section: 2, title: "Why", subtitle: "HPA not enough", points: ["HPA 50 pods banaya — cluster me jagah nahi → Pending forever", "CA solves: more nodes", "Cost: night pe nodes kam"], archNodes: ["nodes", "hpa"] },
    { section: 7, title: "Failure", subtitle: "Pods stuck Pending", points: ["CA not enabled", "max node pool limit hit", "IAM/permissions", "Pod too big for any node size"], archNodes: ["nodes", "pods"] },
    { section: 8, title: "Interview", subtitle: "", points: ["HPA + CA together kaise kaam?", "What if CA adds node but pod still pending? → taints, affinity"], archNodes: ["nodes", "hpa"] },
  ],

  "etcd-ops": [
    { section: 1, title: "What — etcd", subtitle: "Cluster brain storage", points: ["etcd = K8s saari state store (deployments, secrets metadata, etc.)", "Control plane component — managed K8s me cloud handle", "Architect ko samajhna: etcd down = cluster down"], archNodes: ["etcd", "api-server"] },
    { section: 2, title: "Why backup", subtitle: "Disaster", points: ["etcd corrupt/loss → poora cluster state gone", "Backup + restore procedure documented hona chahiye", "Velero alag — etcd = control plane state"], archNodes: ["etcd"] },
    { section: 4, title: "Prod", subtitle: "Managed vs self", points: ["AKS/EKS: platform team etcd manage", "Self-managed: etcd backup cron mandatory", "Never manual etcd edit — API server use karo"], archNodes: ["etcd", "api-server"] },
    { section: 7, title: "Failure", subtitle: "", points: ["etcd quorum loss → API errors", "Restore wrong backup → state mismatch"], archNodes: ["etcd"] },
    { section: 8, title: "Interview", subtitle: "", points: ["What is stored in etcd?", "etcd vs application DB backup?"], archNodes: ["etcd"] },
  ],

  "multi-az": [
    { section: 1, title: "What — Multi-AZ", subtitle: "High availability", points: ["AZ = isolated data center zone within region", "Pods spread Zone A, B, C — ek zone down ≠ full outage", "topologySpreadConstraints / pod anti-affinity"], diagram: `Zone A: pod-1, pod-3\nZone B: pod-2\nZone C: pod-4`, archNodes: ["pods", "nodes"] },
    { section: 4, title: "Prod Design", subtitle: "", points: ["Node pool per zone", "PDB minAvailable across zones", "Load Balancer health checks per zone", "Database: zone-aware replication (managed DB)"], archNodes: ["pods", "lb", "service"] },
    { section: 7, title: "Failure", subtitle: "Single zone outage", points: ["All pods one zone → AZ down = outage", "Fix: topology spread + anti-affinity"], archNodes: ["pods", "nodes"] },
    { section: 8, title: "Interview", subtitle: "", points: ["How ensure pods multi-AZ?", "Zone down scenario walkthrough?"], archNodes: ["pods"] },
  ],

  "disaster-recovery": [
    { section: 1, title: "What — DR", subtitle: "Disaster Recovery", points: ["Cluster destroy / region fail → app wapas kaise chalaye", "RTO = kitni der me up | RPO = kitna data loss OK", "Backup: etcd, PVCs, Git manifests, secrets"], archNodes: ["etcd", "csi", "argocd"] },
    { section: 4, title: "Prod DR Plan", subtitle: "", flowSteps: ["Git = manifest source (ArgoCD)", "Velero = cluster resource + PVC backup", "Secrets in Key Vault (not lost with cluster)", "Secondary cluster standby or rebuild from Git", "DR drill quarterly — untested backup = no backup"], archNodes: ["argocd", "keyvault", "etcd"] },
    { section: 7, title: "Failure", subtitle: "DR drill fails", points: ["Backup outdated", "Secret not in vault", "Image registry down", "DNS still pointing dead cluster"], archNodes: ["argocd"] },
    { section: 8, title: "Interview", subtitle: "", points: ["RTO/RPO explain?", "How rebuild cluster from scratch?"], archNodes: ["etcd", "argocd"] },
  ],

  "cost-optimization": [
    { section: 1, title: "What", subtitle: "FinOps for K8s", points: ["K8s bill = nodes + LB + storage + egress", "Architect company ka paisa bhi bachata hai", "Rightsizing requests/limits — sabse bada lever"], archNodes: ["hpa", "nodes", "pods"] },
    { section: 4, title: "Prod Tactics", subtitle: "", points: ["Set requests right — monitor actual usage (kubectl top)", "HPA scale down off-peak", "Spot/Preemptible nodes for fault-tolerant workloads", "Separate node pools: system vs apps vs batch", "Delete unused LoadBalancers + orphaned PVCs"], diagram: `Over-provisioned requests = wasted nodes = $$$\nNo limits = noisy neighbor + surprise bill`, archNodes: ["hpa", "nodes"] },
    { section: 8, title: "Interview", subtitle: "", points: ["How reduce AKS cost?", "Spot nodes risks?"], archNodes: ["nodes", "hpa"] },
  ],

  "dns-coredns": [
    { section: 1, title: "What — CoreDNS", subtitle: "Cluster DNS", points: ["Har Service ko DNS: my-svc.my-ns.svc.cluster.local", "CoreDNS pods kube-system me — usually 2 replicas", "Apps service name use karte hain — IP nahi"], diagram: `backend.production.svc.cluster.local → 10.96.x.x`, archNodes: ["dns", "service", "pods"] },
    { section: 2, title: "Why", subtitle: "", points: ["Pod IP change — DNS stable rehta via Service", "Service delete → DNS fail → connection errors", "Custom domains: Ingress host rules"], archNodes: ["dns", "service"] },
    { section: 7, title: "Failure", subtitle: "", points: ["CoreDNS down → sab internal DNS fail", "Wrong namespace in DNS name", "ndots issue — short name vs FQDN"], archNodes: ["dns"] },
    { section: 8, title: "Interview", subtitle: "", points: ["Service delete hone pe kya hota hai?", "DNS resolution flow inside cluster?"], archNodes: ["dns", "service"] },
  ],

  "service-mesh": [
    { section: 1, title: "What — Service Mesh", subtitle: "Istio/Linkerd", points: ["Sidecar proxy har pod ke saath — traffic intercept", "mTLS automatic between services", "Traffic split: 90% v1, 10% v2 canary", "Observability: latency, errors per service"], archNodes: ["ingress-ctrl", "service", "pods"] },
    { section: 2, title: "Why — Ingress enough nahi?", subtitle: "", points: ["Ingress = cluster entry only", "Mesh = service-to-service inside cluster", "Zero trust internal: mTLS + policy", "Complex microservices (20+ services) me common"], archNodes: ["service", "np"] },
    { section: 4, title: "Prod", subtitle: "", points: ["Start without mesh — add when complexity grows", "Istio heavy, Linkerd lighter", "Platform team usually manages"], archNodes: ["service", "pods"] },
    { section: 8, title: "Interview", subtitle: "", points: ["Ingress vs Service Mesh?", "When NOT to use mesh?"], archNodes: ["ingress-ctrl", "service"] },
  ],

  "security-hardening": [
    { section: 1, title: "What — 2026 Security Stack", subtitle: "", points: ["PSS (Pod Security Standards): restricted/baseline", "OPA Gatekeeper / Kyverno: policy as code", "Image scanning: Trivy in CI — CVE block deploy", "Supply chain: signed images (Cosign), SBOM"], archNodes: ["rbac", "np", "pods"] },
    { section: 4, title: "Prod", subtitle: "", points: ["Namespace: restricted PSS enforce", "Kyverno: no latest tag, require limits", "No privileged pods without approval", "NetworkPolicy default deny everywhere"], archNodes: ["rbac", "np"] },
    { section: 7, title: "Failure", subtitle: "", points: ["Policy blocks valid deploy → tune policies", "Scan false positive → waiver process"], archNodes: ["rbac"] },
    { section: 8, title: "Interview", subtitle: "", points: ["PSS vs PSP?", "How enforce no root containers cluster-wide?"], archNodes: ["rbac", "np"] },
  ],

});
