
local lapis = require('lapis.application')
local mock_request = require('lapis.spec.request').mock_request
local use_test_env = require('lapis.spec').use_test_env
local respond_to = require("lapis.application").respond_to

local app = lapis.Application()

app:match('/page/:id[%d]/:name', function(self)
  print("welcome to my page")

  for k, v in pairs(self.params) do
    print(k, '=', v)
  end
end)
app:match('/hello/lj', function(self)
  print('/hello/lj')
end)
app:match('/browse/*', function(self)
  print(self.params.splat)
  for k, v in pairs(self.params) do
    print(k, '=', v)
  end
end)
app:match('/settings(/:username(/:page))(.:format)', function(self)
  print(self.params.splat)
  for k, v in pairs(self.params) do
    print(k, '=', v)
  end
end)

app:match('edit_user', '/edit_user/:id[%d]', respond_to({
  before = function(self)
    print(debug.traceback('before', 3))
  end,

  GET = function(self)
    print(debug.traceback('GET', 3))
  end,

  POST = function(self)
    print(debug.traceback('POST', 3))
  end
}))

function app.handle_404(self)
  print('..... 4-4')
  print(self.params.splat)
  for k, v in pairs(self.params) do
    print(k, '=', v)
  end
end

describe('lapis route #lapis_route', function()
  -- it('should make a request', function()
  --   local status, body = mock_request(app, '/hello')

  --   assert.are.same(ngx.HTTP_OK, status)
  --   assert.is.truthy(body:match('welcome to my page'))
  -- end)

  it('test', function()
    mock_request(app, '/edit_user/11')
  end)
end)
