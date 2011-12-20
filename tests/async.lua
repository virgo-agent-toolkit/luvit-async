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
    asserts.array_equals(args, {1,2,3})
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
    asserts.array_equals(args, {1,3,2})
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
    asserts.array_equals(arr, args)
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

exports['test_forEachLimitExceedsSize'] = function(test, asserts)
  local args = {}
  local arr = {0,1,2,3,4,5,6,7,8,9}
  async.forEachLimit(arr, 20, function(x, callback)
    Timer.set_timeout(x*5, function()
      table.insert(args, x)
      callback()
    end)
  end, function(err)
    asserts.array_equals(args, arr)
    test.done()
  end)
end

exports['test_forEachLimitEqualSize'] = function(test, asserts)
  local args = {}
  local arr = {0,1,2,3,4,5,6,7,8,9}
  async.forEachLimit(arr, 10, function(x, callback)
    Timer.set_timeout(x*5, function()
      table.insert(args, x)
      callback()
    end)
  end, function(err)
    asserts.array_equals(args, arr)
    test.done()
  end)
end

exports['test_forEachLimitZeroSize'] = function(test, asserts)
  local args = {}
  local arr = {0,1,2,3,4,5}
  async.forEachLimit(arr, 0, function(x, callback)
    asserts.ok(false, 'iterator should not be called')
    callback()
  end, function(err)
    asserts.ok(true, 'callback should be called')
    test.done()
  end)
end

exports['test_forEachLimitError'] = function(test, asserts)
  local args = {}
  local arr = {0,1,2,3,4,5,6,7,8,9}
  async.forEachLimit(arr, 3, function(x,callback)
    table.insert(args, x)
    if x == 2 then
      callback({"error"})
    end
  end, function(err)
    asserts.ok(err)
    asserts.array_equals(args, {0,1,2})
    test.done()
  end)
end

exports['test_series'] = function(test, asserts)
  local call_order = {}
  async.series({
    function(callback)
      Timer.set_timeout(25, function()
        table.insert(call_order, 1)
        callback(nil, 1)
      end)
    end,
    function(callback)
      Timer.set_timeout(50, function()
        table.insert(call_order, 2)
        callback(nil, 2)
      end)
    end,
    function(callback)
      Timer.set_timeout(15, function()
        table.insert(call_order, 3)
        callback(nil, {3, 3})
      end)
    end
  }, function(err, results)
    asserts.equals(err, nil)
    asserts.equals(results[1], 1)
    asserts.equals(results[2], 2)
    asserts.array_equals(results[3], {3, 3})
    asserts.array_equals(call_order, {1,2,3})
    test.done()
  end)
end

exports['test_seriesEmptyArray'] = function(test, asserts)
  async.series({}, function(err, results)
    asserts.equals(err, nil)
    asserts.array_equals(results, {})
    test.done()
  end)
end

exports['test_seriesError'] = function(test, asserts)
  async.series({
    function(callback)
      callback('error')
    end,
    function(callback)
      asserts.ok(false, 'should not be called')
      callback()
    end
  }, function(err, results)
    asserts.equals(err, 'error')
    asserts.array_equals(results, {})
    test.done()
  end)
end

bourbon.run(exports)
