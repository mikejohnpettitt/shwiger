import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { text: String };

  async speak() {
    const token = document.querySelector('meta[name="csrf-token"]').content;

    const resp = await fetch("/tts_clips", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({ text: this.textValue }),
    });

    const data = await resp.json();
    if (!resp.ok) throw new Error(data.error || `HTTP ${resp.status}`);

    if (data.audio_url) {
      this.play(data.audio_url);
      return;
    }

    // pending: poll until ready
    const clip = await this.pollUntilReady(data.id);
    this.play(clip.audio_url);
  }

  play(url) {
    const audio = new Audio(url);
    audio.play();
  }

  async pollUntilReady(id) {
    for (let i = 0; i < 30; i++) {
      await new Promise((r) => setTimeout(r, 500));
      const resp = await fetch(`/tts_clips/${id}`, {
        headers: { Accept: "application/json" },
      });
      const data = await resp.json();
      if (data.status === "ready" && data.audio_url) return data;
      if (data.status === "failed") throw new Error("TTS generation failed");
    }
    throw new Error("Timed out waiting for TTS");
  }
}
