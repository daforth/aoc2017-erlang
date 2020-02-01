local layers = {}
do
  local f = assert(io.open("../input13"))
  for l in f:lines() do
    local ls, rs = l:match("(%d+):%s(%d+)")
    local l = tonumber(ls)
    local r = tonumber(rs)
    layers[l] = r
  end
  f:close()
end

local function caught(delay)
  for l, r in pairs(layers) do
    if ((l + delay) % (r * 2 - 2)) == 0 then
      return true
    end
  end
  return false
end

for i=1, math.maxinteger do
  if not caught(i) then
    print(i)
    break
  end
end
