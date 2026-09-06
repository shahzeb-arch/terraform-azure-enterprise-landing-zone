let currentTopic = null;
let currentSlide = 0;
let searchQuery = "";

const $ = (sel) => document.querySelector(sel);
const $$ = (sel) => document.querySelectorAll(sel);

function init() {
  renderNav();
  renderArch();
  showHome();
  bindControls();
}

function getTopic(id) {
  return TOPICS.find((t) => t.id === id);
}

function filterTopics() {
  const q = searchQuery.toLowerCase();
  if (!q) return TOPICS;
  return TOPICS.filter(
    (t) =>
      t.title.toLowerCase().includes(q) ||
      t.brief.toLowerCase().includes(q) ||
      t.group.toLowerCase().includes(q)
  );
}

function renderNav() {
  const nav = $("#topic-nav");
  const topics = filterTopics();
  const groups = [...new Set(topics.map((t) => t.group))];

  if (!topics.length) {
    nav.innerHTML = `<p style="padding:1rem;color:var(--muted);font-size:0.85rem">No topics match.</p>`;
    return;
  }

  nav.innerHTML = groups
    .map((group) => {
      const items = topics
        .filter((t) => t.group === group)
        .map(
          (t) => `
        <button class="topic-btn" data-topic="${t.id}" title="${t.brief}">
          <span class="topic-icon" style="background:${t.color}22;color:${t.color}">${t.icon}</span>
          <span class="topic-btn-text">${t.title}</span>
        </button>`
        )
        .join("");
      return `<div class="topic-group">${group}</div>${items}`;
    })
    .join("");

  nav.querySelectorAll(".topic-btn").forEach((btn) => {
    btn.addEventListener("click", () => openTopic(btn.dataset.topic));
  });

  if (currentTopic) updateActiveNav(currentTopic);
}

function renderArch() {
  const panel = $("#arch-diagram");
  panel.innerHTML = ARCH_LAYERS.map(
    (layer, i) => `
    ${i > 0 ? '<div class="flow-arrow">▼</div>' : ""}
    <div class="arch-layer">
      <div class="arch-layer-label">${layer.label}</div>
      <div class="arch-nodes">
        ${layer.nodes.map((n) => `<span class="arch-node" data-node="${n.id}">${n.name}</span>`).join("")}
      </div>
    </div>`
  ).join("");
}

function highlightArch(nodes, topicId) {
  const topicNodes = topicId && TOPIC_ARCH_MAP[topicId] ? TOPIC_ARCH_MAP[topicId] : [];
  const active = [...new Set([...(nodes || []), ...topicNodes])];
  $$(".arch-node").forEach((el) => {
    const on = active.length > 0 && active.includes(el.dataset.node);
    el.classList.toggle("active", on);
    el.classList.toggle("dim", active.length > 0 && !on);
  });
}

function showHome() {
  currentTopic = null;
  currentSlide = 0;
  updateActiveNav(null);
  $("#breadcrumb").innerHTML = "<strong>K8s Architect Playbook</strong>";
  $("#slide-counter").textContent = `${TOPICS.length} topics`;

  const groups = [...new Set(TOPICS.map((t) => t.group))];
  const sections = groups
    .map((group) => {
      const cards = TOPICS.filter((t) => t.group === group)
        .map(
          (t) => `
        <div class="topic-card" data-topic="${t.id}">
          <div class="topic-card-icon" style="color:${t.color}">${t.icon}</div>
          <h3>${t.title}</h3>
          <p class="topic-brief">${t.brief}</p>
          <div class="count">${(SLIDES[t.id] || []).length} slides</div>
        </div>`
        )
        .join("");
      return `<section class="home-section"><h2>${group}</h2><div class="topic-grid">${cards}</div></section>`;
    })
    .join("");

  $("#slide-panel").innerHTML = `
    <div class="home-view">
      <h1>Kubernetes Architect Playbook</h1>
      <p class="home-tagline">Foundation → Deep Dive → Architect. Production me Kubernetes kaise SOCHA jata hai — docs nahi, mentor.</p>
      <div class="learning-path-box">
        <h3>Start Here — Learning Path</h3>
        <div class="path-steps">
          <div class="path-step" data-topic="learning-path"><span>1</span> Read Learning Path</div>
          <div class="path-step" data-group="01 · Foundation"><span>2</span> Foundation (all basics)</div>
          <div class="path-step" data-group="02 · Workloads Deep"><span>3</span> Workloads Deep</div>
          <div class="path-step" data-group="05 · Networking Deep"><span>4</span> Networking Deep</div>
          <div class="path-step" data-group="08 · Platform Internals"><span>5</span> Platform Internals</div>
          <div class="path-step" data-group="12 · Troubleshooting"><span>6</span> 24 Troubleshooting</div>
          <div class="path-step" data-topic="three-tier"><span>7</span> Hands-On Lab</div>
        </div>
      </div>
      <div class="home-stats">
        <span>${TOPICS.length} topics</span>
        <span>${Object.values(SLIDES).reduce((a, s) => a + s.length, 0)} slides</span>
        <span>Foundation + Deep + Architect</span>
      </div>
      ${sections}
    </div>`;

  $("#slide-panel").querySelectorAll(".path-step[data-topic]").forEach((el) => {
    el.addEventListener("click", () => openTopic(el.dataset.topic));
  });
  $("#slide-panel").querySelectorAll(".path-step[data-group]").forEach((el) => {
    el.addEventListener("click", () => {
      const t = TOPICS.find((x) => x.group === el.dataset.group);
      if (t) openTopic(t.id);
    });
  });

  $("#slide-panel").querySelectorAll(".topic-card").forEach((card) => {
    card.addEventListener("click", () => openTopic(card.dataset.topic));
  });

  highlightArch(null, null);
  updateControls();
}

