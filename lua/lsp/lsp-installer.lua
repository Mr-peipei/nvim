-- local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
-- if not status_ok then
--   return
-- end

-- local servers = {
--   "cssls",
--   "cssmodules_ls",
--   "emmet_ls",
--   "html",
--   -- "jdtls",
--   "jsonls",
--   "solc",
--   "sumneko_lua",
--   "tflint",
--   "tsserver",
--   "pyright",
--   "yamlls",
--   "bashls",
--   "clangd",
-- }

-- local settings = {
--   ensure_installed = servers,
--   -- automatic_installation = false,
--   ui = {
--     keymaps = {
--       toggle_server_expand = "<CR>",
--       install_server = "i",
--       update_server = "u",
--       check_server_version = "c",
--       update_all_servers = "U",
--       check_outdated_servers = "C",
--       uninstall_server = "X",
--     },
--   },

--   log_level = vim.log.levels.INFO,
--   -- max_concurrent_installers = 4,
--   -- install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" },
-- }

-- lsp_installer.setup(settings)

-- local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
-- if not lspconfig_status_ok then
--   return
-- end

-- local opts = {}

-- for _, server in pairs(servers) do
--   opts = {
--     on_attach = require("lsp.handlers").on_attach,
--     capabilities = require("user.lsp.handlers").capabilities,
--   }


--   lspconfig[server].setup(opts)
-- end

-- TODO: add something to installer later
-- require("lspconfig").motoko.setup {}
--
--
--



local config = {
  -- disable virtual text
  virtual_text = false,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.diagnostic.config(config)


local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- LSPサーバーのフォーマット機能を無効にする
  client.resolved_capabilities.document_formatting = false

  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "<gk>", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local lsp_installer = require "nvim-lsp-installer"
local lspconfig = require "lspconfig"
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
lsp_installer.setup()
for _, server in ipairs(lsp_installer.get_installed_servers()) do
  lspconfig[server.name].setup {
    on_attach = on_attach,
    capabilities =capabilities 
  }
end
