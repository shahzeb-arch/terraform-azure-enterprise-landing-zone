/* Offline Ask engine — answers from playbook slides (no API needed) */

const ASK_ALIASES = {
  deployment: "workloads",
  deploy: "workloads",
  deployment: "deployment-yaml-deep",
  replicaset: "pod-replicaset-prod",
  statefulset: "statefulset-daemonset-prod",
  daemonset: "statefulset-daemonset-prod",
  "front door": "frontdoor-waf",
  waf: "frontdoor-waf",
  frontdoor: "frontdoor-waf",
  "live website": "website-live-e2e",
  e2e: "website-live-e2e",
  statefulset: "workloads",
  daemonset: "workloads",
  job: "workloads",
  cronjob: "workloads",
  replica: "workloads",
  replicaset: "workloads",
  namespace: "namespace",
  ns: "namespace",
  service: "services",
  clusterip: "services",
  nodeport: "services",
  ingress: "ingress",
  networkpolicy: "networkpolicy",
  netpol: "networkpolicy",
  calico: "cni-deep",
  cilium: "cni-deep",
  cni: "cni-deep",
  configmap: "config-secret",
  secret: "config-secret",
  pvc: "storage",
  pv: "storage",
  storage: "storage",
  disk: "storage-flow",
  rbac: "rbac",
  role: "rbac",
  rolebinding: "rbac",
  serviceaccount: "serviceaccount",
  "service account": "serviceaccount",
  sa: "serviceaccount",
  "workload identity": "workload-identity",
  "managed identity": "workload-identity",
  keyvault: "keyvault-flow",
  "key vault": "keyvault-flow",
  secretproviderclass: "keyvault-flow",
  csi: "keyvault-flow",
  probe: "probes-pdb",
  liveness: "probes-pdb",
  readiness: "probes-pdb",
  pdb: "probes-pdb",
  helm: "helm",
  argocd: "gitops-argocd",
  gitops: "gitops-argocd",
  cicd: "cicd-pipeline",
  pipeline: "cicd-pipeline",
  prometheus: "monitoring",
  grafana: "monitoring",
  monitoring: "monitoring",
  logging: "logging",
  cidr: "cidr-planning",
  ip: "cidr-planning",
  subnet: "cidr-planning",
  cluster: "architecture",
  architecture: "architecture",
  troubleshoot: "troubleshooting",
  oom: "troubleshooting",
  crashloop: "troubleshooting",
  imagepull: "troubleshooting",
  private: "cluster-design",
  hpa: "hpa",
  etcd: "etcd-ops",
  "multi az": "multi-az",
  "disaster recovery": "disaster-recovery",
  cost: "cost-optimization",
  coredns: "dns-coredns",
  dns: "dns-coredns",
  istio: "service-mesh",
  kyverno: "security-hardening",
  opa: "security-hardening",
  architect: "think-like-architect",
};

function tokenize(text) {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9\s-]/g, " ")
    .split(/\s+/)
    .filter((w) => w.length > 1);
}

function scoreTopic(topicId, query) {
  const topic = TOPICS.find((t) => t.id === topicId);
  if (!topic) return 0;

  const slides = SLIDES[topicId] || [];
  const q = query.toLowerCase();
  const tokens = tokenize(q);
  let score = 0;

  // Direct alias hit
  for (const [alias, id] of Object.entries(ASK_ALIASES)) {
    if (q.includes(alias) && id === topicId) score += 50;
  }

  if (topic.title.toLowerCase().includes(q)) score += 40;
  if (topic.brief.toLowerCase().includes(q)) score += 30;
  if (topic.id.includes(q.replace(/\s/g, ""))) score += 25;

  tokens.forEach((tok) => {
    if (topic.title.toLowerCase().includes(tok)) score += 12;
    if (topic.brief.toLowerCase().includes(tok)) score += 10;
    if (topic.id.includes(tok)) score += 8;
  });

  slides.forEach((slide) => {
    if (slide.title && slide.title.toLowerCase().includes(q)) score += 20;
    (slide.points || []).forEach((p) => {
      const pl = p.toLowerCase();
      if (pl.includes(q)) score += 15;
      tokens.forEach((tok) => {
        if (pl.includes(tok)) score += 4;
      });
    });
    (slide.flowSteps || []).forEach((s) => {
      if (s.toLowerCase().includes(q)) score += 8;
    });
  });

  return score;
}

