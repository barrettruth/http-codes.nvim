local OS_TO_OPEN_URL = {
  OSX = 'open %s',
  Windows = 'start %s',
}

local function get_os()
  if jit then
    return jit.os
  end

  local fh, _ = assert(io.popen('uname -o 2>/dev/null', 'r'))
  if fh then
    return fh:read()
  end

  return fh and fh:read() or 'Windows'
end

return {
  get_open_url = function()
    return OS_TO_OPEN_URL[get_os()] or 'xdg-open %s'
  end,
}
