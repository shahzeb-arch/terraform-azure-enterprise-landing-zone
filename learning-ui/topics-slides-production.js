Object.assign(SLIDES, {

  "pod-replicaset-prod": [
    {
      title: "Pod — Industry Definition",
      subtitle: "Sabse chhota runnable unit",
      points: [
        "Pod = 1 ya zyada containers jo saath me run hote hain (usually 1 app container)",
        "Problem bina K8s: server pe manually docker run — restart, scale, health = tumhara headache",
        "Pod ki IP temporary hai — crash/restart pe change — isliye direct Pod IP use nahi karte",
        "Industry me Pod directly create nahi karte — Deployment/StatefulSet se banate hain",
        "Rule: 1 pod = 1 main process ideally (sidecar exception: logging, proxy)",
      ],
      diagram: `Internet user
      ❌ directly Pod IP (bad — IP changes)

Pod = { container(s), IP, volumes, labels }
      ↑
Deployment/StatefulSet creates & manages Pods`,
      prodTip: "Interview line: Pod is ephemeral — treat as cattle, not pets.",
      archNodes: ["pods"],
    },
    {
      title: "ReplicaSet — Kyun Chahiye?",
      subtitle: "Pod count maintain karna",
      points: [
        "Problem: 3 copies chahiye — ek pod die → manually naya pod? Prod me impossible.",
        "ReplicaSet ensures: desired replicas hamesha running (self-healing)",
        "Selector + labels se match: app=web, tier=frontend",
        "Tum kabhi RS YAML apply nahi karte — Deployment automatically RS banata hai",
        "Industry: RS = internal layer; tum Deployment se kaam karte ho",
      ],
      diagram: `ReplicaSet (replicas: 3)
   selector: app=web
        │
   ┌────┼────┐
 Pod1 Pod2 Pod3

Pod2 dies → RS creates Pod2-new automatically`,
      archNodes: ["pods"],
    },
    {
      title: "Kab Kya Use Karo — Quick Table",
      subtitle: "Architect decision",
      points: [
        "Deployment → stateless app (API, web, worker) — 90% cases",
        "StatefulSet → database, queue with disk + stable name (postgres-0)",
        "DaemonSet → har node pe 1 pod (log agent, monitoring, CNI)",
        "Job → ek baar chal ke khatam (migration, report)",
        "CronJob → schedule pe Job (nightly backup)",
      ],
      diagram: `STATELESS web API     → Deployment
DATABASE postgres     → StatefulSet
LOG agent every node  → DaemonSet
ONE-TIME data import  → Job`,
      prodTip: "Galat choice = prod pain. DB ko Deployment me mat daalo — data loss.",
      archNodes: ["pods"],
    },
  ],

  "deployment-yaml-deep": [
    {
      title: "Deployment YAML — Top Level",
      subtitle: "apiVersion se template tak",
      points: [
        "apiVersion + kind → Kubernetes ko batata hai ye kya resource hai",
        "metadata → name, namespace, labels (organize + select ke liye)",
        "spec → desired state (kitne replicas, kaise update, pod kaise dikhega)",
        "spec.template → Pod blueprint — yahan actual container config",
        "Industry: har env (dev/prod) me same structure, values alag (Helm/GitOps)",
      ],
      diagram: `apiVersion: apps/v1          # API group version
kind: Deployment               # resource type
metadata:
  name: web-app                # deployment name
  namespace: production        # kis namespace me
  labels:
    app: web-app               # own labels
spec:                          # DESIRED STATE starts
  replicas: 3                  # kitne pods chahiye
  revisionHistoryLimit: 5      # rollback history kitni rakhe
  selector:                    # kaunse pods iske hain
    matchLabels:
      app: web-app
  strategy: ...                # rollout kaise ho (next slide)
  template: ...                # pod blueprint (next slides)`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Rollout Strategy — surge & unavailable",
      subtitle: "Zero-downtime deploy",
      points: [
        "Problem: sab pods ek saath kill → users ko 502 error",
        "RollingUpdate: naye pods up → phir purane down (default, prod me common)",
        "maxSurge: rollout me EXTRA kitne pods (25% = 1 extra agar 4 replicas)",
        "maxUnavailable: rollout me MAX kitne pods down ho sakte (0 = no downtime)",
        "Recreate: pehle sab kill, phir naye — sirf dev / stateful migration jab chahiye",
      ],
      diagram: `strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1          # temp extra pod during deploy
    maxUnavailable: 0    # prod best: zero unavailable

# 3 replicas deploy:
# Step1: 4 pods (3 old + 1 new)
# Step2: swap until all new`,
      prodTip: "Prod golden: maxUnavailable: 0, maxSurge: 1 or 25%.",
      archNodes: ["pods"],
    },
    {
      title: "Pod Template — Container Basics",
      subtitle: "spec.template.spec",
      points: [
        "template.metadata.labels → MUST match spec.selector (warna deploy fail)",
        "containers[].image → Docker image:tag (prod me digest ya semver, latest mat)",
        "imagePullPolicy: IfNotPresent / Always — private registry pe Always common",
        "imagePullSecrets → private ACR/ECR se pull ke liye credentials",
        "ports → containerPort = app listen port (documentation + probes ke liye)",
      ],
      diagram: `template:
  metadata:
    labels:
      app: web-app           # must match selector
  spec:
    serviceAccountName: web-sa # pod identity (RBAC/cloud)
    imagePullSecrets:
      - name: acr-secret      # private registry auth
    containers:
      - name: web
        image: myacr.io/web:1.2.3
        imagePullPolicy: Always
        ports:
          - containerPort: 8080
            name: http`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Resources — requests & limits",
      subtitle: "OOM aur scheduling",
      points: [
        "Problem bina limits: 1 pod poora node memory kha jaye → sab crash",
        "requests → scheduler decide karta hai kis node pe fit hoga (minimum guarantee)",
        "limits → max CPU/memory — cross memory limit = OOMKilled",
        "Industry: hamesha set karo — prod cluster me mandatory hota hai",
        "CPU: 500m = half core | Memory: 512Mi = mebibytes",
      ],
      diagram: `resources:
  requests:              # scheduling ke liye
    cpu: 100m
    memory: 128Mi
  limits:                # hard cap
    cpu: 500m
    memory: 512Mi

# requests ≤ limits always
# missing limits = noisy neighbor problem`,
      prodTip: "Start small, monitor with kubectl top pod, then tune.",
      archNodes: ["pods"],
    },
    {
      title: "Probes — liveness, readiness, startup",
      subtitle: "Kubelet ko health kaise bataye",
      points: [
        "livenessProbe → app dead? → kubelet RESTART pod (hang/crash detect)",
        "readinessProbe → traffic ke liye ready? → fail = Service se hata do",
        "startupProbe → slow start apps — liveness se pehle wait (Java, DB clients)",
        "httpGet / exec / tcpSocket — HTTP sabse common web apps me",
        "failureThreshold × periodSeconds = kitna wait before action",
      ],
      diagram: `livenessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 10
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /ready
    port: http
  periodSeconds: 5

startupProbe:            # optional slow apps
  httpGet:
    path: /health
    port: http
  failureThreshold: 30
  periodSeconds: 5`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Scheduling — nodeSelector & affinity",
      subtitle: "Pod kis node pe jayega",
      points: [
        "nodeSelector → simple: node label match karo (disktype=ssd)",
        "nodeAffinity → advanced rules (required/preferred, operators)",
        "podAffinity → is pod ke PAAS dusre pods (same zone, same node)",
        "podAntiAffinity → pods ALAG nodes pe (HA — 2 replicas same node pe na ho)",
        "Industry: anti-affinity for HA; GPU nodes pe nodeSelector for ML workloads",
      ],
      diagram: `# Simple — sirf SSD nodes
nodeSelector:
  disktype: ssd

# HA — replicas alag nodes
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchLabels:
            app: web-app
        topologyKey: kubernetes.io/hostname`,
      prodTip: "zone spread + pod anti-affinity = multi-AZ HA pattern.",
      archNodes: ["pods"],
    },
    {
      title: "Security — Pod & Container Level",
      subtitle: "Prod hardening",
      points: [
        "spec.securityContext (pod level) → fsGroup, runAsUser, seccomp",
        "containers[].securityContext → runAsNonRoot, readOnlyRootFilesystem, drop capabilities",
        "allowPrivilegeEscalation: false → privilege escalation block",
        "Pod Security Standards: baseline / restricted — namespace pe enforce",
        "Industry: restricted policy mandatory many enterprises me",
      ],
      diagram: `spec:
  securityContext:
    runAsNonRoot: true
    fsGroup: 2000
  containers:
    - name: web
      securityContext:
        allowPrivilegeEscalation: false
        readOnlyRootFilesystem: true
        capabilities:
          drop: ["ALL"]
        runAsUser: 1000`,
      prodTip: "Root container = security audit fail. Always non-root.",
      archNodes: ["pods", "rbac"],
    },
    {
      title: "Full Deployment — Commented (Reference)",
      subtitle: "Sab pieces ek saath",
      points: [
        "Neeche production-style ek piece — har section samjho, copy-paste blind mat karo",
        "Tumhare lab me simpler version hai — ye industry target template hai",
        "Helm/GitOps me ye template values se fill hota hai",
        "Change karte waqt: selector=labels, probes match app paths, resources tune karo",
      ],
      labFile: "k8s/examples/deployment-production.yaml",
      archNodes: ["pods"],
    },
  ],

  "statefulset-daemonset-prod": [
    {
      title: "StatefulSet — Kyun?",
      subtitle: "Stable identity + storage",
      points: [
        "Problem: Deployment se postgres — pod name random, disk share nahi, order mess",
        "StatefulSet gives: stable name postgres-0, postgres-1 + own PVC each",
        "Ordered deploy: 0 pehle, phir 1 — DB cluster bootstrap ke liye",
        "Headless Service chahiye: postgres-0.postgres.ns.svc",
        "Industry: PostgreSQL, Kafka, Elasticsearch, Redis cluster",
      ],
      diagram: `StatefulSet postgres
  ├── postgres-0  → PVC-0
  └── postgres-1  → PVC-1

Service (headless) → direct pod DNS`,
      labFile: "k8s/02-database.yaml",
      archNodes: ["postgres", "pods"],
    },
    {
      title: "DaemonSet — Kyun?",
      subtitle: "Har node pe exactly 1",
      points: [
        "Problem: har server pe log agent chahiye — manually install? 100 nodes?",
        "DaemonSet: cluster me har node pe 1 pod auto (new node = auto pod)",
        "Use: Fluent Bit logs, Datadog agent, Calico/Cilium node, node-exporter",
        "tolerations: tainted nodes pe bhi chale (often required)",
        "Industry: observability + CNI — platform team manage karti hai",
      ],
      diagram: `Node-A → daemonset-pod
Node-B → daemonset-pod
Node-C → daemonset-pod

New Node-D added → pod auto scheduled`,
      archNodes: ["pods"],
    },
  ],

  "service-yaml-deep": [
    {
      title: "Service — Kyun Industry Me?",
      subtitle: "Stable endpoint problem solve",
      points: [
        "Problem: 3 backend pods — IPs change on restart — frontend kaise connect?",
        "Service = stable ClusterIP + DNS name (backend.prod.svc)",
        "kube-proxy routes traffic healthy endpoints pe (readiness pass wale)",
        "selector must match pod labels — mismatch = empty endpoints = timeout",
        "Types: ClusterIP (internal), NodePort (dev), LoadBalancer (cloud LB)",
      ],
      diagram: `Service backend (ClusterIP)
  selector: app=backend
       │
   endpoints: 10.1.1.5, 10.1.1.8  (auto updated)

DNS: backend.namespace.svc.cluster.local`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods"],
    },
    {
      title: "Service YAML — Line by Line",
      subtitle: "Har field ka matlab",
      points: [
        "type: ClusterIP → sirf cluster ke andar (default)",
        "type: NodePort → har node pe static port (30000-32767) — lab/dev",
        "type: LoadBalancer → cloud creates external LB (AKS Azure LB)",
        "ports.port → Service port | targetPort → container port",
        "sessionAffinity: ClientIP → same client same pod (sticky sessions)",
      ],
      diagram: `apiVersion: v1
kind: Service
metadata:
  name: backend              # DNS name
  namespace: production
spec:
  type: ClusterIP            # internal only
  selector:
    app: backend             # must match pod labels
    tier: api
  ports:
    - name: http               # named port (probes reference)
      port: 80                 # service port
      targetPort: 8080         # container port
      protocol: TCP
  sessionAffinity: None      # or ClientIP for sticky`,
      labFile: "k8s/04-frontend.yaml",
      archNodes: ["pods"],
    },
  ],

  "ingress-yaml-deep": [
    {
      title: "Ingress — Kyun?",
      subtitle: "Ek entry, multiple apps",
      points: [
        "Problem: har app ke liye alag LoadBalancer = costly + SSL headache",
        "Ingress = HTTP/S routing rules — host/path based",
        "Ingress Controller required (nginx, traefik, AGIC for Azure)",
        "TLS termination Ingress pe — cert-manager se auto renew",
        "Industry: prod me public apps almost always Ingress or cloud gateway",
      ],
      diagram: `https://myapp.com/api  → backend Service
https://myapp.com/     → frontend Service

1 external IP / Front Door
multiple paths inside`,
      archNodes: ["ingress-ctrl", "pods"],
    },
    {
      title: "Ingress YAML — Explained",
      subtitle: "Production pattern",
      labFile: "k8s/examples/ingress-production.yaml",
      points: [
        "ingressClassName → kaunsa controller handle kare (nginx, azure-application-gateway)",
        "rules.host → domain name (app.company.com)",
        "rules.http.paths → path routing (/api → backend:5000)",
        "tls → secret with cert + key (or cert-manager annotation)",
        "annotations → controller specific (SSL redirect, body size, rate limit)",
      ],
      diagram: `apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
spec:
  ingressClassName: nginx
  tls:
    - hosts: [app.company.com]
      secretName: app-tls
  rules:
    - host: app.company.com
      http:
        paths:
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: backend
                port:
                  number: 5000
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend
                port:
                  number: 80`,
      archNodes: ["ingress-ctrl"],
    },
  ],

  "frontdoor-waf": [
    {
      title: "Front Door + WAF — K8s Ke Bahar",
      subtitle: "Cloud layer — industry standard",
      points: [
        "K8s Ingress cluster ke ANDAR entry hai — internet se pehle often Azure Front Door",
        "Front Door = global CDN + load balance + SSL at edge (fast, DDoS resilient)",
        "WAF (Web Application Firewall) = SQL injection, XSS block — OWASP rules",
        "Flow: User → Front Door (WAF) → App Gateway / LB → Ingress → Service → Pod",
        "Industry: public websites almost always edge WAF mandatory (compliance)",
      ],
      diagram: `Internet
    │
    ▼
Azure Front Door + WAF    ← DDoS, geo, SSL, cache
    │
    ▼
Application Gateway / LB  ← into VNet
    │
    ▼
K8s Ingress → Services → Pods`,
      prodTip: "Architect: security layers — WAF at edge, NetworkPolicy inside cluster.",
      archNodes: ["ingress-ctrl"],
    },
    {
      title: "Kyun Front Door + K8s Dono?",
      subtitle: "Trade-off",
      points: [
        "Sirf Ingress: OK internal apps / simple setups",
        "Front Door + K8s: global users, CDN, enterprise WAF, multi-region",
        "Front Door origin = Ingress public IP ya App Gateway backend pool",
        "SSL: Front Door pe terminate ya end-to-end encrypt",
        "Tumhare namespace app — platform team edge setup karti hai often",
      ],
      diagram: `Small app / internal  → Ingress only
Public global website   → Front Door + WAF + Ingress
Enterprise compliance   → WAF mandatory at edge`,
      archNodes: ["ingress-ctrl"],
    },
  ],

  "website-live-e2e": [
    {
      title: "Live Website — Big Picture",
      subtitle: "Internet se pod tak — poori kahani",
      points: [
        "Goal: user browser se tumhari website open ho — secure, fast, HA",
        "10 layers — har layer ka reason alag slide me detail",
        "Ye flow interview me draw karna — architect skill",
        "Tumhara 3-tier lab = middle layers (Service → Pod); edge add hota hai prod me",
      ],
      flowSteps: [
        "① User types https://myapp.com",
        "② DNS → Front Door / LB public IP",
        "③ WAF checks request (block attacks)",
        "④ Traffic → Application Gateway / Load Balancer",
        "⑤ Ingress Controller routes / and /api",
        "⑥ Service → healthy pod endpoints",
        "⑦ Pod: nginx frontend → proxy → Flask backend",
        "⑧ Backend → postgres Service → StatefulSet pod",
        "⑨ NetworkPolicy allows only required paths",
        "⑩ Monitoring alerts if any layer fails",
      ],
      diagram: `User → DNS → Front Door/WAF → LB → Ingress
  → frontend Svc → frontend Pod
  → backend Svc → backend Pod → postgres Svc → DB Pod`,
      archNodes: ["ingress-ctrl", "frontend", "backend", "postgres"],
    },
    {
      title: "Layer 1–3: DNS, Edge, WAF",
      subtitle: "Public internet side",
      points: [
        "DNS A/CNAME record → Front Door endpoint point karta hai",
        "Front Door: caching static files, geo routing (India users → nearest POP)",
        "WAF rules: block bad IPs, rate limit, OWASP top 10",
        "Problem without WAF: SQL injection se DB leak real incidents me common",
        "SSL certificate: auto renew cert-manager / Front Door managed cert",
      ],
      archNodes: ["ingress-ctrl"],
    },
    {
      title: "Layer 4–6: LB, Ingress, Service",
      subtitle: "Into the cluster",
      points: [
        "Load Balancer health probe → only healthy nodes get traffic",
        "Ingress: path / → frontend, /api → backend (1 domain, 2 services)",
        "Service endpoints = only readiness-passing pods",
        "Rolling update: maxUnavailable 0 → users ko pata bhi nahi chalta",
        "HPA: CPU high → more pods → Service auto includes new endpoints",
      ],
      labFile: "k8s/04-frontend.yaml",
      archNodes: ["ingress-ctrl", "pods"],
    },
    {
      title: "Layer 7–10: Pods, Data, Security, Ops",
      subtitle: "App + run",
      points: [
        "Deployment: frontend/backend replicas across nodes (anti-affinity)",
        "StatefulSet: database with PVC — data survives pod restart",
        "Secrets: DB password from Key Vault — not in Git",
        "NetworkPolicy: frontend→backend only, backend→db only",
        "Prometheus alerts + runbooks: 5xx spike, pod crash, cert expiry",
      ],
      labFile: "k8s/05-network-policies.yaml",
      archNodes: ["frontend", "backend", "postgres", "np", "keyvault"],
    },
    {
      title: "Deploy Order — Industry Practice",
      subtitle: "Kya pehle apply karo",
      flowSteps: [
        "① Namespace + RBAC + NetworkPolicy default deny",
        "② Secrets / Key Vault CSI setup",
        "③ StorageClass + database StatefulSet + wait ready",
        "④ Backend Deployment + Service + wait ready",
        "⑤ Frontend Deployment + Service",
        "⑥ Ingress + TLS certificate",
        "⑦ Front Door origin point to Ingress IP (platform team)",
        "⑧ Smoke test + monitoring dashboards + alerts",
      ],
      diagram: `Order matters:
DB first → backend (needs DB) → frontend → ingress
(Same as your lab deploy.ps1 staged deploy!)`,
      labFile: "scripts/deploy.ps1",
      archNodes: ["argocd", "postgres", "frontend"],
    },
  ],

});
