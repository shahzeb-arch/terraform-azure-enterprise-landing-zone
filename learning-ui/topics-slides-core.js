Object.assign(SLIDES, {
  architecture: [
    {
      title: "Kubernetes Cluster Overview",
      subtitle: "Control Plane + Worker Nodes",
      points: [
        "Cluster = Control Plane (brain) + Nodes (workers)",
        "Control Plane: API Server, etcd, Scheduler, Controller Manager",
        "Node: kubelet, kube-proxy, container runtime (containerd)",
        "Tumhara Kind cluster = 1 node jo dono roles play karta hai",
      ],
      diagram: `┌─────────── CONTROL PLANE ───────────┐
│  API Server  │  etcd  │  Scheduler   │
│         Controller Manager           │
└──────────────────┬───────────────────┘
                   │ kubectl / API calls
┌──────────────────▼───────────────────┐
│           WORKER NODE                │
│  kubelet │ kube-proxy │ Pods        │
└──────────────────────────────────────┘`,
      labFile: null,
      archNodes: ["api-server", "etcd", "scheduler", "kubelet", "pods"],
    },
    {
      title: "Request Flow",
      subtitle: "kubectl apply se pod tak",
      points: [
        "kubectl → API Server (validates + stores in etcd)",
        "Scheduler → decides which Node pe pod jayega",
        "kubelet → pod create karta hai container runtime se",
        "Controller Manager → desired state maintain (replicas, etc.)",
      ],
      diagram: `kubectl apply -f deploy.yaml
        │
        ▼
   API Server ──► etcd (store)
        │
        ▼
   Scheduler ──► picks Node
        │
        ▼
   kubelet ──► pulls image ──► starts container`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["api-server", "scheduler", "kubelet", "pods"],
    },
    {
      title: "Managed vs Self-Managed",
      subtitle: "Prod context",
      points: [
        "Managed K8s (AKS/EKS/GKE): control plane cloud manage karta hai",
        "Tumhe sirf worker nodes + workloads dikhte hain",
        "Namespace-level access = tenant boundary, cluster admin nahi",
        "Kind = local lab, full cluster access for learning",
      ],
      diagram: `MANAGED (Prod)          KIND (Lab)
──────────────          ──────────
Cloud manages CP   →    You own everything
You manage apps         Full RBAC practice
Namespace scope         Break things safely`,
      labFile: "k8s/00-namespace.yaml",
      archNodes: ["api-server", "pods"],
    },
  ],

  namespace: [
    {
      title: "What is Namespace?",
      subtitle: "Virtual cluster inside cluster",
      points: [
        "Logical isolation — resources group karne ke liye",
        "Same cluster me multiple teams/apps alag namespace me",
        "default, kube-system, kube-public — built-in namespaces",
        "Hamara lab: namespace = three-tier",
      ],
      diagram: `Cluster
├── namespace: kube-system  (system pods)
├── namespace: default
└── namespace: three-tier   ← hamara lab
    ├── frontend pods
    ├── backend pods
    └── postgres pod`,
      labFile: "k8s/00-namespace.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Managed Namespace",
      subtitle: "Prod me tumhara scope",
      points: [
        "Company tumhe ek namespace deti hai — sirf usme create/edit",
        "ClusterRole nahi, Role (namespace-scoped) milta hai",
        "Quota + LimitRange namespace pe lag sakta hai",
        "NetworkPolicy se namespace ke andar traffic control",
      ],
      diagram: `Your Access (Prod)
─────────────────────
✅  three-tier namespace
✅  Deploy, Service, Secret
❌  ClusterRole, Nodes, CNI config`,
      labFile: "k8s/00-namespace.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Resource Naming in Namespace",
      subtitle: "DNS + isolation",
      points: [
        "Service DNS: <name>.<namespace>.svc.cluster.local",
        "Same namespace me short name: backend, postgres",
        "Cross-namespace: backend.other-ns.svc.cluster.local",
        "Har YAML me metadata.namespace set karo",
      ],
      diagram: `Same namespace (three-tier):
  backend:5000  →  works ✅

Cross namespace:
  backend.other-ns.svc  →  full DNS`,
      labFile: "k8s/00-namespace.yaml",
      archNodes: ["pods"],
    },
  ],

  workloads: [
    {
      title: "Deployment",
      subtitle: "Stateless apps — frontend & backend",
      points: [
        "Stateless pods — koi bhi pod replace ho sakta hai",
        "ReplicaSet manage karta hai kitne pods chahiye",
        "Rolling update — zero-downtime deploy",
        "Lab: frontend (2 replicas), backend (2 replicas)",
      ],
      diagram: `Deployment "backend" (replicas: 2)
    │
    ├── ReplicaSet
    │     ├── Pod backend-xxx-1
    │     └── Pod backend-xxx-2
    └── RollingUpdate strategy`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods"],
    },
    {
      title: "StatefulSet",
      subtitle: "Stateful apps — database",
      points: [
        "Stable pod name: postgres-0, postgres-1",
        "Stable storage — har pod ka apna PVC",
        "Ordered start/stop — DB cluster ke liye",
        "Lab: postgres StatefulSet with PVC",
      ],
      diagram: `StatefulSet "postgres"
    │
    ├── Pod postgres-0  ──► PVC data-postgres-0
    └── (scale to postgres-1 ──► PVC data-postgres-1)`,
      labFile: "k8s/02-database.yaml",
      archNodes: ["pods"],
    },
    {
      title: "DaemonSet, Job, CronJob",
      subtitle: "Other workload types",
      points: [
        "DaemonSet: har node pe 1 pod (logging agent, CNI)",
        "Job: run once, complete (migration, batch)",
        "CronJob: scheduled Job (backup nightly)",
        "Deployment vs StatefulSet — stateless vs stateful choose karo",
      ],
      diagram: `DaemonSet  → every node gets 1 pod
Job        → runs to completion once
CronJob    → Job on schedule (0 2 * * *)`,
      labFile: null,
      archNodes: ["pods"],
    },
  ],

  services: [
    {
      title: "Service — Stable Endpoint",
      subtitle: "Pod IP mat use karo",
      points: [
        "Pods ki IP change hoti hai — Service stable IP + DNS deta hai",
        "Selector se pods match: app=backend, tier=backend",
        "kube-proxy traffic route karta hai healthy endpoints pe",
        "Lab: backend (ClusterIP), frontend (NodePort)",
      ],
      diagram: `Service "backend" (ClusterIP)
    selector: tier=backend
         │
    ┌────┴────┐
  Pod-1     Pod-2   ← endpoints (dynamic IPs)`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Service Types",
      subtitle: "ClusterIP, NodePort, LoadBalancer",
      points: [
        "ClusterIP: internal only — backend, postgres (default)",
        "NodePort: external via node IP:port — lab frontend :30080",
        "LoadBalancer: cloud LB — prod me common",
        "Headless: direct pod DNS — StatefulSet ke saath",
      ],
      diagram: `ClusterIP   → internal only (backend, db)
NodePort    → :30080 on node (lab frontend)
LoadBalancer→ cloud external IP (prod)
Headless    → postgres-0.postgres (StatefulSet)`,
      labFile: "k8s/04-frontend.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Service in 3-Tier Lab",
      subtitle: "Tumhara actual setup",
      points: [
        "nginx.conf me backend:5000 — ye Service name hai",
        "app.py me postgres:5432 — ye bhi Service name",
        "Pod IP kabhi config me nahi likhte",
        "Readiness fail → pod Service endpoints se hat jata hai",
      ],
      diagram: `nginx → backend:5000 → Service → backend pods
Flask → postgres:5432 → Service → postgres-0`,
      labFile: "apps/frontend/nginx.conf",
      archNodes: ["pods"],
    },
  ],

  ingress: [
    {
      title: "Ingress — HTTP Routing",
      subtitle: "Layer 7 entry point",
      points: [
        "External HTTP/S traffic cluster me lane ke liye",
        "Host/path based routing: app.com/api → backend",
        "Ingress Controller chahiye (nginx, traefik, etc.)",
        "Lab me abhi NodePort use kiya — Ingress next step",
      ],
      diagram: `Internet
    │
    ▼
Ingress Controller (nginx)
    │ host: app.local
    ├── /      → frontend Service
    └── /api   → backend Service`,
      labFile: null,
      archNodes: ["pods"],
    },
    {
      title: "Ingress vs Service vs NodePort",
      subtitle: "Kab kya use karo",
      points: [
        "NodePort: simple, dev/lab — har service ko port",
        "LoadBalancer: cloud pe 1 IP per service (costly)",
        "Ingress: 1 entry, multiple services route — prod preferred",
        "TLS termination Ingress pe hota hai",
      ],
      diagram: `Lab now:     NodePort :30080 → frontend
Prod typical: Ingress → multiple services
              + TLS certificate`,
      labFile: "k8s/04-frontend.yaml",
      archNodes: ["pods"],
    },
  ],

  "config-secret": [
    {
      title: "ConfigMap",
      subtitle: "Non-sensitive config",
      points: [
        "Key-value config — app settings, config files",
        "env var ya volume mount se pod me inject",
        "Change ConfigMap → pod restart chahiye (usually)",
        "Lab: postgres-init ConfigMap — init.sql",
      ],
      diagram: `ConfigMap "postgres-init"
    data:
      init.sql: |
        CREATE TABLE items ...
              │
              ▼ volumeMount
        postgres pod /docker-entrypoint-initdb.d`,
      labFile: "k8s/02-database.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Secret",
      subtitle: "Sensitive data — passwords, tokens",
      points: [
        "base64 encoded storage (not encryption!)",
        "DB creds, API keys, TLS certs",
        "env (secretKeyRef) ya volume se mount",
        "Lab: postgres-secret — DB name, user, password",
      ],
      diagram: `Secret "postgres-secret"
  POSTGRES_USER: appuser
  POSTGRES_PASSWORD: ***

Backend env:
  valueFrom:
    secretKeyRef:
      name: postgres-secret`,
      labFile: "k8s/02-database.yaml",
      archNodes: ["pods"],
    },
    {
      title: "ConfigMap vs Secret — Best Practice",
      subtitle: "Prod rules",
      points: [
        "Password YAML me plain mat likho prod me",
        "External Secrets Operator / Vault / cloud KMS use karo",
        "Secret Git me commit mat karo",
        "Lab me stringData OK for learning",
      ],
      diagram: `Lab:     Secret in YAML (learning)
Prod:    Vault → ExternalSecret → K8s Secret → Pod`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods"],
    },
  ],

  storage: [
    {
      title: "Volumes & VolumeMounts",
      subtitle: "Pod ko storage dena",
      points: [
        "emptyDir: pod ke saath die — cache, temp files",
        "PVC: persistent — DB data survive pod restart",
        "volumeMount: container me path mount karo",
        "Lab: postgres data → PVC, init SQL → ConfigMap volume",
      ],
      diagram: `Pod
├── volume: data (PVC)
│     └── mount: /var/lib/postgresql/data
└── volume: init (ConfigMap)
      └── mount: /docker-entrypoint-initdb.d`,
      labFile: "k8s/02-database.yaml",
      archNodes: ["pods"],
    },
    {
      title: "PV & PVC",
      subtitle: "Persistent storage",
      points: [
        "PVC = pod ka request: 'mujhe 1Gi chahiye'",
        "PV = actual storage (Kind: local-path-provisioner auto banata hai)",
        "StatefulSet + volumeClaimTemplates = har replica ka apna PVC",
        "Lab: data-postgres-0 PVC",
      ],
      diagram: `Pod postgres-0
    │
    ▼ claims
PVC data-postgres-0 (1Gi)
    │
    ▼ bound to
PV (local-path on Kind node)`,
      labFile: "k8s/02-database.yaml",
      archNodes: ["pods"],
    },
  ],

  networkpolicy: [
    {
      title: "NetworkPolicy — Zero Trust",
      subtitle: "Default deny, explicit allow",
      points: [
        "By default sab pods ko sab se baat kar sakte hain — risky",
        "NetworkPolicy L3/L4 firewall rules pods pe",
        "CNI support chahiye — Calico, Cilium (Kind default: kindnet)",
        "Lab: default-deny-all pehle, phir allow rules",
      ],
      diagram: `Without NP:  any pod → any pod ❌ open

With NP:
  default-deny-all
  + allow frontend → backend:5000
  + allow backend → postgres:5432`,
      labFile: "k8s/05-network-policies.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Lab NetworkPolicy Rules",
      subtitle: "Tumhara 3-tier traffic",
      points: [
        "allow-dns-egress: sab pods DNS resolve kar saken",
        "frontend ingress: port 80 (browser/NodePort)",
        "frontend egress: sirf backend:5000",
        "backend ingress: sirf frontend tier se",
        "database ingress: sirf backend tier se",
      ],
      diagram: `Browser → frontend:80 ✅
frontend → backend:5000 ✅
backend → postgres:5432 ✅
frontend → postgres:5432 ❌ BLOCKED`,
      labFile: "k8s/05-network-policies.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Calico vs Cilium",
      subtitle: "CNI comparison (architect view)",
      points: [
        "CNI = pod networking + NetworkPolicy enforce karta hai",
        "Calico: mature, BGP, widely used",
        "Cilium: eBPF-based, observability, service mesh features",
        "Azure CNI / ACNS — cloud managed variants",
      ],
      diagram: `Pod traffic
    │
    ▼
CNI (Calico / Cilium / kindnet)
    │
    ▼
NetworkPolicy rules applied`,
      labFile: "k8s/05-network-policies.yaml",
      archNodes: ["pods"],
    },
  ],

  rbac: [
    {
      title: "RBAC Overview",
      subtitle: "Who can do what",
      points: [
        "Role = permissions list (verbs + resources)",
        "RoleBinding = user/SA ko Role se bind",
        "ClusterRole + ClusterRoleBinding = cluster-wide",
        "Lab: namespace-scoped Role + RoleBinding",
      ],
      diagram: `Subject (User / ServiceAccount)
        │
        ▼ RoleBinding
      Role (permissions)
        │
        ▼ allows
   get/list secrets in namespace`,
      labFile: "k8s/01-rbac.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Role vs ClusterRole",
      subtitle: "Scope matters",
      points: [
        "Role: ek namespace ke andar — tumhara prod scope",
        "ClusterRole: poore cluster — nodes, CRDs, all namespaces",
        "RoleBinding → Role (namespace scoped)",
        "ClusterRoleBinding → ClusterRole (admin)",
      ],
      diagram: `Namespace scope (you in prod):
  Role + RoleBinding

Cluster scope (platform team):
  ClusterRole + ClusterRoleBinding`,
      labFile: "k8s/01-rbac.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Authorization Check",
      subtitle: "Test karo kaun kya kar sakta hai",
      points: [
        "kubectl auth can-i create deployments -n three-tier",
        "kubectl auth can-i get secrets --as=system:serviceaccount:three-tier:backend-sa",
        "frontend-sa: secrets ❌ | backend-sa: postgres-secret ✅",
        "Least privilege — minimum permission do",
      ],
      diagram: `kubectl auth can-i get secrets \\
  --as=system:serviceaccount:three-tier:frontend-sa
→ no

backend-sa → yes (postgres-secret only)`,
      labFile: "k8s/01-rbac.yaml",
      archNodes: ["pods"],
    },
  ],

  serviceaccount: [
    {
      title: "Service Account",
      subtitle: "Pod ki identity",
      points: [
        "Har pod ek identity se run hota hai — ServiceAccount",
        "Default SA hota hai — custom SA best practice",
        "SA token → API server se baat (in-cluster apps)",
        "Lab: frontend-sa, backend-sa, database-sa",
      ],
      diagram: `Pod spec:
  serviceAccountName: backend-sa
        │
        ▼
Token mounted at
/var/run/secrets/kubernetes.io/serviceaccount/`,
      labFile: "k8s/01-rbac.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Workload Identity",
      subtitle: "Cloud identity for pods",
      points: [
        "K8s SA → cloud IAM role map (AWS IRSA, Azure WI, GCP WI)",
        "App ko cloud secrets/DB access without static keys",
        "Annotation on SA: which cloud identity to assume",
        "Prod me static cloud keys avoid karo",
      ],
      diagram: `Pod (backend-sa)
    │
    ▼ federated token
Cloud IAM Role
    │
    ▼ access
S3 / Azure Key Vault / RDS`,
      labFile: null,
      archNodes: ["pods"],
    },
  ],

  "probes-pdb": [
    {
      title: "Liveness & Readiness Probes",
      subtitle: "Pod health checks",
      points: [
        "Liveness: app alive hai? Fail → restart pod",
        "Readiness: traffic ke liye ready? Fail → Service se remove",
        "Startup: slow apps ke liye — liveness se pehle wait",
        "Lab: backend /health (liveness), /ready (DB check)",
      ],
      diagram: `liveness  → /health  → fail → kubelet RESTARTS pod
readiness → /ready   → fail → removed from Service endpoints
startup   → /ready   → 30 retries before liveness kicks in`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods"],
    },
    {
      title: "PodDisruptionBudget",
      subtitle: "Safe maintenance",
      points: [
        "Voluntary disruption: drain node, upgrade",
        "PDB: minimum kitne pods up rehne chahiye",
        "Lab: minAvailable: 1 for frontend & backend",
        "Without PDB: sab pods ek saath down ho sakte hain",
      ],
      diagram: `PDB backend-pdb
  minAvailable: 1
  selector: tier=backend

Node drain → only 1 backend down at a time`,
      labFile: "k8s/06-pdb.yaml",
      archNodes: ["pods"],
    },
  ],

  "three-tier": [
    {
      title: "3-Tier Architecture",
      subtitle: "Tumhara complete lab",
      points: [
        "Tier 1: Frontend — nginx (static UI + reverse proxy)",
        "Tier 2: Backend — Flask API (business logic)",
        "Tier 3: Database — PostgreSQL (persistent data)",
        "Har tier alag Deployment/StatefulSet + Service + SA",
      ],
      diagram: `Browser
   │
   ▼
┌──────────┐    ┌──────────┐    ┌──────────┐
│ Frontend │───▶│ Backend  │───▶│ Postgres │
│  nginx   │    │  Flask   │    │ Stateful │
│  :80     │    │  :5000   │    │  :5432   │
└──────────┘    └──────────┘    └──────────┘`,
      labFile: "README.md",
      archNodes: ["pods"],
    },
    {
      title: "Frontend → Backend Connection",
      subtitle: "nginx reverse proxy",
      points: [
        "nginx.conf: location /api/ → proxy_pass http://backend:5000",
        "backend = Service name, not pod IP",
        "Browser sirf frontend se baat karta hai",
        "Reverse proxy = nginx client ki taraf se backend ko call",
      ],
      diagram: `Browser GET /api/items
    │
    ▼ nginx (frontend pod)
proxy_pass http://backend:5000/api/items
    │
    ▼ Service "backend"
backend pod Flask handler`,
      labFile: "apps/frontend/nginx.conf",
      archNodes: ["pods"],
    },
    {
      title: "Backend → Database Connection",
      subtitle: "Env vars + Secret",
      points: [
        "DB_HOST=postgres (Service name)",
        "DB creds Secret postgres-secret se inject",
        "app.py psycopg2 se connect karta hai",
        "Dono side same Secret — mismatch = connection fail",
      ],
      diagram: `Backend env:
  DB_HOST=postgres
  DB_PASSWORD ← secretKeyRef postgres-secret

postgres pod:
  envFrom: secretRef postgres-secret`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Deploy the Lab",
      subtitle: "Scripts summary",
      points: [
        "build-and-load.ps1 → Docker images build + Kind load",
        "deploy.ps1 → YAML apply (DB first, then app)",
        "setup-lab.ps1 → dono ek saath",
        "Access: kubectl port-forward svc/frontend 8080:80 -n three-tier",
      ],
      diagram: `.\scripts\setup-lab.ps1
    │
    ├── build images
    ├── kind load
    └── kubectl apply (staged)

http://localhost:8080`,
      labFile: "scripts/setup-lab.ps1",
      archNodes: ["pods"],
    },
    {
      title: "Break It Exercises",
      subtitle: "Architect thinking",
      points: [
        "NetworkPolicy block karo → API fail — egress matter karta hai",
        "postgres scale 0 → backend readiness fail",
        "kill backend pod → liveness restart",
        "auth can-i → RBAC verify karo",
      ],
      diagram: `Exercise 1: comment NP egress → refresh browser → fail
Exercise 2: scale postgres --replicas=0
Exercise 3: kubectl delete pod -l tier=backend`,
      labFile: "k8s/05-network-policies.yaml",
      archNodes: ["pods"],
    },
  ],
});
