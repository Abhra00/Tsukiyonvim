return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = 'markdown',
  opts = {
    bullet = {
      enabled = true,
      icons = { '●', '', '◆', '◈' },
    },
    checkbox = {
      enabled = true,
      position = 'inline',
      unchecked = {
        icon = '   󰡖 ',
        highlight = 'RenderMarkdownUnchecked',
        scope_highlight = nil,
      },
      checked = {
        icon = '   󰄲 ',
        highlight = 'RenderMarkdownChecked',
        scope_highlight = nil,
      },
    },
    html = {
      enabled = true,
      comment = {
        conceal = false,
      },
    },
    link = {
      image = '󰥶 ',
      custom = {
        youtu = { pattern = 'youtu%.be', icon = '󰗃 ' },
      },
    },
    heading = {
      sign = true,
      signs = { '󰫎 ' },
      icons = { ' 󰼏  ', ' 󰼐  ', ' 󰼑  ', ' 󰼒  ', ' 󰼓  ', ' 󰼔  ' },
      backgrounds = {
        'Headline1Bg',
        'Headline2Bg',
        'Headline3Bg',
        'Headline4Bg',
        'Headline5Bg',
        'Headline6Bg',
      },
      foregrounds = {
        'Headline1Fg',
        'Headline2Fg',
        'Headline3Fg',
        'Headline4Fg',
        'Headline5Fg',
        'Headline6Fg',
      },
    },
    code = {
      style = 'full',
    },
  },
}
