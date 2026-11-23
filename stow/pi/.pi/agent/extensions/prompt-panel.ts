import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { visibleWidth } from "@earendil-works/pi-tui";

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui" || ctx.ui.getEditorComponent()) return;

    class PromptPanel extends CustomEditor {
      protected renderTopBorder(width: number, hiddenLineCount: number): string {
        if (!ctx.isIdle() || hiddenLineCount > 0 || width < 20) {
          return super.renderTopBorder(width, hiddenLineCount);
        }
        const theme = ctx.ui.theme;
        const title = theme.style(" Prompt ", { fg: "accent", bold: true });
        const shortcuts = width >= 50 ? theme.fg("dim", " / commands · /diff changes ") : "";
        return this.borderColor("╶") + title
          + this.borderColor("─".repeat(Math.max(0, width - 1 - visibleWidth(title + shortcuts))))
          + shortcuts;
      }

      render(width: number): string[] {
        if (width < 22) return super.render(width);
        const theme = ctx.ui.theme;
        const lines = super.render(width - 2);
        return lines.map((line, index) => {
          if (index === 0 || index === lines.length - 1) return `  ${line}`;
          // Keep the editor's cursor marker and ANSI styling intact.
          return `${theme.fg("accent", "▎")} ${line}`;
        });
      }
    }

    ctx.ui.setEditorComponent((tui, theme, keys) =>
      new PromptPanel(tui, theme, keys, { paddingX: 1, embedWorkingStatus: true }));
  });
}
