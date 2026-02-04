local codes = require('http-codes.codes')

return {
  pick = function(open_url)
    require('fzf-lua').fzf_exec(vim.tbl_keys(codes), {
      actions = {
        default = function(selected)
          local link = codes[selected[1]]

          vim.fn.jobstart(open_url:format(link))
        end,
      },
    })
  end,
}
