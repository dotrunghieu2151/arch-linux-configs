return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")
    auto_session.setup({
      auto_save = true,
      auto_restore = true,
      auto_create = true,
      suppressed_dirs = {"~/"},
      show_auto_restore_notif = true,
      cwd_change_handling = false,
      args_allow_single_directory = true
    })
    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session for cwd "})
    keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session for cwd "})
  end,
}