function openTopic(topicId) {
  currentTopic = topicId;
  currentSlide = 0;
  updateActiveNav(topicId);
  highlightArch(null, topicId);
  renderSlide();
}

function renderSlide() {
  const topic = getTopic(currentTopic);
  const slides = SLIDES[currentTopic] || [];
  const slide = slides[currentSlide];

  $("#breadcrumb").innerHTML = `${topic.group} / <strong>${topic.title}</strong>`;
  $("#slide-counter").textContent = `${currentSlide + 1} / ${slides.length}`;

  const briefBox =
    currentSlide === 0
      ? `<div class="topic-brief-box"><strong>In short:</strong> ${topic.brief}</div>`
      : "";

  const points = (slide.points || []).map((p) => `<li>${p}</li>`).join("");

  const flowHtml = slide.flowSteps
    ? `<div class="flow-steps">
        <div class="flow-title">Step-by-step flow</div>
        <ol>${slide.flowSteps.map((s) => `<li>${s}</li>`).join("")}</ol>
       </div>`
    : "";

  const diagram = slide.diagram
    ? `<div class="diagram-box">${slide.diagram}</div>`
    : "";

  const prodTip = slide.prodTip
    ? `<div class="prod-tip"><strong>Prod tip:</strong> ${slide.prodTip}</div>`
    : "";

  const labLink = slide.labFile
    ? `<a class="lab-link" href="../${slide.labFile}" target="_blank">Lab file: ${slide.labFile}</a>`
    : "";

  const sectionBadge = slide.section && SLIDE_SECTIONS[slide.section]
    ? `<span class="section-badge">§${slide.section} ${SLIDE_SECTIONS[slide.section]}</span>`
    : "";

  $("#slide-panel").innerHTML = `
    <div class="slide-title">${slide.title}</div>
    <div class="slide-subtitle">${slide.subtitle || ""}</div>
    ${briefBox}
    ${sectionBadge}
    <div class="slide-body">
      ${points ? `<ul>${points}</ul>` : ""}
      ${flowHtml}
      ${diagram}
      ${prodTip}
      ${labLink}
    </div>`;

  highlightArch(slide.archNodes, currentTopic);
  updateControls();
  $("#slide-panel").scrollTop = 0;
}

function updateActiveNav(topicId) {
  $$(".topic-btn").forEach((btn) => {
    btn.classList.toggle("active", btn.dataset.topic === topicId);
  });
}

function updateControls() {
  const slides = currentTopic ? SLIDES[currentTopic] || [] : [];
  $("#btn-prev").disabled = !currentTopic || currentSlide === 0;
  $("#btn-next").disabled = !currentTopic || currentSlide >= slides.length - 1;

  const dots = $("#progress-dots");
  if (!currentTopic) {
    dots.innerHTML = "";
    return;
  }

  dots.innerHTML = slides
    .map(
      (_, i) =>
        `<span class="dot ${i === currentSlide ? "active" : i < currentSlide ? "done" : ""}" data-idx="${i}"></span>`
    )
    .join("");

  dots.querySelectorAll(".dot").forEach((dot) => {
    dot.addEventListener("click", () => {
      currentSlide = parseInt(dot.dataset.idx, 10);
      renderSlide();
    });
  });
}

