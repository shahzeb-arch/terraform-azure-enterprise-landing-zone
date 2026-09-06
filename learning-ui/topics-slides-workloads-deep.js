/* 02 Workloads Deep — every field + STS/DS/Job */
Object.assign(SLIDES, {

  "deploy-fields-deep": [
    {
      section: 1, title: "spec.replicas & selector", subtitle: "Deployment core",
      points: [
        "replicas: kitne pod chahiye — HPA isko override kar sakta hai",
        "selector.matchLabels MUST equal template.metadata.labels",
        "Mismatch = Deployment broken, no pods managed",
        "revisionHistoryLimit: kitne old ReplicaSets rollback ke liye",
      ],
      diagram: `spec:
  replicas: 3
  selector:
    matchLabels:
      app: web        # MUST match ↓
  template:
    metadata:
      labels:
        app: web`,
      labFile: "k8s/examples/deployment-production.yaml",
      archNodes: ["deployment", "replicaset"],
    },
    {
      section: 2, title: "strategy — surge & unavailable", subtitle: "Rollout control",
      points: [
        "RollingUpdate: gradual replace (prod default)",
        "maxSurge: extra pods during deploy (1 or 25%)",
        "maxUnavailable: max down pods (0 = zero downtime)",
        "minReadySeconds: pod ready ke baad kitna wait before count",
        "progressDeadlineSeconds: stuck rollout timeout",
      ],
      diagram: `strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
  minReadySeconds: 5
  progressDeadlineSeconds: 600`,
      prodTip: "Prod golden: maxUnavailable 0, maxSurge 1.",
      archNodes: ["deployment"],
    },
    {
      section: 3, title: "image & imagePullSecrets", subtitle: "Container image",
      points: [
        "image: registry/repo:tag — prod me semver or digest, not latest",
        "imagePullPolicy: Always | IfNotPresent | Never",
        "imagePullSecrets: private ACR/ECR credentials",
        "ACR attach (AKS) = no pull secret needed sometimes",
      ],
      diagram: `imagePullSecrets:
  - name: acr-secret
containers:
  - image: myacr.azurecr.io/app:1.2.3
    imagePullPolicy: Always`,
      archNodes: ["deployment"],
    },
    {
      section: 4, title: "resources — requests & limits", subtitle: "CPU/Memory",
      points: [
        "requests: scheduler node pick karta hai — minimum guarantee",
        "limits: hard cap — memory exceed = OOMKilled",
        "CPU: 100m = 0.1 core | memory: 512Mi",
        "HPA needs requests set — bina requests HPA blind",
      ],
      archNodes: ["pods", "hpa"],
    },
    {
      section: 5, title: "probes — all 3 types", subtitle: "Health",
      points: [
        "livenessProbe: dead app → kubelet restart",
        "readinessProbe: not ready → removed from Service",
        "startupProbe: slow boot — protects liveness (Java, DB apps)",
        "initialDelaySeconds, periodSeconds, failureThreshold tune karo",
      ],
      labFile: "k8s/03-backend.yaml",
      archNodes: ["pods", "service"],
    },
    {
      section: 6, title: "securityContext — pod & container", subtitle: "Hardening",
      points: [
        "Pod level: runAsNonRoot, fsGroup, seccompProfile",
        "Container level: readOnlyRootFilesystem, drop ALL capabilities",
        "allowPrivilegeEscalation: false — mandatory prod",
        "Pod Security Standards: restricted namespace enforce",
      ],
      archNodes: ["rbac", "pods"],
    },
    {
      section: 7, title: "affinity & nodeSelector", subtitle: "Scheduling",
      points: [
        "nodeSelector: simple label match (disktype=ssd)",
        "nodeAffinity: required/preferred node rules",
        "podAffinity: schedule NEAR other pods",
        "podAntiAffinity: spread replicas — HA (different nodes)",
        "topologySpreadConstraints: multi-AZ spread (best HA)",
      ],
      diagram: `podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector: { matchLabels: { app: web } }
      topologyKey: kubernetes.io/hostname`,
      archNodes: ["pods", "nodes"],
    },
    {
      section: 8, title: "tolerations & taints", subtitle: "Node restrictions",
      points: [
        "Taint on node: repel pods unless toleration matches",
        "Use: dedicated GPU nodes, system node pool",
        "DaemonSet needs tolerations for control-plane taints",
        "NoSchedule | PreferNoSchedule | NoExecute",
      ],
      archNodes: ["nodes", "pods"],
    },
    {
      section: 3, title: "volumes & volumeMounts", subtitle: "Storage in pod",
      points: [
        "volumes: define sources (PVC, ConfigMap, Secret, emptyDir)",
        "volumeMounts: mount path inside container",
        "subPath: mount single file from ConfigMap",
        "readOnly: true for secrets/config",
      ],
      archNodes: ["csi", "pods"],
    },
    {
      section: 3, title: "env & envFrom", subtitle: "Configuration",
      points: [
        "env: direct value or valueFrom (ConfigMap/Secret)",
        "envFrom: bulk import all keys from CM/Secret",
        "secretKeyRef: specific key from Secret",
        "Never hardcode passwords — use Secret or Key Vault CSI",
      ],
      labFile: "k8s/03-backend.yaml",
      archNodes: ["keyvault"],
    },
    {
      section: 3, title: "lifecycle & initContainers", subtitle: "Startup sequence",
      points: [
        "initContainers: run BEFORE main container, sequentially",
        "Use: wait for DB, download config, migration check",
        "lifecycle.postStart / preStop: graceful shutdown hooks",
        "preStop: drain connections before SIGTERM",
      ],
      diagram: `initContainers:
  - name: wait-for-db
    image: busybox
    command: ['sh', '-c', 'until nc -z db 5432; do sleep 2; done']
containers:
  - name: app ...`,
      archNodes: ["pods"],
    },
    {
      section: 3, title: "dnsConfig & dnsPolicy", subtitle: "Pod DNS",
      points: [
        "dnsPolicy: ClusterFirst (default) | Default | None",
        "dnsConfig: custom nameservers, searches, options",
        "ndots:5 issue — FQDN vs short name resolution",
        "Custom DNS for external service mesh integration",
      ],
      archNodes: ["dns", "pods"],
    },
    {
      section: 6, title: "annotations & labels", subtitle: "Metadata",
      points: [
        "labels: selectors, grouping (app, tier, version)",
        "annotations: non-identifying metadata (ingress config, scrape)",
        "blockOwnerDeletion: prevent delete if owner exists",
        "Helm, ArgoCD, Prometheus use annotations heavily",
      ],
      archNodes: ["deployment"],
    },
    {
      section: 6, title: "serviceAccountName", subtitle: "Identity",
      points: [
        "Pod runs as this ServiceAccount identity",
        "automountServiceAccountToken: false if not needed",
        "Custom SA for RBAC + Workload Identity",
        "Never use default SA in prod without review",
      ],
      labFile: "k8s/01-rbac.yaml",
      archNodes: ["rbac", "mi"],
    },
  ],

  "statefulset-deep": [
    { section: 1, title: "What — StatefulSet", subtitle: "Stable + disk", points: ["Ordered pod names: db-0, db-1", "Stable network ID via headless Service", "volumeClaimTemplates: PVC per replica", "Ordered rolling update"], archNodes: ["statefulset", "postgres"] },
    { section: 2, title: "Why — not Deployment", subtitle: "Architect decision", points: ["Deployment: random pod names, no stable disk", "DB needs: identity + persistent volume per instance", "Kafka, Redis, Elasticsearch same pattern", "Industry: ANY stateful data = StatefulSet"], prodTip: "Postgres on Deployment = data loss on reschedule.", archNodes: ["statefulset"] },
    { section: 4, title: "Prod — PostgreSQL on AKS", subtitle: "Use case", points: ["StatefulSet + Azure Disk PVC", "Headless svc: postgres-0.postgres.ns.svc", "Backup: Velero or pg_dump CronJob", "Consider managed DB (RDS/Azure DB) for prod often"], labFile: "k8s/02-database.yaml", archNodes: ["statefulset", "postgres", "csi"] },
    { section: 7, title: "Failure", subtitle: "Common issues", points: ["PVC Pending: StorageClass/zone mismatch", "Pod stuck Terminating: finalizers", "Split brain: never scale DB StatefulSet without ops plan"], archNodes: ["statefulset", "csi"] },
    { section: 8, title: "Interview", subtitle: "", points: ["STS vs Deployment?", "Headless Service kyun?", "How backup StatefulSet data?"], archNodes: ["statefulset"] },
  ],

  "daemonset-deep": [
    { section: 1, title: "What — DaemonSet", subtitle: "", points: ["1 pod per node automatically", "Node add/remove = pod add/remove", "tolerations for master/system taints", "updateStrategy: RollingUpdate or OnDelete"], archNodes: ["pods", "nodes"] },
    { section: 2, title: "Why — Prometheus Example", subtitle: "Industry", points: [
      "WITHOUT DaemonSet: manually install node-exporter on 50 nodes — nightmare",
      "WITH DaemonSet: deploy once, every node gets exporter automatically",
      "New node in cluster → exporter auto appears",
      "Same for: Fluent Bit logs, Datadog agent, Calico node",
    ], diagram: `DaemonSet: prometheus-node-exporter
  Node-A → exporter pod
  Node-B → exporter pod
  Node-C → exporter pod
  (auto, no manual install)`, archNodes: ["pods", "nodes"] },
    { section: 4, title: "Prod", subtitle: "", points: ["Platform team owns DaemonSets", "Resource limits still required", "HostNetwork sometimes needed (CNI)", "Do NOT run app workloads as DaemonSet"], archNodes: ["pods"] },
    { section: 8, title: "Interview", subtitle: "", points: ["DaemonSet vs Deployment?", "When tolerations required?", "Prometheus node monitoring pattern?"], archNodes: ["pods"] },
  ],

  "job-cronjob-deep": [
    { section: 1, title: "Job", subtitle: "", points: ["Runs pod to completion", "completions + parallelism for batch", "backoffLimit: retry count", "activeDeadlineSeconds: max runtime"], archNodes: ["pods"] },
    { section: 4, title: "CronJob Prod", subtitle: "", points: ["schedule: cron format (0 2 * * *)", "Nightly DB backup, report generation", "concurrencyPolicy: Forbid if previous still running", "suspend: true to pause without delete"], archNodes: ["pods"] },
    { section: 7, title: "Failure", subtitle: "", points: ["Job failed: check logs, backoff exhausted", "CronJob missed: startingDeadlineSeconds", "Too many failed jobs: alert on Job failure rate"], archNodes: ["pods"] },
  ],

  "vpa": [
    { section: 1, title: "VPA — Vertical Pod Autoscaler", subtitle: "", points: ["Adjusts CPU/memory requests/limits automatically", "Vertical = bigger pod, not more pods (HPA = horizontal)", "Modes: Off (recommend only), Initial, Auto", "Use with caution with HPA on same metric"], archNodes: ["hpa", "pods"] },
    { section: 4, title: "Prod", subtitle: "", points: ["Start VPA in Off mode — read recommendations", "Rightsizing saves cost — FinOps tool", "Auto mode causes pod restart on change"], archNodes: ["hpa"] },
    { section: 8, title: "Interview", subtitle: "", points: ["HPA vs VPA vs Cluster Autoscaler?"], archNodes: ["hpa", "nodes"] },
  ],

});
