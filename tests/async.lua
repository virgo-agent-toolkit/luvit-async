pcall(require, "luacov")    --measure code coverage, if luacov is present
require "lunatest"
local async = require "async"

function test_forEach()
  fail("Blah", true)
end

lunatest.run()
