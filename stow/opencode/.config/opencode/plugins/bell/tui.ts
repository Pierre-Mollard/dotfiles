import { Plugin } from "@opencode/plugin/tui"

export default Plugin.define({
  id: "dotfiles.bell",
  setup(context) {
    const bell = () => {
      process.stdout.write("\x07")
    }
    const stop = [
      context.data.on("session.execution.succeeded", bell),
      context.data.on("session.execution.failed", bell),
      context.data.on("permission.asked", bell),
      context.data.on("form.created", bell),
    ]

    return () => stop.forEach((unsubscribe) => unsubscribe())
  },
})
