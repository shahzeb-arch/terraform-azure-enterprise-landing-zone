/* 03-10 Deep sections + Platform + Troubleshooting 24 */
Object.assign(SLIDES, {

  "namespace-deep": [
    { section: 1, title: "Namespace — Beyond Segregation", subtitle: "", points: ["Segregation: teams/apps isolated", "ResourceQuota: max CPU/memory/pods per NS", "LimitRange: default min/max per container in NS", "Pod Security Standards: enforce restricted"], archNodes: ["rbac"] },
    { section: 4, title: "Managed Namespace — Industry", subtitle: "", points: ["Member selection: who gets access", "Policy: what resources allowed", "Quota: prevent one team eating cluster", "NetworkPolicy: default deny per namespace", "Your prod: namespace-level access = this boundary"], flowSteps: ["Create NS per team/env", "Apply ResourceQuota + LimitRange", "RBAC Role per team", "Default deny NetworkPolicy", "ArgoCD app per namespace"], archNodes: ["rbac", "np"] },
    { section: 8, title: "Interview", subtitle: "", points: ["Quota vs LimitRange?", "How isolate teams without new cluster?"], archNodes: ["rbac"] },
  ],

  "entra-rbac": [
    { section: 1, title: "Entra ID + K8s RBAC", subtitle: "Azure", points: ["Azure AD groups mapped to K8s RBAC", "AKS integration: admin group, Azure RBAC for K8s", "Least privilege: dev group → edit in dev NS only", "No cluster-admin for app developers"], archNodes: ["rbac"] },
    { section: 4, title: "Prod Setup", subtitle: "", flowSteps: ["Create Entra ID group per team", "AKS: Azure RBAC or K8s RBAC binding", "Role: edit in namespace X only", "Cluster admins: platform team only", "Audit: who can delete production"], archNodes: ["rbac"] },
  ],

  "storage-azure-disk": [
    { section: 1, title: "Azure Disk via CSI", subtitle: "RWO", points: ["1 pod per disk (ReadWriteOnce)", "CSI driver: disk.csi.azure.com", "StorageClass: managed-csi, Premium_LRS", "Zone: disk zone must match node zone"], archNodes: ["csi"] },
    { section: 3, title: "Prereq & MI Flow", subtitle: "", flowSteps: ["① Enable CSI driver on AKS", "② StorageClass with managed-csi", "③ Managed Identity or SA with disk access", "④ PVC create in namespace", "⑤ Pod volumeMount claimName", "⑥ App writes to mountPath"], diagram: `PVC → Azure Managed Disk → Pod /data`, archNodes: ["csi", "mi"] },
    { section: 7, title: "Failure", subtitle: "", points: ["PVC Pending: no StorageClass, wrong zone", "Disk attach fail: node in different zone", "Permission: MI missing Disk Contributor"], archNodes: ["csi"] },
  ],

  "storage-azure-files": [
    { section: 1, title: "Azure Files — RWX", subtitle: "Shared", points: ["ReadWriteMany: multiple pods same share", "Use: shared uploads, config share", "SMB protocol via CSI", "Needs storage account + secret or MI"], archNodes: ["csi"] },
    { section: 4, title: "Prod", subtitle: "", points: ["Less common than Disk for DB", "Good for legacy apps needing shared folder", "Performance lower than local disk"], archNodes: ["csi"] },
  ],

  "service-deep": [
    { section: 1, title: "ClusterIP", subtitle: "Internal", points: ["Default type — cluster internal only", "Virtual IP stable — endpoints change behind it", "DNS: mysvc.mynamespace.svc.cluster.local", "Short name works same namespace: mysvc"], labFile: "k8s/examples/service-production.yaml", archNodes: ["service", "dns"] },
    { section: 1, title: "NodePort", subtitle: "Dev/Lab", points: ["Opens port 30000-32767 on every node", "External: nodeIP:nodePort", "Lab: our frontend :30080", "Prod: prefer Ingress or LB instead"], labFile: "k8s/04-frontend.yaml", archNodes: ["service"] },
    { section: 1, title: "LoadBalancer", subtitle: "Cloud", points: ["Creates cloud LB (Azure LB, AWS ELB)", "External IP assigned automatically", "Cost: per LB — expensive if many services", "Prod: 1 Ingress + 1 LB better than 10 LBs"], archNodes: ["lb", "service"] },
    { section: 7, title: "Failure — Service deleted", subtitle: "Architect Q", points: [
      "Service delete → DNS name gone",
      "Endpoints gone → connection refused/timeout",
      "Frontend config me service name hai → instant outage",
      "Fix: recreate Service same name+selector OR update app config",
    ], diagram: `Service deleted?
  frontend → backend:5000 → NXDOMAIN / timeout
  Fix: restore Service + matching selector`, archNodes: ["service", "dns"] },
    { section: 8, title: "Interview", subtitle: "", points: ["ClusterIP vs NodePort vs LB?", "What happens if Service deleted?", "headless Service kya hai?"], archNodes: ["service"] },
  ],

  "netpol-deep": [
    { section: 1, title: "NetworkPolicy Anatomy", subtitle: "Every field", labFile: "k8s/examples/networkpolicy-production.yaml", points: [
      "podSelector: which pods this policy applies to",
      "policyTypes: Ingress, Egress (must list both if denying)",
      "ingress[]: who can come IN + ports",
      "egress[]: where pods can go OUT + ports",
    ], diagram: `apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
spec:
  podSelector: { matchLabels: { tier: backend } }
  policyTypes: [Ingress, Egress]
  ingress:
    - from: [ podSelector, namespaceSelector ]
      ports: [ { port: 8080 } ]
  egress:
    - to: [ podSelector ]
      ports: [ { port: 5432 } ]`, archNodes: ["np"] },
    { section: 2, title: "Selectors Explained", subtitle: "", points: [
      "podSelector: same namespace pods by label",
      "namespaceSelector: all pods in namespaces matching labels",
      "ipBlock: external IP ranges (APIs, DNS, internet)",
      "Combine from[] rules = OR logic",
      "Default deny: podSelector: {} + no rules = block all",
    ], labFile: "k8s/05-network-policies.yaml", archNodes: ["np", "cni"] },
    { section: 4, title: "Industry Pattern", subtitle: "Zero trust", flowSteps: [
      "① default-deny-all ingress+egress",
      "② allow-dns-egress (UDP/TCP 53)",
      "③ allow frontend ingress from LB/ingress",
      "④ allow frontend egress → backend only",
      "⑤ allow backend egress → DB only",
    ], archNodes: ["np"] },
    { section: 7, title: "Failure", subtitle: "", points: ["Forgot DNS egress → all DNS fails", "Forgot egress rule → API calls timeout", "CNI doesn't support NP → rules ignored (danger!)"], archNodes: ["np", "cni"] },
  ],

  "vnet-cidr-design": [
    { section: 1, title: "VNet Design — AKS", subtitle: "", points: ["VNet: overall address space (10.0.0.0/16)", "Node subnet: worker VM IPs", "Azure CNI: pods get IPs FROM VNet subnet (real IPs)", "Overlay mode: pod CIDR separate from VNet", "Service CIDR: virtual — 10.96.0.0/16 default"], archNodes: ["cni", "nodes"] },
    { section: 4, title: "How Node Gets VNet IP", subtitle: "Azure CNI", points: [
      "Node = Azure VM in node subnet → gets NIC IP from VNet",
      "Azure CNI: each pod gets IP from same or dedicated pod subnet",
      "Check: az aks show — network profile",
      "Pod IP visible in VNet — corporate firewall can see",
    ], diagram: `VNet 10.0.0.0/16
  Node subnet 10.0.1.0/24 → nodes
  Pod subnet 10.0.2.0/23 → pod IPs (Azure CNI)
  Service CIDR 10.96.0.0/16 → virtual`, archNodes: ["cni", "nodes", "pods"] },
    { section: 8, title: "Interview", subtitle: "", points: ["Azure CNI vs kubenet?", "How plan pod IP capacity?"], archNodes: ["cni"] },
  ],

  "public-private-cluster": [
    { section: 1, title: "Public vs Private API", subtitle: "", points: [
      "Public: API server has internet endpoint (IP restricted)",
      "Private: API only via VNet/PE/VPN — no public endpoint",
      "Private = more secure, harder CI/CD kubectl access",
      "Break-glass: jump box or VPN for emergency kubectl",
    ], archNodes: ["api-server"] },
    { section: 4, title: "Industry Choice", subtitle: "", points: [
      "Enterprise regulated: private cluster common",
      "Dev/test: public with authorized IP ranges",
      "CI/CD: self-hosted agent in VNet for private",
      "ArgoCD in cluster: works private (in-cluster)",
    ], archNodes: ["api-server", "argocd"] },
    { section: 8, title: "Interview", subtitle: "", points: ["How kubectl private cluster from laptop?", "CI/CD options for private AKS?"], archNodes: ["api-server"] },
  ],

  "control-plane-deep": [
    { section: 1, title: "Control Plane Components", subtitle: "", points: ["API Server: all kubectl/API traffic gateway", "etcd: cluster state database", "Scheduler: assigns pods to nodes", "Controller Manager: maintains desired state", "AKS: Microsoft manages these — you don't SSH"], archNodes: ["api-server", "etcd", "scheduler", "controller"] },
    { section: 4, title: "System Node Pool", subtitle: "AKS", points: ["System pool: critical addons, often tainted", "User pool: your app workloads", "Don't run apps on system nodes", "Platform team manages system pool sizing"], archNodes: ["nodes"] },
  ],

  "worker-node-deep": [
    { section: 1, title: "Worker Node Components", subtitle: "", points: [
      "kubelet: agent — ensures pods running on this node",
      "kube-proxy: Service traffic routing (iptables/IPVS)",
      "containerd/CRI: actually runs containers",
      "Node labels: disktype=ssd, zone=east-1a",
      "Taints: repel pods unless toleration",
    ], archNodes: ["nodes", "kubelet", "pods"] },
    { section: 4, title: "Node Labels & Taints", subtitle: "", points: [
      "Label: node selector / affinity target",
      "Taint: NoSchedule — only tolerated pods allowed",
      "System node taint: CriticalAddonsOnly",
      "GPU node: nvidia.com/gpu=true + taint",
    ], archNodes: ["nodes"] },
    { section: 7, title: "Node Crash", subtitle: "", points: ["Node NotReady → pods evicted after timeout", "PDB ensures min pods on other nodes", "StatefulSet: pod reschedules, PVC reattaches (same zone)"], archNodes: ["nodes", "pods"] },
  ],

  "node-upgrade-e2e": [
    { section: 1, title: "Node Upgrade — Full Process", subtitle: "E2E", flowSteps: [
      "① PREREQ: PDB in place, surge capacity available",
      "② PREREQ: backup etcd (platform), apps healthy",
      "③ Notify stakeholders — maintenance window",
      "④ AKS: upgrade control plane version first",
      "⑤ Upgrade node pool (surge node pool technique)",
      "⑥ New nodes ready → cordon old node",
      "⑦ kubectl drain old node — respect PDB",
      "⑧ Old node removed, verify all pods healthy",
      "⑨ Repeat for each node / rolling pool upgrade",
      "⑩ Post: smoke tests, monitoring green",
    ], archNodes: ["nodes", "pods"] },
    { section: 7, title: "Failure During Upgrade", subtitle: "", points: ["Drain stuck: PDB too strict or standalone pod", "Pod pending after drain: insufficient cluster capacity", "Fix: temporarily adjust PDB, add surge node"], archNodes: ["nodes"] },
  ],

  "delivery-deep": [
    { section: 1, title: "CI/CD — Full Picture", subtitle: "", points: ["CI: build, test, scan, push image", "CD: deploy to cluster (GitOps preferred)", "Tools: ADO, GitHub Actions, GitLab, Jenkins", "GitOps: ArgoCD watches Git, not CI push"], archNodes: ["argocd"] },
    { section: 3, title: "Azure Auth — WIF not PAT", subtitle: "", flowSteps: [
      "① Federated credential (WIF) — no long-lived token",
      "② Managed Identity for ACR pull / AKS deploy",
      "③ ADO Service Connection with workload identity federation",
      "④ GitHub Actions: OIDC to Azure",
      "⑤ Avoid: PAT in pipeline variables (rotate nightmare)",
    ], archNodes: ["mi", "argocd"] },
    { section: 4, title: "OWASP in Pipeline", subtitle: "", points: ["SAST: code scan in CI", "Image scan: Trivy/Defender on push", "Block deploy if critical CVE", "SBOM generation for supply chain", "Sign images: Cosign"], archNodes: ["argocd"] },
    { section: 3, title: "Best Practice Deploy Flow", subtitle: "", flowSteps: [
      "Code push → CI test",
      "Docker build → scan → push ACR",
      "Update image tag in Git (Helm values)",
      "ArgoCD sync → rolling update in cluster",
      "Smoke test + rollback plan ready",
    ], archNodes: ["argocd"] },
  ],

});

