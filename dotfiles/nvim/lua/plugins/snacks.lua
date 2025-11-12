return {
  "snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        pick = function(cmd, opts)
          return LazyVim.pick(cmd, opts)()
        end,
        header = [[
                     .:===:.                     
                  .:=+++++++=:.                  
               .-=+++++++++++++=-.               
           .:-+++++++++++++++++++++-:.           
        .:=+++++++++++++++++++++++++++-..        
     .:+++++++++++++++++++++++++++++=-----:.     
    .=++++++++++++=-.       .-=+++=---------.    
    .=++++++++++=.             .=-----------.    
    .=+++++++++-.               .:----------.    
    .=++++++++:      :=++++-     .:---------.    
    .=+++++++=.     .+++++=-:::::::---------.    
    .=+++++++=.     =++++-------------------.    
    .=+++++++=.     =++=--------------------.    
    .=+++++++=.     .=-------:::::----------.    
    .=++++++++:      .------.    .:---------.    
    .=+++++++++:.      ...      .:----------.    
    .=+++++++++=-.              :-----------.    
    .=+++++++=-----:.       ..--------------.    
     .:++++=------------------------------:.     
        .:-----------------------------..        
           ..:---------------------:..           
               .:---------------:.               
                  .:---------:.                  
                     ..---..                     
          ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { icon = " ", title = "Amazing Projects", section = "projects", indent = 4, padding = 2 },
        { section = "startup" },
      },
    },
  },
}
