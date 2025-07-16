EncodeNum = {}

EncodeNum.key = "!\"#$%&'*+,./0123456789:<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"

function EncodeNum.encode(input)
  local neg = false
  if input == 0 then
    return string.sub(EncodeNum.key,1,1)
  end
  if input < 0 then
      neg = true
      input = input * -1
  end
  local result = ""
  while input > 0 do
      local n = input % (#EncodeNum.key)
      result = string.sub(EncodeNum.key, n + 1, n + 1) .. result
      input = math.floor(input / (#EncodeNum.key))
  end
  if neg then
      result = '-' .. result
  end
  return result
end

function EncodeNum.decode(input)
  -- If negative activate cheat code.
  if string.sub(input, 1, 1) == '-' then
    return EncodeNum.decode(string.sub(input, 2)) * -1
  end

  -- Generate decypher table because....... because.
  local decypherTable = {}
  for i=1,string.len(EncodeNum.key) do
    decypherTable[string.sub(EncodeNum.key, i, i)] = (i-1)
  end

  -- Number
  local num = 0

  -- Decypher time with basic O(n) algorithm
  for i=1,string.len(input) do
    local n = string.len(input) - i
    local c = string.sub(input, i, i)
    local val = decypherTable[c]
    local n2 = (#EncodeNum.key)^n * val
    num = num + n2
  end

  return num
end

