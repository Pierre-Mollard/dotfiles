import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";

export default function (pi: ExtensionAPI) {
  let enabled = true;

  function apply(ctx: ExtensionContext) {
    if (ctx.mode !== "tui") return;
    if (!enabled) {
      ctx.ui.setFooter(undefined);
      return;
    }

    ctx.ui.setFooter((tui, theme, data) => ({
      dispose: data.onBranchChange(() => tui.requestRender()),
      invalidate() {},
      render(width) {
        const branch = data.getGitBranch();
        const percent = ctx.getContextUsage()?.percent;
        const parts = [
          ...(branch ? [theme.fg("accent", branch)] : []),
          theme.fg("text", ctx.model?.id ?? "no model"),
          theme.fg("muted", `think: ${ctx.thinkingLevel}`),
          theme.fg(percent != null && percent >= 85 ? "warning" : "muted",
            `ctx: ${percent == null ? "—" : `${Math.round(percent)}%`}`),
          ...data.getExtensionStatuses().values(),
        ];
        return [truncateToWidth(parts.join(theme.fg("dim", " · ")), width)];
      },
    }));
  }

  pi.on("session_start", (_event, ctx) => apply(ctx));
  pi.registerCommand("compact-footer", {
    description: "Toggle between the compact and default footer",
    handler: async (_args, ctx) => {
      if (ctx.mode !== "tui") return;
      enabled = !enabled;
      apply(ctx);
    },
  });
}
