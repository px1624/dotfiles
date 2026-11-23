vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Build telescope fzf extension on plugin install',
  group = vim.api.nvim_create_augroup('plugin: telescope-fzf-native build', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == 'telescope-fzf-native.nvim'
      and (ev.data.kind == 'install' or ev.data.kind == 'update')
    then
      vim.system({ 'make' }, { cwd = ev.data.path }):wait()
    end
  end,
})

return {
  src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  priority = 10
}
