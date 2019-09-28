
local lapis = require('lapis.application')
local mock_request = require('lapis.spec.request').mock_request
local use_test_env = require('lapis.spec').use_test_env

local app = lapis.Application()

app:match('/hello', function(self)
  return "welcome to my page"
end)

describe('lapis route #lapis_route', function()
  it('should make a request', function()
    local status, body = mock_request(app, '/hello')

    assert.are.same(ngx.HTTP_OK, status)
    assert.is.truthy(body:match('welcome to my page'))
  end)
end)
