
require ('resty_assert')

-- 1. Prefer modifier prior to predicts. If the predicts/modifier was not chainable, combine modifier and predict together.

describe('resty-busted', function()
  it('predicts', function()
    -- nil
    assert.is_nil(nil, 'key ward cannot be chained')
    assert.is.not_nil({})

    -- boolean
    assert.is_true(true)
    assert.is.not_true({})
    assert.is_false(false)
    assert.is.not_false(nil)
    assert.is.boolean(true)
    assert.is.no.boolean({})

    -- number
    assert.is.number(1.9)
    assert.is.no.number(true)

    -- string
    assert.is.string('')
    assert.is.no.string(nil)

    -- table
    assert.is.table({})
    assert.is.no.table(function() end)

    -- function
    assert.is_function(function() end)
    assert.is.not_function(coroutine.create(function() end))

    -- thread
    assert.is.thread(coroutine.create(function() end))
    assert.is.not_thread(function() end)

    -- userdata
    assert.is.userdata(ngx.null)
    assert.is.no.userdata({})

    -- true|false condition
    assert.is.truthy({})
    assert.is.falsy(nil)
    assert.is.falsy(false)

    -- unique
    assert.is.unique({1, 2, 3})
    assert.is.no.unique({1, 1, 2, 3})
  end)

  it('comparision', function()
    -- equal(reference comparision)
    local a = {name='ljatsh', age=34}
    local b = a
    assert.are.no.equal({}, {})
    assert.are.equal(a, b)

    -- same(content comparision)
    assert.are.same({age=34, name='ljatsh'}, a, 'same comparision ignores order')
    assert.are.same(a, b)
    assert.are.no.same({age=35, name='ljatsh'}, a)

    -- match
    assert.has.match('^%w+$', 'ljatsh')
    assert.has.no.match('^%w+$', ' ljatsh')
  end)

  it('assert extension', function()
    assert.has.property("name", { name = "jack" })
    assert.no.has.property("surname", { name = "jack" })
    assert.has.no.property("surname", { name = "jack" })
  end)
end)
