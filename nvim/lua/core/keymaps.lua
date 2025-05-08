vim.keymap.set('i', 'jj', '<Esc>', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('n', ']]', '<cmd>Neotree toggle reveal<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
-- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap = true, silent = true })
-- vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true })

