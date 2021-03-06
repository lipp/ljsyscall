-- this puts everything into one table ready to use

local require, print, error, assert, tonumber, tostring,
setmetatable, pairs, ipairs, unpack, rawget, rawset,
pcall, type, table, string, math = 
require, print, error, assert, tonumber, tostring,
setmetatable, pairs, ipairs, unpack, rawget, rawset,
pcall, type, table, string, math

local abi = require "syscall.abi"

local ffi = require "ffi"

if abi.rump and abi.types then abi.os = abi.types end -- pretend to be NetBSD for normal rump, Linux for rumplinux

require "syscall.ffitypes"
require("syscall." .. abi.os .. ".ffitypes")

if not abi.rump then
  require "syscall.ffifunctions"
  require("syscall." .. abi.os .. ".ffifunctions")
  if abi.bsd then require "syscall.bsd.ffifunctions" end
end

local ostypes = require("syscall." .. abi.os .. ".types")

local c = require("syscall." .. abi.os .. ".constants")

local bsdtypes
if (abi.rump and abi.types == "netbsd") or (not abi.rump and abi.bsd) then
  bsdtypes = require("syscall.bsd.types")
end
local types = require "syscall.types".init(c, ostypes, bsdtypes)

local C
if abi.rump then
  C = require("syscall.rump.c")
else
  C = require("syscall." .. abi.os .. ".c")
end

-- cannot put in S, needed for tests, cannot be put in c earlier due to deps  TODO remove see #94
c.IOCTL = require("syscall." .. abi.os .. ".ioctl").init(types)

local S = require "syscall.syscalls".init(C, c, types)

S.abi, S.types, S.t, S.c = abi, types, types.t, c -- add to main table returned

-- add compatibility code
S = require "syscall.compat".init(S)

-- add functions from libc
S = require "syscall.libc".init(S)

-- add methods
S = require "syscall.methods".init(S)

-- add utils
S.util = require "syscall.util".init(S)

if abi.os == "linux" then
  S.cgroup = require "syscall.linux.cgroup".init(S)
  S.nl = require "syscall.linux.nl".init(S)
  -- TODO add the other Linux specific modules here
end

return S