function findBestTopics(query, limit = 3) {
  const scored = TOPICS.map((t) => ({
    id: t.id,
    score: scoreTopic(t.id, query),
  }))
    .filter((x) => x.score > 0)
    .sort((a, b) => b.score - a.score);

  return scored.slice(0, limit);
}

function buildAnswer(query) {
  const q = query.trim();
  if (!q) {
    return {
      text: "Please ask a Kubernetes question — for example: **What is a Deployment?**, **How to link Key Vault?**, or **Why use NetworkPolicy?**",
      topicId: null,
    };
  }

  const matches = findBestTopics(q);

  if (!matches.length) {
    return {
      text: `Is query ke liye playbook me direct match nahi mila.\n\nTry karo:\n• Sidebar **Search** use karo\n• Topic name likho: \`rbac\`, \`helm\`, \`storage\`, \`argocd\`\n• Ya Cursor chat me puchho — wahan full AI help milti hai`,
      topicId: null,
    };
  }

  const best = matches[0];
  const topic = getTopicById(best.id);
  const slides = SLIDES[best.id] || [];
  const mainSlide =
    slides.find((s) => {
      const t = (s.title || "").toLowerCase();
      const ql = q.toLowerCase();
      return t.includes(ql) || tokenize(ql).some((tok) => t.includes(tok));
    }) || slides[0];

  let text = `**${topic.title}**\n${topic.brief}\n\n`;

  if (mainSlide) {
    text += `**${mainSlide.title}**\n`;
    if (mainSlide.subtitle) text += `_${mainSlide.subtitle}_\n\n`;
    (mainSlide.points || []).slice(0, 5).forEach((p) => {
      text += `• ${p}\n`;
    });
    if (mainSlide.flowSteps && mainSlide.flowSteps.length) {
      text += `\n**Flow:**\n`;
      mainSlide.flowSteps.slice(0, 5).forEach((s, i) => {
        text += `${i + 1}. ${s}\n`;
      });
      if (mainSlide.flowSteps.length > 5) {
        text += `… +${mainSlide.flowSteps.length - 5} more (topic kholo)\n`;
      }
    }
    if (mainSlide.prodTip) {
      text += `\n**Prod tip:** ${mainSlide.prodTip}\n`;
    }
  }

  if (matches.length > 1) {
    text += `\n**Related:** ${matches
      .slice(1)
      .map((m) => getTopicById(m.id).title)
      .join(", ")}`;
  }

  text += `\n\n_Use **Explore topic in playbook** below for the full slide deck._`;

  return { text, topicId: best.id };
}

function getTopicById(id) {
  return TOPICS.find((t) => t.id === id);
}

function renderMarkdownLite(text) {
  return text
    .replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>")
    .replace(/_(.+?)_/g, "<em>$1</em>")
    .replace(/\n/g, "<br>");
}

function askQuestion(query) {
  const result = buildAnswer(query);
  return {
    html: renderMarkdownLite(result.text),
    topicId: result.topicId,
    text: result.text,
  };
}

/** Context from playbook slides — sent to Ollama for RAG-lite answers */
function getPlaybookContext(query, limit = 1) {
  const matches = findBestTopics(query, limit);
  if (!matches.length) return "";

  let ctx = "";
  matches.forEach((m) => {
    const topic = getTopicById(m.id);
    const slides = SLIDES[m.id] || [];
    ctx += `\n## ${topic.title}\n${topic.brief}\n`;
    slides.slice(0, 1).forEach((s) => {
      ctx += `### ${s.title}\n`;
      if (s.subtitle) ctx += `${s.subtitle}\n`;
      (s.points || []).forEach((p) => {
        ctx += `- ${p}\n`;
      });
      (s.flowSteps || []).slice(0, 6).forEach((step, i) => {
        ctx += `${i + 1}. ${step}\n`;
      });
      if (s.prodTip) ctx += `Prod tip: ${s.prodTip}\n`;
    });
  });
  return ctx.trim();
}

const CHAT_API = "http://127.0.0.1:5001";

async function checkChatApiHealth() {
  try {
    const res = await fetch(`${CHAT_API}/api/health`, { signal: AbortSignal.timeout(2000) });
    if (!res.ok) return { online: false };
    const data = await res.json();
    return {
      online: data.ollama && data.model_ready,
      ollama: data.ollama,
      modelReady: data.model_ready,
      model: data.model,
    };
  } catch {
    return { online: false };
  }
}

async function askQuestionAI(query, history = []) {
  const context = getPlaybookContext(query);
  const res = await fetch(`${CHAT_API}/api/chat`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ message: query, history, context }),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || "Chat API failed");
  return data.reply;
}
