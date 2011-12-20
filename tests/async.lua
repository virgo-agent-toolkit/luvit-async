local table = require 'table'
local async = require "async"
local Timer = require 'timer'
local bourbon = require 'bourbon'

local exports = {}

exports['test_forEach'] = function(test, asserts)
  local args = {}
  async.forEach({1,3,2}, function(x, callback)
    Timer.set_timeout(x*25, function()
      table.insert(args, x)
      callback()
    end)
  end, function(err)
    asserts.array_equal(args, {1,2,3})
    test.done()
  end)
end

exports['test_forEachEmptyArray'] = function(test, asserts)
  local args = {}
  async.forEach({}, function(x, callback)
    asserts.ok(false, 'iterator should not be called')
    callback()
  end, function(err)
    asserts.ok(true, "should be called")
    test.done()
  end)
end

exports['test_forEachError'] = function(test, asserts)
  local args = {}
  async.forEach({1,2,3}, function(x, callback)
    table.insert(args, x)
    callback({"error"})
  end, function(err)
    asserts.ok(err ~= nil)
    asserts.ok(#args == 1)
    asserts.ok(args[1] == 1)
    test.done()
  end)
end

exports['test_forEachSeries'] = function(test, asserts)
  local args = {}
  async.forEachSeries({1,3,2}, function(x, callback)
    Timer.set_timeout(x*23, function()
      table.insert(args, x)
      callback()
    end)
  end, function(err)
    asserts.array_equal(args, {1,3,2})
    test.done()
  end)
end

exports['test_forEachSeriesEmptyArray'] = function(test, asserts)
  local args = {}
  async.forEachSeries({}, function(x, callback)
    asserts.ok(false, 'iterator should not be called')
    callback()
  end, function(err)
    asserts.ok(true, "should be called")
    test.done()
  end)
end

exports['test_forEachSeriesError'] = function(test, asserts)
  local args = {}
  async.forEachSeries({1,2,3}, function(x, callback)
    table.insert(args, x)
    callback({"error"})
  end, function(err)
    asserts.ok(err ~= nil)
    asserts.ok(#args == 1)
    asserts.ok(args[1] == 1)
    test.done()
  end)
end

exports['test_forEachLimit'] = function(test, asserts)
  local args = {}
  local arr = {1,2,3,4,5,6,7,8,9}
  async.forEachLimit(arr, 2, function(x, callback)
    Timer.set_timeout(x*5, function()
      table.insert(args, x)
      callback()
    end)
  end, function(err)
    asserts.array_equal(arr, args)
    test.done()
  end)
end

exports['test_forEachLimitEmptyArray'] = function(test, asserts)
  async.forEachLimit({}, 2, function(x, callback)
    asserts.ok(false, 'iterator should not be called')
  end, function(err)
    asserts.ok(true, 'should be called')
    test.done()
  end)
end

bourbon.run(exports)
