
require('resty_assert')
local json = require('cjson')

describe('cjson', function()
  it('encode', function()
    -- simple types
    assert.are.same('100', json.encode(100))
    assert.are.same('0.5112', json.encode(0.5112))
    assert.are.same('null', json.encode(nil))
    assert.are.same('true', json.encode(true))
    assert.are.same('"hello"', json.encode('hello'))
    assert.are.same('{}', json.encode({}))

    -- array
    assert.are.same('[100,0.5112,null,false,"hello",{}]', json.encode({100, 0.5112, nil, false, 'hello', {}}))

    -- object
    local o = {name='ljatsh', age=34}
    local str = json.encode(o)
    local t = json.decode(str)
    assert.are.same(o, {name='ljatsh', age=34})
  end)

  it('decode', function()
    assert.are.same(100, json.decode('100'))
    assert.are.same(0.5112, json.decode('0.5112'))
    assert.are.same(json.null, json.decode('null'))
    assert.are.same(true, json.decode('true'))
    assert.are.same('hello', json.decode('"hello"'))
    assert.are.same({}, json.decode('{}'))

    assert.are.same({100, 0.5112, json.null, false, 'hello', {}}, json.decode('[100,0.5112,null,false,"hello",{}]'))
  end)

  it('invalid numbers', function()
    local o = {
      name = 'ljatsh',
      nan = math.huge * 0,
      infinity = math.huge
    }

    assert.has.errors(function() json.encode(o) end)

    local json2 = json.new()
    json2.encode_invalid_numbers(true)
    local r = json2.encode(o)

    json.decode_invalid_numbers(false)
    assert.has.errors(function() json.decode(r) end)

    o2 = json2.decode(r)

    assert.are.same('ljatsh', o2.name)
    assert.is.number(o2.nan) -- TODO how to check the Nan
    assert.are.same(o.infinity, o2.infinity)
  end)

  it('sparse array', function()
    local o = {
      [1] = 34,
      [2] = 35,
      [4] = 37,
      [7] = 39
    }

    -- array and sparse array always can be encoded
    local output = json.encode(o)
    assert.are.same('[34,35,null,37,null,null,39]', output)
    local o2 = json.decode(output)
    assert.are.same({34, 35, json.null, 37, json.null, json.null, 39}, o2)

    -- excessively sparse array can be allowed/disallowed to be encoded
    local json2 = json.new()
    json2.encode_sparse_array(true, 1, 6)
    assert.are.same('{"1":34,"2":35,"4":37,"7":39}', json2.encode(o))
    json2.encode_sparse_array(false, 1, 6)
    assert.has.errors(function() json2.encode(o) end)
  end)

  it('encode empty table as array', function()
    local json2 = json.new()
    json2.encode_empty_table_as_object(false)
    assert.are.same('[]', json2.encode({}))
  end)

  it('const json.empty_array', function()
    assert.are.same('{"a":{},"b":[]}', json.encode({a={}, b=json.empty_array}))
  end)

  it('metatable array', function()
    local o = {}
    o[1] = "one"
    o[2] = "two"
    o[4] = "three"
    o.foo = "bar"

    assert.are.same('{"1":"one","2":"two","4":"three","foo":"bar"}', json.encode(o))

    setmetatable(o, json.array_mt)
    assert.are.same('["one","two",null,"three"]', json.encode(o))
  end)

  it('metatable empty array', function()
    local o = {'ljatsh', 34}
    assert.are.same('["ljatsh",34]', json.encode(o))

    o[1] = nil
    o[2] = nil
    assert.are.same('{}', json.encode(o))
    setmetatable(o, json.empty_array_mt)
    assert.are.same('[]', json.encode(o))
  end)

  it('decode as array with methtable array', function()
    local o = json.decode('[]')
    assert.are.same('{}', json.encode(o))

    local json2 = json.new()
    json2.decode_array_with_array_mt(true)
    o = json2.decode('[]')
    assert.are.same('[]', json2.encode(o))
    o[2] = 34
    o.name = 'ljatsh'
    assert.are.same('[null,34]', json2.encode(o))
  end)
end)
