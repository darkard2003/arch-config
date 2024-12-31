local floating_window_state = nil

local function create_floating_window(opts)
  opts = opts or {}

  -- Get screen dimensions
  local ui = vim.api.nvim_list_uis()[1]
  local screen_width = ui.width
  local screen_height = ui.height

  -- Use optional parameters for width and height if provided, else default to 80% of the screen size
  local width = opts.width and math.floor(opts.width * screen_width) or math.floor(0.8 * screen_width)
  local height = opts.height and math.floor(opts.height * screen_height) or math.floor(0.8 * screen_height)

  -- Center the window on the screen
  local col = math.floor((screen_width - width) / 2)
  local row = math.floor((screen_height - height) / 2)

  -- Create the floating window
  local buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'rounded'
  })

  -- Open a terminal in the specified buffer
  vim.fn.termopen(os.getenv('SHELL') or '/bin/sh', { buffer = buf })

  return {
    buffer = buf,
    window = win
  }
end

local function toggle_floating_window()
  if floating_window_state and vim.api.nvim_win_is_valid(floating_window_state.window) then
    vim.api.nvim_win_close(floating_window_state.window, true)
  else
    floating_window_state = create_floating_window()
  end
end

vim.keymap.set('n', '<leader>t', toggle_floating_window)
