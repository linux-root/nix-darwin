-- Function to read bash scripts from directory
local function get_scripts_from_directory()
  local scripts_dir = vim.fn.stdpath("config") .. "/lua/plugins/bash_scripts"
  local scripts = {}
  
  -- Check if directory exists
  if vim.fn.isdirectory(scripts_dir) == 0 then
    vim.notify("Scripts directory not found: " .. scripts_dir, vim.log.levels.WARN)
    return scripts
  end
  
  -- Read all .sh files from the directory
  local files = vim.fn.glob(scripts_dir .. "/*.sh", false, true)
  
  for _, file_path in ipairs(files) do
    local filename = vim.fn.fnamemodify(file_path, ":t:r") -- Get filename without extension
    local display_name = filename:gsub("_", " "):gsub("^%l", string.upper) -- Convert snake_case to Title Case
    
    table.insert(scripts, {
      name = display_name,
      file_path = file_path,
      filename = filename
    })
  end
  
  return scripts
end

-- Function to run a script file
local function run_script_file(script_info)
  if not script_info.file_path or vim.fn.filereadable(script_info.file_path) == 0 then
    vim.notify("Script file not found: " .. (script_info.file_path or "unknown"), vim.log.levels.ERROR)
    return
  end
  
  -- Make sure the script is executable
  os.execute("chmod +x " .. vim.fn.shellescape(script_info.file_path))
  
  -- Get current working directory where nvim is open
  local current_dir = vim.fn.getcwd()
  
  -- Create a maximized terminal window (IntelliJ style)
  -- First, create a new tab for the run output
  vim.cmd("tabnew")
  
  -- Set the tab name to show what's running
  vim.cmd("file Run\\ Output:\\ " .. script_info.name:gsub(" ", "\\ "))
  
  -- Open terminal in the new tab (maximized)
  vim.cmd("terminal cd " .. vim.fn.shellescape(current_dir) .. " && echo 'Running: " .. script_info.name .. "' && echo 'Working Directory: " .. current_dir .. "' && echo '─────────────────────────────────────────────────────────────' && bash " .. vim.fn.shellescape(script_info.file_path))
  
  -- Enter insert mode in terminal automatically
  vim.cmd("startinsert")
end

-- Custom script menu function
local function script_menu()
  -- Check if fzf-lua is available
  local has_fzf, fzf = pcall(require, "fzf-lua")
  if not has_fzf then
    vim.notify("fzf-lua is not available", vim.log.levels.ERROR)
    return
  end

  local scripts = get_scripts_from_directory()
  
  if #scripts == 0 then
    vim.notify("No bash scripts found in the bash_scripts directory", vim.log.levels.WARN)
    return
  end
  
  -- Prepare the script options for fzf (simplified)
  local script_options = {}
  for i, script in ipairs(scripts) do
    -- Simple format: just the clean name
    table.insert(script_options, script.name)
  end
  
  local opts = {
    prompt = "Run Configuration ❯ ",
    fzf_opts = {
      ["--ansi"] = "",
      ["--layout"] = "reverse",
      ["--border"] = "sharp",
      ["--margin"] = "0,1",
      ["--padding"] = "0,1",
      ["--info"] = "right",
      ["--separator"] = "─",
      ["--header"] = "Choose configuration to run (Enter=Run, Esc=Cancel)",
      ["--header-first"] = "",
      -- IntelliJ-inspired color scheme (blue/gray theme)
      ["--color"] = "bg+:#2B2D30,bg:#1E1F22,spinner:#6F737A,hl:#4A9EFF,fg:#AFB1B3,header:#4A9EFF,info:#6F737A,pointer:#4A9EFF,marker:#4A9EFF,fg+:#FFFFFF,prompt:#4A9EFF,hl+:#4A9EFF,border:#3C3F41",
    },
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          -- Find the script by name (simplified format)
          local script_name = selected[1]
          for _, script in ipairs(scripts) do
            if script.name == script_name then
              vim.notify("Running: " .. script.name, vim.log.levels.INFO)
              run_script_file(script)
              break
            end
          end
        end
      end,
    },
    winopts = {
      height = 0.6,
      width = 0.85,
      row = 0.4,
      col = 0.5,
      border = "single",
      title = " Run Configurations ",
      title_pos = "left",
      preview = {
        title = " Script Content ",
        title_pos = "left",
        border = "single",
        type = "cmd",
        cmd = "bat --style=plain --color=always --theme=base16 {}",
        cmd_fallback = "cat {}",
        fn_transform = function(item)
          -- Find script file path by name (simplified format)
          for _, script in ipairs(scripts) do
            if script.name == item then
              return script.file_path
            end
          end
          return item
        end,
        scrollbar = "border",
        wrap = "wrap",
      },
    },
  }
  
  fzf.fzf_exec(script_options, opts)
end

return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>bs", script_menu, desc = "Bash Scripts Menu" },
    },
  },
}