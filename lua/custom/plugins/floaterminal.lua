-- To execute lua file after making changes, type "%lua" into terminal
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}

  -- Set default width and height to 80% of screen size
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create a buffer
  local buf = nil
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Set default config for the floating window
  local float_opts = {
    relative = 'editor', -- Relative to the editor window
    width = width, -- Width of the window
    height = height, -- Height of the window
    row = row, -- Row to position the window (centered)
    col = col, -- Column to position the window (centered)
    -- anchor = 'NW', -- Anchor position (top-left)
    border = 'rounded', -- Border style
    style = 'minimal', -- Minimal UI for the floating window
  }

  local win = vim.api.nvim_open_win(buf, true, float_opts)

  -- Open the floating window
  -- vim.api.nvim_open_win(0, true, float_opts)
  return { buf = buf, win = win }
end

state.floating = create_floating_window()
-- print(vim.inspect(state.floating))

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.term()
    end
    vim.cmd 'normal i'
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
vim.keymap.set({ 'n', 't' }, '<leader>tt', toggle_terminal)
