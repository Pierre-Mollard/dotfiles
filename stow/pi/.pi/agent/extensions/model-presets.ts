import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const presets = {
  fast: { provider: "openai", model: "gpt-5.4-mini", thinking: "low" },
  deep: { provider: "openai", model: "gpt-6.2-sol", thinking: "high" },
} as const;

export default function (pi: ExtensionAPI) {
  for (const [name, preset] of Object.entries(presets)) {
    pi.registerCommand(name, {
      description: `Switch to ${preset.model} with ${preset.thinking} thinking`,
      handler: async (_args, ctx) => {
        if (!ctx.isIdle()) {
          ctx.ui.notify("Wait for the current run to finish before changing presets.", "warning");
          return;
        }
        const model = ctx.modelRegistry.find(preset.provider, preset.model);
        if (!model || !(await pi.setModel(model))) {
          ctx.ui.notify(`Model unavailable or not authenticated: ${preset.provider}/${preset.model}`, "warning");
          return;
        }
        pi.setThinkingLevel(preset.thinking);
        ctx.ui.notify(`${model.id} · thinking: ${pi.getThinkingLevel()}`, "info");
      },
    });
  }
}
