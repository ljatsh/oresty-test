
local json = require('cjson')
local mysql = require('resty.mysql')

describe('mysql #driver_mysql', function()
  local self = {}

  setup(function()
    -- fetch mysql ip address
    local host = io.open('/etc/hosts', 'r')
    local content = host:read('*a')
    host:close()
    local ip = content:match('%s*([%d%.]+)%s+mysql%s*')
    assert.is.no_nil(ip, 'mysql should be linked')

    local db, err = mysql:new()
    assert.is.not_nil(db)

    local ok, err = db:connect({
      host = ip,
      port = 3306,
      user = "root",
      password = "root",
      charset = "utf8",
      compact_arrays = false,
      max_packet_size = 1024 * 1024
    })
    assert.is.truthy(ok, err)

    local res, err = db:query(
      'DROP DATABASE IF EXISTS ngx_test;' ..
      'CREATE DATABASE ngx_test DEFAULT CHARACTER SET utf8;' ..
      'USE ngx_test;' ..
      'CREATE TABLE t1(name VARCHAR(24) NOT NULL, age TINYINT UNSIGNED DEFAULT 0);'
    )

    assert.is.truthy(res, err)
    while err == 'again' do
      res, err = db:read_result()
    end
    self.db = db
  end)

  teardown(function()
    local res, err = self.db:query('DROP DATABASE ngx_test')
    assert.is.no_nil(res, err)

    local ok, err = self.db:close()
    assert.are.same(1, ok, err)
  end)

  before_each(function()
    assert.is.truthy(self.db:query('DELETE FROM t1;'))
  end)

  after_each(function()
    assert.is.truthy(self.db:query('DELETE FROM t1;'))
  end)

  it('normal query', function()
    local res, err = self.db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29);")
    assert.is.not_nil(res, err)
    assert.are.same(2, res.affected_rows)

    res, err = self.db:query('SELECT * FROM t1;')
    assert.are.same({{name='ljatsh', age=34}, {name='ljatbj', age=29}}, res)
  end)

  -- it('compact array', function()
  --   local db, err = mysql:new()

  --   local ok, err = create_connection(db, 'ngx_test', true)
  --   assert.is.truthy(ok, err)

  --   local res, err = db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29);")
  --   assert.is.table(res)
  --   assert.are.same(2, res.affected_rows)

  --   res, err = db:query('SELECT * FROM t1;')
  --   assert.are.same(res, {{'ljatsh', 34}, {'ljatbj', 29}})
  -- end)

  it('multiple results', function()
    local res, err = self.db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29), ('ljatxa', '18')")
    assert.are.same(3, res.affected_rows)

    res, err = self.db:query(
      'SELECT * FROM t1 WHERE age=18;' ..
      'SELECT * FROM t1 WHERE age=29;' ..
      'SELECT * FROM t1 WHERE age=34;'
    )

    assert.are.same(res, {{name='ljatxa', age=18}})

    -- query cannot be sent out now
    local res, err2 = self.db:query('SELECT 1;')
    assert.is_nil(res)
    assert.is.match('cannot send query', err2)

    local r = {}
    while err == 'again' do
      res, err = self.db:read_result()
      table.insert(r, res[1].name)
    end

    assert.are.same({'ljatbj', 'ljatsh'}, r)

    -- query should be ok now
    res, err = self.db:query('SELECT 1;')
    assert.not_nil(res)
  end)

end)