/* 24 Troubleshooting scenarios — replaces/extends troubleshooting */
Object.assign(SLIDES, {
  troubleshooting: [
    { title: "1. ImagePullBackOff", subtitle: "Scenario", points: ["Symptom: pod can't pull image", "Check: kubectl describe pod Events", "Causes: wrong tag, no ACR auth, corporate proxy", "Fix: imagePullSecrets, ACR attach, kind load image"], diagram: `kubectl describe pod → Failed to pull image`, archNodes: ["pods"] },
    { title: "2. CrashLoopBackOff", subtitle: "Scenario", points: ["Symptom: pod restart loop", "Check: kubectl logs --previous", "Causes: app error, bad config, DB down", "Fix: fix app, startupProbe, check deps"], archNodes: ["pods"] },
    { title: "3. OOMKilled", subtitle: "Scenario", points: ["Symptom: Reason OOMKilled", "Check: kubectl top pod, limits", "Fix: increase memory limit or fix leak"], archNodes: ["pods"] },
    { title: "4. Pod Pending — Resources", subtitle: "Scenario", points: ["Symptom: Pending, Events say insufficient cpu/memory", "Fix: reduce requests, add nodes, CA", "Check: kubectl describe pod"], archNodes: ["pods", "nodes"] },
    { title: "5. Pod Pending — Affinity/Taint", subtitle: "Scenario", points: ["Symptom: didn't match node selector/affinity/taints", "Fix: fix affinity rules or add toleration", "Check: describe pod scheduling Events"], archNodes: ["pods", "nodes"] },
    { title: "6. Readiness Failing", subtitle: "Scenario", points: ["Symptom: pod running but not in endpoints", "Users: intermittent 503", "Fix: fix /ready endpoint, DB connection", "Check: kubectl get endpoints"], archNodes: ["pods", "service"] },
    { title: "7. Service Not Reachable", subtitle: "Scenario", points: ["Symptom: connection timeout", "Check: selector labels match? endpoints?", "Fix: align labels, fix readiness"], archNodes: ["service"] },
    { title: "8. DNS Resolution Fail", subtitle: "Scenario", points: ["Symptom: can't resolve service name", "Check: CoreDNS pods, dnsPolicy, NP blocking UDP 53", "Fix: allow DNS egress in NetworkPolicy"], archNodes: ["dns", "np"] },
    { title: "9. NetworkPolicy Block", subtitle: "Scenario", points: ["Symptom: timeout between services", "Check: kubectl get netpol, test without NP", "Fix: add ingress/egress rule"], labFile: "k8s/05-network-policies.yaml", archNodes: ["np"] },
    { title: "10. Ingress 502/404", subtitle: "Scenario", points: ["Symptom: URL wrong response", "Check: ingress rules, backend endpoints, TLS secret", "Fix: path, service port, cert"], archNodes: ["ingress-ctrl"] },
    { title: "11. TLS Cert Expired", subtitle: "Scenario", points: ["Symptom: browser cert error", "Fix: cert-manager renew, check ClusterIssuer", "Prevent: alert 30 days before expiry"], archNodes: ["ingress-ctrl"] },
    { title: "12. PVC Pending", subtitle: "Scenario", points: ["Symptom: PVC Pending forever", "Check: StorageClass, CSI driver, zone", "Fix: correct SC, install CSI"], archNodes: ["csi"] },
    { title: "13. Secret Mount Fail", subtitle: "Scenario", points: ["Symptom: FailedMount CSI", "Check: MI permissions, SecretProviderClass", "Fix: Key Vault RBAC, federated cred"], archNodes: ["keyvault"] },
    { title: "14. RBAC Forbidden", subtitle: "Scenario", points: ["Symptom: User cannot get/deploy", "Check: kubectl auth can-i", "Fix: RoleBinding for user/SA"], archNodes: ["rbac"] },
    { title: "15. HPA Not Scaling", subtitle: "Scenario", points: ["Symptom: CPU high but replicas same", "Check: metrics-server, requests set", "Fix: install metrics-server, set requests"], archNodes: ["hpa"] },
    { title: "16. CA Not Adding Nodes", subtitle: "Scenario", points: ["Symptom: pods pending, no new nodes", "Check: CA logs, max node limit, IAM", "Fix: raise max, fix permissions"], archNodes: ["nodes", "hpa"] },
    { title: "17. Rollout Stuck", subtitle: "Scenario", points: ["Symptom: kubectl rollout status hangs", "Check: new pod readiness, image pull", "Fix: kubectl rollout undo"], archNodes: ["deployment"] },
    { title: "18. ArgoCD OutOfSync", subtitle: "Scenario", points: ["Symptom: app Degraded/OutOfSync", "Check: diff in Argo UI", "Fix: sync or enable selfHeal"], archNodes: ["argocd"] },
    { title: "19. Node NotReady", subtitle: "Scenario", points: ["Symptom: node NotReady status", "Check: kubelet, disk pressure, network", "Fix: restart kubelet, free disk, replace node"], archNodes: ["nodes"] },
    { title: "20. etcd Issues", subtitle: "Scenario", points: ["Symptom: API slow/errors, quorum loss", "Managed: open Azure support ticket", "Self-managed: etcd member health, restore"], archNodes: ["etcd", "api-server"] },
    { title: "21. API Server Timeout", subtitle: "Scenario", points: ["Symptom: kubectl hangs", "Causes: etcd, overload, network", "Check: control plane metrics"], archNodes: ["api-server"] },
    { title: "22. PDB Blocking Drain", subtitle: "Scenario", points: ["Symptom: kubectl drain stuck", "Check: PDB minAvailable vs replicas", "Fix: temporarily adjust PDB or scale up"], archNodes: ["pods"] },
    { title: "23. Workload Identity Fail", subtitle: "Scenario", points: ["Symptom: auth error to Key Vault/Storage", "Check: federated cred, SA annotation, MI RBAC", "Fix: align issuer+subject, grant role"], archNodes: ["mi", "keyvault"] },
    { title: "24. High Latency Between Services", subtitle: "Scenario", points: ["Symptom: slow API between microservices", "Check: NetworkPolicy path, cross-zone, mesh", "Fix: topology, cache, service mesh tracing"], archNodes: ["service", "np"] },
  ],
});
