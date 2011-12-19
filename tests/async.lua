local table = require 'table'
local async = require "async"
local Timer = require 'timer'
local lunatest = require 'lunatest'
local asserts = lunatest.asserts

local exports = {}

exports['test_forEach'] = function(test)
  local args = {}
  async.forEach({1,3,2}, function(x, callback)
    Timer.set_timeout(x*25, function()
      table.insert(args, 1, x)
      callback()
    end)
  end, function(err)
    asserts.array_equal(args, {1,2,3})
  end)
end

exports['test_forEachEmpty'] = function(test)
  local args = {}
  async.forEach({}, function(x, callback)
    asserts.True(false, 'iterator should not be called')
    callback()
  end, function(err)
    asserts.True(true, "should be called")
  end)
end

exports['test_forEachError'] = function(test)
  async.forEach({1,2,3}, function(x, callback)
    callback('error');
  end, function(err)
    asserts.not_nil(err)
  end);
end

exports['test_forEachSeries'] = function(test)
  local args = {}
  async.forEachSeries({1,3,2}, function(x, callback)
    Timer.set_timeout(x*25, function()
      table.insert(args, 1, x)
      callback()
    end)
  end, function(err)
    asserts.array_equal(args, {1, 3, 2})
  end)
end

lunatest.run(exports)
