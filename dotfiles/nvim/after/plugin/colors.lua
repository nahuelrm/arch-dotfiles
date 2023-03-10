require('rose-pine').setup({
		--- @usage 'main' | 'moon'
		dark_variant = 'moon',
		bold_vert_split = false,
		dim_nc_background = false,
		disable_background = false,
		disable_float_background = false,
		disable_italics = false,

		--- @usage string hex value or named color from rosepinetheme.com/palette
		groups = {
				background = 'base',
				panel = 'surface',
				border = 'highlight_med',
				comment = 'muted',
				link = 'iris',
				punctuation = 'subtle',

				error = 'love',
				hint = 'iris',
				info = 'foam',
				warn = 'gold',

				headings = {
						h1 = 'iris',
						h2 = 'foam',
						h3 = 'rose',
						h4 = 'gold',
						h5 = 'pine',
						h6 = 'foam',
				}
				-- or set all headings at once
				-- headings = 'subtle'
		},

		-- Change specific vim highlight groups
		highlight_groups = {
				ColorColumn = { bg = 'moon' }
		}
})

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}


-- set colorscheme after options
vim.cmd('colorscheme rose-pine')

