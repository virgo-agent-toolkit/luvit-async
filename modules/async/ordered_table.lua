local table = require 'table'

function table.ordered(fcomp)
  local newmetatable = {}

  -- sorted subtable
  newmetatable.sorted = {}
  newmetatable.klass = 'ordered_table'

  -- behavior on new index
  function newmetatable.__newindex(t, key, value)
    if type(key) == "string" then
      local tsorted = getmetatable(t).sorted
      table.binsert(tsorted, key)
      rawset(t, key, value)
    end
  end

  -- behaviour on indexing
  function newmetatable.__index(t, key)
    if key == "n" then
      return table.getn( getmetatable(t).sorted )
    end
    local realkey = getmetatable(t).sorted[key]
    if realkey then
      return realkey, rawget(t, realkey)
    end
  end

  local newtable = {}

  -- set metatable
  return setmetatable(newtable, newmetatable)
end

function table.binsert(t, value)
  table.insert(t, value)
end

-- Iterate in ordered form
-- returns 3 values i, index, value
-- ( i = numerical index, index = tableindex, value = t[index] )
function orderedPairs(t)
  return orderedNext, t
end

function orderedNext(t, i)
  i = i or 0
  i = i + 1
  local index = getmetatable(t).sorted[i]
  if index then
    return i, index, t[index]
  end
end

local exports = {}
exports.orderedPairs = orderedPairs
return exports
