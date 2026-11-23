import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Narrow, best-effort checks for common spellings, not a shell parser or sandbox.
const patterns = [
  /\bsudo\b/,
  /\brm\s+(?:-[\w-]+\s+)*(?:--recursive\b|-[a-zA-Z]*[rR][a-zA-Z]*(?=\s|$))/,
  /\bgit\s+reset\s+(?:-[\w-]+\s+)*--hard\b/,
  /\bgit\s+clean\s+(?:-[\w-]+\s+)*(?:--force\b|-[a-zA-Z]*f[a-zA-Z]*(?=\s|$))/,
  /\bgit\s+push\b[^\n;|&]*(?:\s--force(?:-with-lease)?(?=\s|=|$)|\s-f(?=\s|$))/,
];

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "bash") return;
    const command = event.input.command;
    if (typeof command !== "string" || !patterns.some((pattern) => pattern.test(command))) return;

    if (!ctx.hasUI) return { block: true, reason: "Shell command requires interactive approval." };
    // Keep control characters from being rendered as terminal escape sequences.
    const preview = command.replace(/[\x00-\x1f\x7f-\x9f]/g, (char) =>
      `\\x${char.charCodeAt(0).toString(16).padStart(2, "0")}`);
    const choice = await ctx.ui.select(`Allow shell command? ${preview}`, ["Block", "Allow"], { signal: ctx.signal });
    if (choice !== "Allow") return { block: true, reason: "Shell command was not approved." };
  });
}
