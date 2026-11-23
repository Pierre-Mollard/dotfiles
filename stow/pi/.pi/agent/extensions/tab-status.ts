import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  let working = false;
  let prompting = false;

  function update(ctx: ExtensionContext) {
    if (ctx.mode !== "tui") return;
    ctx.ui.setTitle(`Pi · ${prompting ? "waiting for input" : working ? "working" : "ready"}`);
  }

  pi.on("session_start", (_event, ctx) => update(ctx));
  pi.on("session_info_changed", (_event, ctx) => update(ctx));
  pi.on("before_agent_start", (_event, ctx) => { working = true; update(ctx); });
  pi.on("agent_settled", (_event, ctx) => { working = false; update(ctx); });
  pi.on("ui_prompt_start", (_event, ctx) => { prompting = true; update(ctx); });
  pi.on("ui_prompt_end", (_event, ctx) => { prompting = false; update(ctx); });
  pi.on("session_shutdown", (_event, ctx) => {
    if (ctx.mode === "tui") ctx.ui.setTitle("Pi");
  });
}
