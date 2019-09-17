use Test::Nginx::Socket 'no_plan';
run_tests();

__DATA__

=== TEST 1: Hello, OpenResty!
Check echo module

--- config
location = /t {
  echo "Hello, OpenResty!";
}

--- request
GET /t

--- response_body
Hello, OpenResty!

--- error_code: 200

=== Test2: Nginx Lua
Check lua module

--- config
location /t {
  content_by_lua_block {
    ngx.say("Hello, I'm from Lua.")
  }
}

--- request
GET /t

--- response_body
Hello, I'm from Lua.

--- error_code: 200
