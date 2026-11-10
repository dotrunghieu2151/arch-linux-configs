return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "0xferrous/ansi.nvim"},
  config = function() 
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local ansi = require("ansi")
    ansi.enable()
   local terminalWidth = vim.api.nvim_win_get_width(0)
   local image_folder_path = os.getenv("HOME") .. "/Pictures/NvimWallpapers"
   local motivationalQuote = vim.fn.system("motivate 0 8 8 3 8 8")
   motivationalQuote = motivationalQuote:gsub("\27%[[0-9;]*m", "")
   motivationalQuote = motivationalQuote:gsub("%s+$", "")
   math.randomseed(os.time())
-- Optionally discard the first few values to avoid weak initial states
   math.random(); math.random(); math.random()
   local function wrap_text(text, width)
        local lines = {}
        local quote_lines = {}
        local author = nil

        -- Separate the author from the quote
        for line in text:gmatch("[^\r\n]+") do
            line = vim.trim(line)

            if line:match("^%-") then
                author = line
            else
                table.insert(quote_lines, line)
            end
        end

        -- Wrap the quote without splitting words
        local quote = table.concat(quote_lines, " ")
        local current_line = ""

        for word in quote:gmatch("%S+") do
            local candidate = current_line == "" and word
                or current_line .. " " .. word

            if vim.fn.strdisplaywidth(candidate) > width
                and current_line ~= "" then
                table.insert(lines, current_line)
                current_line = word
            else
                current_line = candidate
            end
        end

        if current_line ~= "" then
            table.insert(lines, current_line)
        end

        -- Keep the author intact on its own line
        if author then
            table.insert(lines, "")
            table.insert(lines, author)
        end

    return lines
    end

      -- Create a custom footer/message section
			local message = {
				type = "text",
				val = wrap_text(motivationalQuote, math.ceil(terminalWidth*0.7)),
				opts = {
					hl = "Statement", -- Using a subtle color; change to "Statement" for more pop
					position = "center",
				},
			}

      -- Helper function to convert image to ASCII
			local function get_image_header(path)
        local height = vim.api.nvim_win_get_height(0)
				local cmd = "ascii-image-converter " .. path .. " -b --complex --dimensions " .. math.ceil(terminalWidth*0.8) .. "," .. math.ceil(height*0.5)

				local handle = io.popen(cmd)
				local result = handle:read("*a")
				handle:close()

				local lines = {}
				for line in result:gmatch("([^\n]*)\n?") do
					table.insert(lines, line)
				end
				return lines
			end

     local function random_file(dir)
        local files = vim.fn.glob(dir .. '/*', false, true)
        if #files == 0 then return nil end
        return files[math.random(#files)]
      end   
    -- Set header
    local image_path = random_file(image_folder_path)
    if image_path then
    dashboard.section.header.val = get_image_header(image_path)
    else
      dashboard.section.header.val = "NO IMAGE"
    end
    -- Apply a colorscheme highlight group
    dashboard.section.header.opts.hl = ""
    dashboard.section.buttons.opts.hl = "Number"

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>AutoSession restore<CR>"),
      dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Assemble the layout
			-- Insert the message between the header and the buttons
			dashboard.config.layout = {
				{ type = "padding", val = 2 },
				dashboard.section.header,
				{ type = "padding", val = 2 },
				message, -- Your new text message
				{ type = "padding", val = 2 },
				dashboard.section.buttons,
				dashboard.section.footer,
			}

			-- Hiding the tildes
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					vim.opt_local.fillchars = { eob = " " }
				end,
			})

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]]) 
  end,
}
