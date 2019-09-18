
local test = require('test')
local sdp = require('sdp')

describe('sdp #sdp', function()
  it('encode and decode', function()
    local info = test.info()

    info.id = 100
    info.name = 'lj@sh'
    info.changes[#info.changes + 1] = 4
    info.changes[#info.changes + 1] = 5
    info.changes[#info.changes + 1] = 9
    info.scores['math'] = 30
    info.scores['eng'] = 41

    local s = sdp.pack(info)
    assert.is.no_nil(s)

    local ret = sdp.unpack(s, test.info)
    assert.are.same(100, ret.id)
    assert.are.same('lj@sh', ret.name)
    assert.are.same(info.changes, ret.changes)
    assert.are.same(info.scores, ret.scores)
  end)
end)
