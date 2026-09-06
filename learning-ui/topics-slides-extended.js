Object.assign(SLIDES, {

  "cluster-design": [
    {
      title: "Private Cluster — Kya hai?",
      subtitle: "Architect starting point",
      points: [
        "Private cluster = API server internet pe expose nahi — VPN/peering se access",
        "AKS: private cluster + authorized IP ranges + private DNS zone",
        "Nodes worker subnet me — control plane cloud manage (managed K8s)",
        "Goal: attack surface kam, compliance (PCI/HIPAA) meet karo",
      ],
      diagram: `Internet ──X──► API Server (private)
                      │
VPN / ExpressRoute ──┘
                      │
                 kubectl / CI/CD`,
      prodTip: "Prod me public API + private nodes ya fully private — company policy decide karti hai.",
      archNodes: ["api-server"],
    },
    {
      title: "Landing Zone Components",
      subtitle: "Design checklist",
      points: [
        "Resource Group, VNet, subnets (nodes, pods, services, ingress)",
        "Separate node pools: system vs user workloads vs GPU",
        "Container Registry (ACR/ECR) — image pull identity",
        "Monitoring, logging, backup namespace plan karo upfront",
      ],
      flowSteps: [
        "VNet + subnets design (CIDR planning pehle)",
        "Private AKS cluster create",
        "Node pool(s) — size, autoscale min/max",
        "ACR link + pull secrets / managed identity",
        "Ingress controller + cert-manager install",
        "ArgoCD / Flux bootstrap",
        "NetworkPolicy default deny apply",
        "Namespace per team + RBAC bind",
      ],
      archNodes: ["api-server", "cni", "ingress-ctrl"],
    },
  ],

  "cidr-planning": [
    {
      title: "CIDR Basics",
      subtitle: "IP planning — sabse pehle ye",
      points: [
        "Node subnet: VM/node IPs ke liye",
        "Pod CIDR: har pod ko unique IP (overlay ya real pod networking)",
        "Service CIDR: ClusterIP range — virtual, pods nahi",
        "Teeno overlap nahi hone chahiye — aur corporate VNet se bhi nahi",
      ],
      diagram: `Example AKS planning:
  VNet:           10.0.0.0/16
  Node subnet:    10.0.1.0/24
  Pod CIDR:       10.244.0.0/16
  Service CIDR:   10.96.0.0/16`,
      prodTip: "Chhota CIDR = future scale problem. Architect pehle day se buffer rakho.",
      archNodes: ["cni"],
    },
    {
      title: "Planning Rules",
      subtitle: "Architect decisions",
      points: [
        "Max pods per node × max nodes = pod CIDR size calculate karo",
        "Azure CNI: pods ko real VNet IP — subnet size bada chahiye",
        "Kubenet/overlay: pod CIDR alag — chhota node subnet OK",
        "Peering/VPN subnets se conflict check — spreadsheet me map karo",
      ],
      diagram: `Azure CNI (real IP):     Overlay (kubenet):
pods = VNet IPs            pods = overlay CIDR
subnet bada chahiye        node subnet chhota OK
ACNS advanced policies     simpler IP management`,
      archNodes: ["cni"],
    },
  ],

  "cni-deep": [
    {
      title: "CNI — Kya karta hai?",
      subtitle: "Container Network Interface",
      points: [
        "Har pod ko IP deta hai — network namespace setup",
        "NetworkPolicy enforce karta hai (CNI dependent)",
        "Service routing kube-proxy + CNI milkar karte hain",
        "Kind default: kindnet — basic, lab ke liye OK",
      ],
      diagram: `Pod created
    │
    ▼
CNI plugin (Calico/Cilium/Azure CNI)
    │
    ├── assign pod IP
    └── apply network policy rules`,
      archNodes: ["cni", "np"],
    },
    {
      title: "Calico vs Cilium vs Azure CNI",
      subtitle: "Kab kya choose karo",
      points: [
        "Calico: mature, BGP, on-prem + cloud, standard policies",
        "Cilium: eBPF, Hubble observability, advanced L7 policies",
        "Azure CNI: pods get Azure VNet IP — corporate network integration",
        "ACNS: Azure CNI + advanced networking (overlay, policies)",
      ],
      diagram: `Decision tree:
Need Azure VNet IP?  → Azure CNI / ACNS
Need eBPF observability? → Cilium
General multi-cloud? → Calico`,
      prodTip: "Tumhare project me jo CNI hai — uski policy syntax aur limits samjho.",
      archNodes: ["cni"],
    },
  ],

  "storage-flow": [
    {
      title: "Storage End-to-End",
      subtitle: "Start se mount tak — fresher friendly",
      points: [
        "StorageClass = template ('kaunsa storage type, kaunsa provisioner')",
        "PVC = request ('mujhe 10Gi ReadWriteOnce chahiye')",
        "Provisioner automatically PV banata hai aur bind karta hai",
        "Pod me volumeMount — app ko path dikhta hai",
      ],
      flowSteps: [
        "① Admin: StorageClass create (e.g. managed-csi, azuredisk)",
        "② Developer: PVC YAML apply — size + accessMode",
        "③ CSI provisioner: Azure Disk / File create karta hai",
        "④ PV auto bind hota hai PVC se",
        "⑤ Pod spec: volumes.persistentVolumeClaim.claimName",
        "⑥ container volumeMounts: mountPath (/data)",
        "⑦ App likhta hai /data pe — pod restart pe data safe",
      ],
      diagram: `StorageClass → PVC → PV (Azure Disk)
                    │
                    ▼
              Pod volumeMount
              /var/lib/postgresql/data`,
      labFile: "k8s/02-database.yaml",
      archNodes: ["csi", "postgres"],
    },
    {
      title: "Azure Disk vs File vs Blob",
      subtitle: "Kab kya use karo",
      points: [
        "Azure Disk: single pod RWO — database, single instance app",
        "Azure Files: RWX — multiple pods same share (shared config)",
        "Blob Fuse / CSI: large object, backup, read-heavy",
        "StatefulSet + volumeClaimTemplates = DB ka standard pattern",
      ],
      diagram: `Database (postgres)  → Azure Disk (RWO)
Shared uploads       → Azure Files (RWX)
Logs archive         → Blob`,
      prodTip: "Disk zone match karo node zone se — warna pod schedule fail.",
      archNodes: ["csi"],
    },
  ],

  "workload-identity": [
    {
      title: "Workload Identity — Kyun?",
      subtitle: "Static secrets hatana",
      points: [
        "Pehle: cloud credentials Secret me — rotate karna mushkil, leak risk",
        "Ab: Pod apni K8s SA se Azure Managed Identity assume karta hai",
        "No password in YAML — short-lived token automatically",
        "AKS me 'Workload Identity' feature enable karna padta hai",
      ],
      diagram: `OLD: Secret → env AZURE_CLIENT_SECRET  ❌
NEW: SA annotation → Managed Identity token  ✅`,
      archNodes: ["mi", "rbac"],
    },
    {
      title: "Azure WI Setup Steps",
      subtitle: "SA → Managed Identity link",
      flowSteps: [
        "① AKS pe Workload Identity + OIDC issuer enable",
        "② Azure: User-Assigned Managed Identity (UAMI) banao",
        "③ Federated credential: issuer + SA namespace/name bind",
        "④ K8s ServiceAccount annotate: azure.workload.identity/client-id: <UAMI-id>",
        "⑤ Pod label: azure.workload.identity/use: 'true'",
        "⑥ Azure resource (Key Vault/Storage) pe UAMI ko RBAC role do",
        "⑦ App SDK DefaultAzureCredential use — auto token",
      ],
      diagram: `K8s SA (backend-sa)
    │ federated token
    ▼
Managed Identity
    │ RBAC
    ▼
Key Vault / Storage / SQL`,
      archNodes: ["mi", "keyvault"],
    },
  ],

  "keyvault-flow": [
    {
      title: "Key Vault Integration — Overview",
      subtitle: "Secrets Git me nahi — Vault me",
      labFile: "k8s/examples/secretproviderclass-example.yaml",
      points: [
        "Azure Key Vault = central secret store (password, cert, connection string)",
        "Pod ko direct Vault access nahi — CSI driver ya External Secrets",
        "Managed Identity se authenticate — no static creds",
        "SecretProviderClass = 'kaunsa secret, kahan se, kahan mount'",
      ],
      diagram: `Key Vault (prod secrets)
        │
        ▼ CSI / External Secrets
K8s Secret (synced)
        │
        ▼ env / volumeMount
App Pod`,
      archNodes: ["keyvault", "mi"],
    },
    {
      title: "SecretProviderClass — Full Flow",
      subtitle: "YAML se pod tak — step by step",
      flowSteps: [
        "① Key Vault me secret create (db-password, api-key)",
        "② UAMI ko Key Vault Secrets User role do",
        "③ K8s SA + Workload Identity federated credential setup",
        "④ SecretProviderClass YAML: provider azure, keyvaultName, tenantId, objects",
        "⑤ Pod spec: volumes.csi.driver = secrets-store.csi.k8s.io",
        "⑥ volumeAttributes.secretProviderClass = <name>",
        "⑦ optional: secretObjects — K8s Secret auto sync",
        "⑧ volumeMount path — app read karta hai files/env se",
      ],
      diagram: `apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: kv-app-secrets
spec:
  provider: azure
  parameters:
    keyvaultName: my-kv
    tenantId: <tenant>
    objects: |
      - objectName: db-password
        objectType: secret`,
      prodTip: "secretObjects use karo taaki env secretKeyRef pattern same rahe.",
      archNodes: ["keyvault", "mi", "csi"],
    },
    {
      title: "Pod YAML with CSI Volume",
      subtitle: "Mount example",
      points: [
        "CSI volume SecretProviderClass reference karta hai",
        "Mount path pe files appear: /mnt/secrets/db-password",
        "syncSecret.enabled → normal K8s Secret bhi banta hai",
        "App restart pe bhi Vault se fresh sync ho sakta hai",
      ],
      diagram: `volumes:
  - name: secrets
    csi:
      driver: secrets-store.csi.k8s.io
      volumeAttributes:
        secretProviderClass: kv-app-secrets
volumeMounts:
  - name: secrets
    mountPath: /mnt/secrets
    readOnly: true`,
      archNodes: ["keyvault", "backend"],
    },
  ],

  monitoring: [
    {
      title: "Monitoring Stack",
      subtitle: "Kya measure karo",
      points: [
        "Metrics: CPU, memory, request rate, error rate, latency",
        "Prometheus: scrape metrics — pods, nodes, apps",
        "Grafana: dashboards + visualization",
        "Alertmanager: threshold cross → PagerDuty/Slack/Teams",
      ],
      diagram: `App /metrics endpoint
    │
    ▼
Prometheus (scrape)
    │
    ├── Grafana (dashboards)
    └── Alertmanager → on-call`,
      archNodes: ["pods"],
    },
    {
      title: "What to Alert On",
      subtitle: "Architect SLO thinking",
      points: [
        "Pod CrashLoopBackOff, OOMKilled, ImagePullBackOff",
        "High error rate (5xx), latency p99 spike",
        "Node NotReady, disk pressure, PVC almost full",
        "Cert expiry (Ingress TLS), ArgoCD sync failed",
      ],
      prodTip: "Alert sirf actionable cheez pe — noise = team ignore karegi.",
      archNodes: ["pods"],
    },
  ],

  logging: [
    {
      title: "Centralized Logging",
      subtitle: "kubectl logs se aage",
      points: [
        "Har node pe log agent (Fluent Bit, Promtail) — pod logs collect",
        "Central store: Loki, Elasticsearch, Azure Monitor",
        "Labels se filter: namespace, pod, app, tier",
        "Prod debug = logs + metrics + traces together (correlation)",
      ],
      diagram: `Pod stdout/stderr
    │
    ▼
DaemonSet (Fluent Bit)
    │
    ▼
Loki / Azure Log Analytics
    │
    ▼
Grafana explore / KQL queries`,
      archNodes: ["pods"],
    },
  ],

  helm: [
    {
      title: "Helm — Kya hai?",
      subtitle: "Package manager for K8s",
      points: [
        "Chart = templated YAML bundle (Deployment, Svc, ConfigMap...)",
        "values.yaml se customize — dev vs prod alag values",
        "helm install/upgrade/rollback — release history",
        "Reusable — community charts (nginx, prometheus, argocd)",
      ],
      diagram: `Chart/
  Chart.yaml
  values.yaml
  templates/
    deployment.yaml  ← {{ .Values.replicaCount }}`,
      archNodes: ["argocd"],
    },
    {
      title: "Helm Workflow",
      subtitle: "Practical commands",
      flowSteps: [
        "① helm create my-app (ya existing chart use)",
        "② values.yaml edit — image, replicas, resources",
        "③ helm install release-name ./chart -n my-ns",
        "④ helm upgrade release-name ./chart -f prod-values.yaml",
        "⑤ helm rollback release-name 1 (if broken)",
        "⑥ helm uninstall release-name",
      ],
      prodTip: "Helm values Git me rakho — ArgoCD Helm chart deploy bhi kar sakta hai.",
      archNodes: ["argocd"],
    },
  ],

  "gitops-argocd": [
    {
      title: "GitOps — Concept",
      subtitle: "Git = single source of truth",
      points: [
        "Manifests Git repo me — cluster me direct kubectl nahi (ideally)",
        "ArgoCD/Flux watch karta hai repo — drift detect + sync",
        "PR review → merge → auto deploy — audit trail milta hai",
        "Rollback = Git revert + sync",
      ],
      diagram: `Dev pushes YAML → Git repo
                    │
                    ▼
              ArgoCD watches
                    │
                    ▼
              kubectl apply (auto)
              Cluster state = Git state`,
      archNodes: ["argocd"],
    },
    {
      title: "ArgoCD Setup Flow",
      subtitle: "Bootstrap to app deploy",
      flowSteps: [
        "① ArgoCD install (helm install argo-cd)",
        "② Git repo me k8s manifests / helm charts rakho",
        "③ ArgoCD Application CRD: repoURL, path, destination cluster+ns",
        "④ syncPolicy: automated, selfHeal: true",
        "⑤ ArgoCD UI me health + sync status dekho",
        "⑥ Drift hua → self-heal ya manual sync",
      ],
      diagram: `apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: three-tier
spec:
  source:
    repoURL: https://github.com/you/repo
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: three-tier`,
      archNodes: ["argocd"],
    },
  ],

  "cicd-pipeline": [
    {
      title: "CI/CD for K8s",
      subtitle: "Code se cluster tak",
      points: [
        "CI: code push → test → build image → scan (Trivy) → push registry",
        "CD: update image tag in Git → ArgoCD sync → cluster update",
        "Tag strategy: semver ya git SHA — latest mat use prod me",
        "Pipeline: GitHub Actions / Azure DevOps / GitLab CI",
      ],
      flowSteps: [
        "① Developer push code to main",
        "② CI runs tests + docker build",
        "③ Image push ACR (tag: build-123)",
        "④ CI updates values.yaml image tag in Git",
        "⑤ ArgoCD detects change → rolling update in cluster",
        "⑥ Smoke test / health check verify",
      ],
      diagram: `Code → CI → Image → Registry
              │
              ▼
         Git (manifest tag update)
              │
              ▼
         ArgoCD → K8s Deployment rollout`,
      archNodes: ["argocd"],
    },
  ],

  "architect-checklist": [
    {
      title: "Production Readiness",
      subtitle: "Architect final review",
      points: [
        "HA: multi-node, pod anti-affinity, PDB, multiple replicas",
        "Security: RBAC least privilege, NP default deny, PSS restricted",
        "Secrets: Key Vault / CSI — no plain secrets in Git",
        "Backup: Velero / cloud snapshot — etcd + PVC restore tested",
        "Monitoring + alerting + runbooks documented",
        "GitOps + reviewed pipeline — no manual kubectl prod me",
      ],
      diagram: `□ CIDR planned    □ Private cluster
□ RBAC + NP       □ Key Vault linked
□ Monitoring      □ Backup tested
□ GitOps live     □ DR runbook`,
      archNodes: ["api-server", "rbac", "np", "keyvault", "argocd"],
    },
    {
      title: "Multi-Tenancy & Governance",
      subtitle: "Shared cluster me",
      points: [
        "Namespace per team + ResourceQuota + LimitRange",
        "NetworkPolicy isolate namespaces",
        "OPA/Gatekeeper policies — no privileged pods, required labels",
        "Cost tags, labels for chargeback",
      ],
      prodTip: "Namespace-level access tumhara daily reality — design usi boundary me socho.",
      archNodes: ["rbac", "np"],
    },
  ],

  troubleshooting: [
    {
      title: "ImagePullBackOff",
      subtitle: "Prod problem #1",
      points: [
        "Symptom: pod ImagePullBackOff / ErrImagePull",
        "Cause: wrong tag, no registry auth, TLS/proxy, image deleted",
        "Fix: kubectl describe pod → Events dekho",
        "Fix: imagePullSecrets / ACR attach / correct tag verify",
        "Tumhare lab me: kind load docker-image karna pada (corporate TLS)",
      ],
      diagram: `kubectl describe pod <name>
Events:
  Failed to pull image "myapp:v2"
  → tag exist? registry auth? node pull test`,
      prodTip: "Corporate proxy: pre-load image ya internal registry mirror use karo.",
      archNodes: ["pods"],
    },
    {
      title: "CrashLoopBackOff",
      subtitle: "App start nahi ho rahi",
      points: [
        "Symptom: pod restart loop",
        "Cause: app error, wrong config, DB unreachable, bad entrypoint",
        "Fix: kubectl logs <pod> --previous",
        "Fix: liveness probe too aggressive — startupProbe add karo",
        "Lab example: backend crash jab postgres ready nahi tha",
      ],
      diagram: `kubectl logs pod/backend-xxx
kubectl logs pod/backend-xxx --previous
→ Python traceback / connection refused`,
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods", "backend"],
    },
    {
      title: "Service Not Reachable",
      subtitle: "Connection timeout / refused",
      points: [
        "Check: selector labels match pod labels?",
        "Check: readiness probe pass? endpoints empty?",
        "Check: NetworkPolicy blocking ingress/egress?",
        "Check: DNS — nslookup backend.<ns>.svc.cluster.local",
        "Lab: frontend→frontend Service blocked by NP (by design)",
      ],
      diagram: `kubectl get endpoints backend -n three-tier
→ no addresses = readiness fail or wrong selector

kubectl get networkpolicy -n three-tier`,
      labFile: "k8s/05-network-policies.yaml",
      archNodes: ["np", "pods"],
    },
    {
      title: "OOMKilled & Resource Limits",
      subtitle: "Pod memory khatam",
      points: [
        "Symptom: kubectl describe → Reason: OOMKilled",
        "Cause: memory limit kam, memory leak, JVM heap",
        "Fix: kubectl top pod → actual usage dekho",
        "Fix: limits increase ya app optimize",
        "Prevention: always set requests + limits",
      ],
      diagram: `resources:
  requests: { memory: 256Mi }
  limits:   { memory: 512Mi }  ← exceed = OOMKill`,
      archNodes: ["pods"],
    },
    {
      title: "Secret / Key Vault Fail",
      subtitle: "Mount empty ya permission denied",
      points: [
        "CSI mount fail: Managed Identity RBAC on Key Vault check",
        "SecretProviderClass wrong tenantId / keyvaultName",
        "Federated credential SA name mismatch",
        "Fix: kubectl describe pod → FailedMount events",
        "Fix: az role assignment list — Key Vault Secrets User role?",
      ],
      flowSteps: [
        "kubectl describe pod → mount error message",
        "Verify UAMI has Key Vault access policy / RBAC",
        "Verify federated credential issuer + subject",
        "Verify SA annotation client-id correct",
        "Test: az keyvault secret show --vault-name X",
      ],
      archNodes: ["keyvault", "mi"],
    },
    {
      title: "ArgoCD Out of Sync",
      subtitle: "Git vs cluster mismatch",
      points: [
        "Symptom: ArgoCD app Degraded / OutOfSync",
        "Cause: manual kubectl edit (drift), invalid YAML, resource conflict",
        "Fix: ArgoCD UI → diff dekho kya change hua",
        "Fix: selfHeal on → auto revert drift",
        "Fix: sync with Replace/Force only if understood",
      ],
      diagram: `ArgoCD UI → APP DIFF
Left: Git (desired)  Right: Cluster (live)
→ manual change? fix Git or enable selfHeal`,
      archNodes: ["argocd"],
    },
    {
      title: "PVC Pending",
      subtitle: "Storage bind nahi ho raha",
      points: [
        "Symptom: PVC status Pending forever",
        "Cause: no StorageClass, provisioner missing, zone mismatch",
        "Fix: kubectl describe pvc → Events",
        "Fix: StorageClass default check, CSI driver installed?",
        "AKS: sku / disk size / zone alignment verify",
      ],
      diagram: `kubectl get pvc
kubectl describe pvc data-postgres-0
Events: no persistent volumes available`,
      labFile: "k8s/02-database.yaml",
      archNodes: ["csi"],
    },
  ],

});
