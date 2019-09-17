local say = require("say")
local assert = require('luassert.assert')

local function has_property(state, arguments)
  local property = arguments[1]
  local table = arguments[2]
  for key, value in pairs(table) do
    if key == property then
      return true
    end
  end
  return false
end

local function has_no_property(state, arguments)
  return not has_property(state, arguments)
end

say:set_namespace("en")
say:set("assertion.has_property.positive", "Expected property %s in:\n%s")
say:set("assertion.has_property.negative", "Expected property %s to not be in:\n%s")
assert:register("assertion", "has_property", has_property, "assertion.has_property.positive", "assertion.has_property.negative")
assert:register("assertion", "has_no_property", has_no_property, "assertion.has_property.positive", "assertion.has_property.negative")
