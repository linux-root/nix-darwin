return {
  "folke/sidekick.nvim",
  opts = {
    nes = { enabled = false },
  },
  keys = {
    {
      "<tab>",
      function()
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<leader>an",
      function()
        require("sidekick.nes").toggle()
      end,
      desc = "Toggle NES",
    },
    {
      "<leader>ar",
      function()
        require("sidekick.nes").clear()
      end,
      desc = "Clear all active edits",
    },
    -- {
    --   "<c-.>",
    --   function()
    --     require("sidekick.cli").toggle({ name = "copilot" })
    --   end,
    --   desc = "Sidekick Toggle",
    --   mode = { "n", "t", "i", "x" },
    -- },
    -- {
    --   "<leader>aa",
    --   function()
    --     require("sidekick.cli").toggle({ name = "copilot" })
    --   end,
    --   desc = "Sidekick Toggle Copilot CLI",
    -- },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Detach CLI Session",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}
