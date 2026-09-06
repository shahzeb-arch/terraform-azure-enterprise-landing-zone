"""
K8s Playbook Chat API — free local AI via Ollama.
Run: python app.py   (needs Ollama: ollama pull llama3.2)
"""
import os

import requests
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

OLLAMA_BASE = os.environ.get("OLLAMA_HOST", "http://localhost:11434")
OLLAMA_MODEL = os.environ.get("OLLAMA_MODEL", "llama3.2")
CHAT_PORT = int(os.environ.get("CHAT_PORT", "5001"))

SYSTEM_PROMPT = """You are a Kubernetes Solution Architect tutor helping a learner in India.
Rules:
- Answer ONLY about Kubernetes, cloud-native, DevOps, and related topics (Helm, ArgoCD, Azure AKS, networking, security).
- Use simple Hinglish mix (Hindi + English technical terms) — easy for freshers.
- Be practical like a senior architect: trade-offs, prod tips, when NOT to use something.
- Use short paragraphs and bullet points when helpful.
- If question is off-topic, politely redirect to K8s.
- Use the PLAYBOOK CONTEXT below when relevant — prefer it over generic knowledge.
- Keep answers focused (under 150 words unless user asks for detail).
"""

# SYSTEM_PROMPT = """You are Kubernetes Assistant (no personal name).
# Expert focus: AKS, RBAC, NetworkPolicy, Key Vault, ArgoCD, Helm.
# For off-topic: politely say you only help with Kubernetes.
# Always give prod tips when relevant.
# Keep answers under 150 words unless asked for detail.
# """

# Faster CPU inference — smaller context + token cap
OLLAMA_OPTIONS = {
    "num_predict": 400,
    "num_ctx": 2048,
    "temperature": 0.6,
}
CONTEXT_MAX_CHARS = 2500


def ollama_available():
    try:
        r = requests.get(f"{OLLAMA_BASE}/api/tags", timeout=3)
        return r.status_code == 200
    except requests.RequestException:
        return False


def model_available():
    try:
        r = requests.get(f"{OLLAMA_BASE}/api/tags", timeout=3)
        if r.status_code != 200:
            return False
        names = [m.get("name", "") for m in r.json().get("models", [])]
        return any(OLLAMA_MODEL in n for n in names)
    except requests.RequestException:
        return False


@app.route("/api/health")
def health():
    ollama_up = ollama_available()
    model_ok = model_available() if ollama_up else False
    return jsonify({
        "status": "ok",
        "ollama": ollama_up,
        "model": OLLAMA_MODEL,
        "model_ready": model_ok,
    })


@app.route("/api/chat", methods=["POST"])
def chat():
    if not ollama_available():
        return jsonify({"error": "Ollama not running. Start Ollama app first."}), 503

    if not model_available():
        return jsonify({
            "error": f"Model '{OLLAMA_MODEL}' not found. Run: ollama pull {OLLAMA_MODEL}"
        }), 503

    data = request.get_json(silent=True) or {}
    user_message = (data.get("message") or "").strip()
    if not user_message:
        return jsonify({"error": "message is required"}), 400

    context = (data.get("context") or "").strip()
    history = data.get("history") or []

    system_content = SYSTEM_PROMPT
    if context:
        system_content += f"\n\n--- PLAYBOOK CONTEXT ---\n{context[:CONTEXT_MAX_CHARS]}\n--- END CONTEXT ---"

    messages = [{"role": "system", "content": system_content}]

    for item in history[-6:]:
        role = item.get("role")
        content = (item.get("content") or "").strip()
        if role in ("user", "assistant") and content:
            messages.append({"role": role, "content": content})

    messages.append({"role": "user", "content": user_message})

    try:
        resp = requests.post(
            f"{OLLAMA_BASE}/api/chat",
            json={
                "model": OLLAMA_MODEL,
                "messages": messages,
                "stream": False,
                "options": OLLAMA_OPTIONS,
            },
            timeout=120,
        )
        resp.raise_for_status()
        reply = resp.json().get("message", {}).get("content", "").strip()
        if not reply:
            return jsonify({"error": "Empty response from Ollama"}), 502
        return jsonify({"reply": reply, "model": OLLAMA_MODEL})
    except requests.Timeout:
        return jsonify({"error": "Ollama timeout — model slow or overloaded"}), 504
    except requests.RequestException as exc:
        return jsonify({"error": f"Ollama error: {exc}"}), 502


if __name__ == "__main__":
    print(f"K8s Chat API on http://localhost:{CHAT_PORT}")
    print(f"Ollama: {OLLAMA_BASE}  model: {OLLAMA_MODEL}")
    if ollama_available():
        print("Ollama: connected")
        if not model_available():
            print(f"WARNING: run  ollama pull {OLLAMA_MODEL}")
    else:
        print("WARNING: Ollama not running — install from https://ollama.com")
    app.run(host="127.0.0.1", port=CHAT_PORT, debug=False)
