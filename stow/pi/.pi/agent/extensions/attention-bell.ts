import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

function ring(ctx: ExtensionContext): void {
  if (ctx.mode === "tui" && process.stdout.isTTY) {
    process.stdout.write("\x07");
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("ui_prompt_start", (_event, ctx) => ring(ctx));
  // Wait for retries and queued follow-ups to finish before ringing.
  pi.on("agent_settled", (event, ctx) => {
    if (!event.aborted) ring(ctx);
  });
}