function bindControls() {
  $("#btn-prev").addEventListener("click", () => {
    if (currentSlide > 0) {
      currentSlide--;
      renderSlide();
    }
  });

  $("#btn-next").addEventListener("click", () => {
    const slides = currentTopic ? SLIDES[currentTopic] : [];
    if (currentTopic && currentSlide < slides.length - 1) {
      currentSlide++;
      renderSlide();
    }
  });

  $("#btn-home").addEventListener("click", showHome);

  $("#search-input").addEventListener("input", (e) => {
    searchQuery = e.target.value;
    renderNav();
  });

  bindAskPanel();

  document.addEventListener("keydown", (e) => {
    if (e.target.tagName === "INPUT" && e.target.id !== "ask-input") return;
    if (e.key === "ArrowRight" || e.key === " ") {
      if (document.getElementById("ask-panel")?.hidden === false) return;
      e.preventDefault();
      $("#btn-next").click();
    }
    if (e.key === "ArrowLeft") {
      if (document.getElementById("ask-panel")?.hidden === false) return;
      $("#btn-prev").click();
    }
    if (e.key === "Escape") {
      const panel = $("#ask-panel");
      if (!panel.hidden) {
        panel.hidden = true;
        return;
      }
      showHome();
    }
  });
}

function bindAskPanel() {
  const panel = $("#ask-panel");
  const messages = $("#ask-messages");
  const form = $("#ask-form");
  const input = $("#ask-input");
  const badge = document.querySelector(".ask-badge");
  let chatHistory = [];
  let aiMode = false;

  async function refreshAiStatus() {
    const h = await checkChatApiHealth();
    aiMode = h.online;
    if (badge) {
      badge.textContent = h.online ? "Online" : "Ready";
      badge.style.color = h.online ? "var(--green)" : "var(--muted)";
      badge.style.background = h.online
        ? "rgba(61, 214, 140, 0.15)"
        : "rgba(139, 155, 184, 0.12)";
    }
    return null;
  }

  $("#btn-ask").addEventListener("click", async () => {
    panel.hidden = !panel.hidden;
    if (!panel.hidden) {
      input.focus();
      await refreshAiStatus();
    }
  });

  $("#ask-close").addEventListener("click", () => {
    panel.hidden = true;
  });

  messages.addEventListener("click", (e) => {
    if (e.target.classList.contains("ask-chip")) {
      submitAsk(e.target.textContent);
    }
    if (e.target.classList.contains("ask-open-topic")) {
      openTopic(e.target.dataset.topic);
      panel.hidden = true;
    }
  });

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    submitAsk(input.value);
    input.value = "";
  });

  async function submitAsk(query) {
    const q = (query || "").trim();
    if (!q) return;

    appendMsg("user", q);
    const thinking = appendMsg("bot", "<em>Preparing your answer...</em>");

    let replyText = "";
    let topicId = null;
    let usedAi = false;

    if (aiMode) {
      try {
        replyText = await askQuestionAI(q, chatHistory);
        usedAi = true;
        chatHistory.push({ role: "user", content: q });
        chatHistory.push({ role: "assistant", content: replyText });
        if (chatHistory.length > 12) chatHistory = chatHistory.slice(-12);
        const match = findBestTopics(q, 1)[0];
        if (match) topicId = match.id;
      } catch (err) {
        usedAi = false;
        console.warn("AI fallback:", err.message);
      }
    }

    if (!usedAi) {
      const offline = askQuestion(q);
      replyText = offline.text;
      topicId = offline.topicId;
    }

    thinking.remove();
    const extra = topicId
      ? `<button type="button" class="ask-open-topic" data-topic="${topicId}">Explore topic in playbook →</button>`
      : "";
    appendMsg("bot", renderMarkdownLite(replyText) + extra);
  }

  function appendMsg(role, content) {
    const div = document.createElement("div");
    div.className = `ask-msg ${role}`;
    if (role === "user") {
      div.textContent = content;
    } else {
      div.innerHTML = content;
    }
    messages.appendChild(div);
    messages.scrollTop = messages.scrollHeight;
    return div;
  }
}

document.addEventListener("DOMContentLoaded", init);
