-- BSD types

local require, error, assert, tonumber, tostring,
setmetatable, pairs, ipairs, unpack, rawget, rawset,
pcall, type, table, string = 
require, error, assert, tonumber, tostring,
setmetatable, pairs, ipairs, unpack, rawget, rawset,
pcall, type, table, string

local function init(types)

local abi = require "syscall.abi"

local t, pt, s, ctypes = types.t, types.pt, types.s, types.ctypes

local ffi = require "ffi"
local bit = require "syscall.bit"

local i6432, u6432 = bit.i6432, bit.u6432

local h = require "syscall.helpers"

local addtype, addtype_var, addtype_fn, addraw2 = h.addtype, h.addtype_var, h.addtype_fn, h.addraw2
local ptt, reviter, mktype, istype, lenfn, lenmt, getfd, newfn
  = h.ptt, h.reviter, h.mktype, h.istype, h.lenfn, h.lenmt, h.getfd, h.newfn
local ntohl, ntohl, ntohs, htons, octal = h.ntohl, h.ntohl, h.ntohs, h.htons, h.octal

local c = require "syscall.netbsd.constants"

local mt = {} -- metatables

local addtypes = {
  fdset = "fd_set",
  clockid = "clockid_t",
  register = "register_t",
}

local addstructs = {
  ufs_args = "struct ufs_args",
  tmpfs_args = "struct tmpfs_args",
  ptyfs_args = "struct ptyfs_args",
  procfs_args = "struct procfs_args",
  statvfs = "struct statvfs",
  kfilter_mapping = "struct kfilter_mapping",
  in6_ifstat = "struct in6_ifstat",
  icmp6_ifstat = "struct icmp6_ifstat",
  in6_ifreq = "struct in6_ifreq",
  in6_addrlifetime = "struct in6_addrlifetime",
}

if abi.netbsd.version == 6 then
  addstructs.ptmget = "struct compat_60_ptmget"
else
  addstructs.ptmget = "struct ptmget"
end

for k, v in pairs(addtypes) do addtype(types, k, v) end
for k, v in pairs(addstructs) do addtype(types, k, v, lenmt) end

-- 64 bit dev_t
local function makedev(major, minor)
  local dev = t.dev(major or 0)
  if minor then
    local low = bit.bor(bit.band(minor, 0xff), bit.lshift(bit.band(major, 0xfff), 8), bit.lshift(bit.band(minor, bit.bnot(0xff)), 12))
    local high = bit.band(major, bit.bnot(0xfff))
    dev = t.dev(low) + 0x100000000ULL * t.dev(high)
  end
  return dev
end

mt.device = {
  index = {
    major = function(dev)
      local h, l = i6432(dev.dev)
      return bit.bor(bit.band(bit.rshift(l, 8), 0xfff), bit.band(h, bit.bnot(0xfff)))
    end,
    minor = function(dev)
      local h, l = i6432(dev.dev)
      return bit.bor(bit.band(l, 0xff), bit.band(bit.rshift(l, 12), bit.bnot(0xff)))
    end,
    device = function(dev) return tonumber(dev.dev) end,
  },
  newindex = {
    device = function(dev, major, minor) dev.dev = makedev(major, minor) end,
  },
  __new = function(tp, major, minor)
    return ffi.new(tp, makedev(major, minor))
  end,
}

addtype(types, "device", "struct {dev_t dev;}", mt.device)

mt.stat = {
  index = {
    dev = function(st) return t.device(st.st_dev) end,
    mode = function(st) return st.st_mode end,
    ino = function(st) return tonumber(st.st_ino) end,
    nlink = function(st) return st.st_nlink end,
    uid = function(st) return st.st_uid end,
    gid = function(st) return st.st_gid end,
    rdev = function(st) return t.device(st.st_rdev) end,
    atime = function(st) return st.st_atimespec.time end,
    ctime = function(st) return st.st_ctimespec.time end,
    mtime = function(st) return st.st_mtimespec.time end,
    birthtime = function(st) return st.st_birthtimespec.time end,
    size = function(st) return tonumber(st.st_size) end,
    blocks = function(st) return tonumber(st.st_blocks) end,
    blksize = function(st) return tonumber(st.st_blksize) end,
    flags = function(st) return st.st_flags end,
    gen = function(st) return st.st_gen end,

    type = function(st) return bit.band(st.st_mode, c.S_I.FMT) end,
    todt = function(st) return bit.rshift(st.type, 12) end,
    isreg = function(st) return st.type == c.S_I.FREG end, -- TODO allow upper case too?
    isdir = function(st) return st.type == c.S_I.FDIR end,
    ischr = function(st) return st.type == c.S_I.FCHR end,
    isblk = function(st) return st.type == c.S_I.FBLK end,
    isfifo = function(st) return st.type == c.S_I.FIFO end,
    islnk = function(st) return st.type == c.S_I.FLNK end,
    issock = function(st) return st.type == c.S_I.FSOCK end,
    iswht = function(st) return st.type == c.S_I.FWHT end,
  },
}

addtype(types, "stat", "struct stat", mt.stat)

mt.siginfo = {
  index = {
    signo   = function(s) return s._info._signo end,
    code    = function(s) return s._info._code end,
    errno   = function(s) return s._info._errno end,
    value   = function(s) return s._info._reason._rt._value end,
    pid     = function(s) return s._info._reason._child._pid end,
    uid     = function(s) return s._info._reason._child._uid end,
    status  = function(s) return s._info._reason._child._status end,
    utime   = function(s) return s._info._reason._child._utime end,
    stime   = function(s) return s._info._reason._child._stime end,
    addr    = function(s) return s._info._reason._fault._addr end,
    band    = function(s) return s._info._reason._poll._band end,
    fd      = function(s) return s._info._reason._poll._fd end,
  },
  newindex = {
    signo   = function(s, v) s._info._signo = v end,
    code    = function(s, v) s._info._code = v end,
    errno   = function(s, v) s._info._errno = v end,
    value   = function(s, v) s._info._reason._rt._value = v end,
    pid     = function(s, v) s._info._reason._child._pid = v end,
    uid     = function(s, v) s._info._reason._child._uid = v end,
    status  = function(s, v) s._info._reason._child._status = v end,
    utime   = function(s, v) s._info._reason._child._utime = v end,
    stime   = function(s, v) s._info._reason._child._stime = v end,
    addr    = function(s, v) s._info._reason._fault._addr = v end,
    band    = function(s, v) s._info._reason._poll._band = v end,
    fd      = function(s, v) s._info._reason._poll._fd = v end,
  },
}

addtype(types, "siginfo", "siginfo_t", mt.siginfo)

-- sigaction, standard POSIX behaviour with union of handler and sigaction
addtype_fn(types, "sa_sigaction", "void (*)(int, siginfo_t *, void *)")

mt.sigaction = {
  index = {
    handler = function(sa) return sa._sa_u._sa_handler end,
    sigaction = function(sa) return sa._sa_u._sa_sigaction end,
    mask = function(sa) return sa.sa_mask end,
    flags = function(sa) return tonumber(sa.sa_flags) end,
  },
  newindex = {
    handler = function(sa, v)
      if type(v) == "string" then v = pt.void(c.SIGACT[v]) end
      if type(v) == "number" then v = pt.void(v) end
      sa._sa_u._sa_handler = v
    end,
    sigaction = function(sa, v)
      if type(v) == "string" then v = pt.void(c.SIGACT[v]) end
      if type(v) == "number" then v = pt.void(v) end
      sa._sa_u._sa_sigaction = v
    end,
    mask = function(sa, v)
      if not ffi.istype(t.sigset, v) then v = t.sigset(v) end
      sa.sa_mask = v
    end,
    flags = function(sa, v) sa.sa_flags = c.SA[v] end,
  },
  __new = function(tp, tab)
    local sa = ffi.new(tp)
    if tab then for k, v in pairs(tab) do sa[k] = v end end
    if tab and tab.sigaction then sa.sa_flags = bit.bor(sa.flags, c.SA.SIGINFO) end -- this flag must be set if sigaction set
    return sa
  end,
}

addtype(types, "sigaction", "struct sigaction", mt.sigaction)

mt.dirent = {
  index = {
    fileno = function(self) return tonumber(self.d_fileno) end,
    reclen = function(self) return self.d_reclen end,
    namlen = function(self) return self.d_namlen end,
    type = function(self) return self.d_type end,
    name = function(self) return ffi.string(self.d_name, self.d_namlen) end,
    toif = function(self) return bit.lshift(self.d_type, 12) end, -- convert to stat types
  },
  __len = function(self) return self.d_reclen end,
}

mt.dirent.index.ino = mt.dirent.index.fileno -- alternate name

-- TODO previously this allowed lower case values, but this static version does not
-- could add mt.dirent.index[tolower(k)] = mt.dirent.index[k] but need to do consistently elsewhere
for k, v in pairs(c.DT) do
  mt.dirent.index[k] = function(self) return self.type == v end
end

addtype(types, "dirent", "struct dirent", mt.dirent)

mt.ifreq = {
  index = {
    name = function(ifr) return ffi.string(ifr.ifr_name) end,
    addr = function(ifr) return ifr.ifr_ifru.ifru_addr end,
    dstaddr = function(ifr) return ifr.ifr_ifru.ifru_dstaddr end,
    broadaddr = function(ifr) return ifr.ifr_ifru.ifru_broadaddr end,
    space = function(ifr) return ifr.ifr_ifru.ifru_space end,
    flags = function(ifr) return ifr.ifr_ifru.ifru_flags end,
    metric = function(ifr) return ifr.ifr_ifru.ifru_metric end,
    mtu = function(ifr) return ifr.ifr_ifru.ifru_mtu end,
    dlt = function(ifr) return ifr.ifr_ifru.ifru_dlt end,
    value = function(ifr) return ifr.ifr_ifru.ifru_value end,
    -- TODO rest of fields (buf, buflen)
  },
  newindex = {
    name = function(ifr, v)
      assert(#v < c.IFNAMSIZ, "name too long")
      ifr.ifr_name = v
    end,
    flags = function(ifr, v)
      ifr.ifr_ifru.ifru_flags = c.IFF[v]
    end,
    -- TODO rest of fields
  },
  __new = newfn,
}

addtype(types, "ifreq", "struct ifreq", mt.ifreq)

mt.ifaliasreq = {
  index = {
    name = function(ifra) return ffi.string(ifra.ifra_name) end,
    addr = function(ifra) return ifra.ifra_addr end,
    dstaddr = function(ifra) return ifra.ifra_dstaddr end,
    mask = function(ifra) return ifra.ifra_mask end,
  },
  newindex = {
    name = function(ifra, v)
      assert(#v < c.IFNAMSIZ, "name too long")
      ifra.ifra_name = v
    end,
    addr = function(ifra, v) ifra.ifra_addr = mktype(t.sockaddr, v) end,
    dstaddr = function(ifra, v) ifra.ifra_dstaddr = mktype(t.sockaddr, v) end,
    mask = function(ifra, v) ifra.ifra_mask = v end, -- TODO mask in form of sockaddr
  },
  __new = newfn,
}

mt.ifaliasreq.index.broadaddr = mt.ifaliasreq.index.dstaddr
mt.ifaliasreq.newindex.broadaddr = mt.ifaliasreq.newindex.dstaddr

addtype(types, "ifaliasreq", "struct ifaliasreq", mt.ifaliasreq)

mt.in6_aliasreq = {
  index = {
    name = function(ifra) return ffi.string(ifra.ifra_name) end,
    addr = function(ifra) return ifra.ifra_addr end,
    dstaddr = function(ifra) return ifra.ifra_dstaddr end,
    prefixmask = function(ifra) return ifra.ifra_prefixmask end,
    lifetime = function(ifra) return ifra.ifra_lifetime end,
  },
  newindex = {
    name = function(ifra, v)
      assert(#v < c.IFNAMSIZ, "name too long")
      ifra.ifra_name = v
    end,
    addr = function(ifra, v) ifra.ifra_addr = mktype(t.sockaddr_in6, v) end,
    dstaddr = function(ifra, v) ifra.ifra_dstaddr = mktype(t.sockaddr_in6, v) end,
    mask = function(ifra, v) ifra.ifra_prefixmask = v end, -- TODO mask in form of sockaddr
    lifetime = function(ifra, v) ifra.ifra_lifetime = v end,
  },
  __new = newfn,
}

addtype(types, "in6_aliasreq", "struct in6_aliasreq", mt.in6_aliasreq)

mt.kevent = {
  index = {
    size = function(kev) return tonumber(kev.data) end,
    fd = function(kev) return tonumber(kev.ident) end,
  },
  newindex = {
    fd = function(kev, v) kev.ident = t.uintptr(getfd(v)) end,
    -- due to naming, use 'set' names TODO better naming scheme reads oddly as not a function
    setflags = function(kev, v) kev.flags = c.EV[v] end,
    setfilter = function(kev, v) kev.filter = c.EVFILT[v] end,
  },
  __new = function(tp, tab)
    if type(tab) == "table" then
      tab.flags = c.EV[tab.flags]
      tab.filter = c.EVFILT[tab.filter] -- TODO this should also support extra ones via ioctl see man page
      tab.fflags = c.NOTE[tab.fflags]
    end
    local obj = ffi.new(tp)
    for k, v in pairs(tab or {}) do obj[k] = v end
    return obj
  end,
}

for k, v in pairs(c.NOTE) do
  mt.kevent.index[k] = function(kev) return bit.band(kev.fflags, v) ~= 0 end
end

for _, k in pairs{"FLAG1", "EOF", "ERROR"} do
  mt.kevent.index[k] = function(kev) return bit.band(kev.flags, c.EV[k]) ~= 0 end
end

addtype(types, "kevent", "struct kevent", mt.kevent)

mt.kevents = {
  __len = function(kk) return kk.count end,
  __new = function(tp, ks)
    if type(ks) == 'number' then return ffi.new(tp, ks, ks) end
    local count = #ks
    local kks = ffi.new(tp, count, count)
    for n = 1, count do -- TODO ideally we use ipairs on both arrays/tables
      local v = mktype(t.kevent, ks[n])
      kks.kev[n - 1] = v
    end
    return kks
  end,
  __ipairs = function(kk) return reviter, kk.kev, kk.count end
}

addtype_var(types, "kevents", "struct {int count; struct kevent kev[?];}", mt.kevents)

local ktr_type = {}
for k, v in pairs(c.KTR) do ktr_type[v] = k end

local ktr_val_tp = {
  SYSCALL = "ktr_syscall",
  SYSRET = "ktr_sysret",
  NAMEI = "string",
  -- TODO GENIO
  -- TODO PSIG
  CSW = "ktr_csw",
  EMUL = "string",
  -- TODO USER
  EXEC_ARG = "string",
  EXEC_ENV = "string",
  -- TODO SAUPCALL
  MIB = "string",
  -- TODO EXEC_FD
}

mt.ktr_header = {
  index = {
    len = function(ktr) return ktr.ktr_len end,
    version = function(ktr) return ktr.ktr_version end,
    type = function(ktr) return ktr.ktr_type end,
    typename = function(ktr) return ktr_type[ktr.ktr_type] end,
    pid = function(ktr) return ktr.ktr_pid end,
    comm = function(ktr) return ffi.string(ktr.ktr_comm) end,
    lid = function(ktr) return ktr._v._v2._lid end,
    olid = function(ktr) return ktr._v._v1._lid end,
    time = function(ktr) return ktr._v._v2._ts end,
    otv = function(ktr) return ktr._v._v0._tv end,
    ots = function(ktr) return ktr._v._v1._ts end,
    unused = function(ktr) return ktr._v._v0._buf end,
    valptr = function(ktr) return pt.char(ktr) + s.ktr_header end, -- assumes ktr is a pointer
    values = function(ktr)
      if not ktr.typename then return "bad ktrace type" end
      local tpnam = ktr_val_tp[ktr.typename]
      if not tpnam then return "unimplemented ktrace type" end
      if tpnam == "string" then return ffi.string(ktr.valptr, ktr.len) end
      return pt[tpnam](ktr.valptr)
    end,
  },
  __len = function(ktr) return s.ktr_header + ktr.len end,
  __tostring = function(ktr)
    return ktr.pid .. " " .. ktr.comm .. " " .. (ktr.typename or "??") .. " " .. tostring(ktr.values)
  end,
}

addtype(types, "ktr_header", "struct ktr_header", mt.ktr_header)

local sysname = {}
for k, v in pairs(c.SYS) do sysname[v] = k end

local ioctlname

-- TODO this is a temporary hack, needs better code
local special = {
  ioctl = function(fd, request, val)
    if not ioctlname then
      ioctlname = {}
      local IOCTL = require "syscall.netbsd.constants".IOCTL -- see #94 as well, we cannot load early as ioctl depends on types
      for k, v in pairs(IOCTL) do
        if type(v) == "table" then v = v.number end
        v = tonumber(v)
        if v then ioctlname[v] = k end
      end
    end
    fd = tonumber(t.int(fd))
    request = tonumber(t.int(request))
    val = tonumber(val)
    local ionm = ioctlname[request] or tostring(request)
    return tostring(fd) .. ", " .. ionm .. ", " .. tostring(val)
  end,
}

mt.ktr_syscall = {
  index = {
    code = function(ktr) return ktr.ktr_code end,
    name = function(ktr) return sysname[ktr.code] or tostring(ktr.code) end,
    argsize = function(ktr) return ktr.ktr_argsize end,
    nreg = function(ktr) return ktr.argsize / s.register end,
    registers = function(ktr) return pt.register(pt.char(ktr) + s.ktr_syscall) end -- assumes ktr is a pointer
  },
  __len = function(ktr) return s.ktr_syscall + ktr.argsize end,
  __tostring = function(ktr)
    local rtab = {}
    for i = 0, ktr.nreg - 1 do rtab[i + 1] = tostring(ktr.registers[i]) end
    if special[ktr.name] then
      for i = 0, ktr.nreg - 1 do rtab[i + 1] = ktr.registers[i] end
      return ktr.name .. " (" .. special[ktr.name](unpack(rtab)) .. ")"
    end
    for i = 0, ktr.nreg - 1 do rtab[i + 1] = tostring(ktr.registers[i]) end
    return ktr.name .. " (" .. table.concat(rtab, ",") .. ")"
  end,
}

addtype(types, "ktr_syscall", "struct ktr_syscall", mt.ktr_syscall)

mt.ktr_sysret = {
  index = {
    code = function(ktr) return ktr.ktr_code end,
    name = function(ktr) return sysname[ktr.code] or tostring(ktr.code) end,
    error = function(ktr) if ktr.ktr_error ~= 0 then return t.error(ktr.ktr_error) end end,
    retval = function(ktr) return ktr.ktr_retval end,
    retval1 = function(ktr) return ktr.ktr_retval_1 end,
  },
  __tostring = function(ktr)
    if ktr.error then
      return ktr.name .. " " .. (ktr.error.sym or ktr.error.errno) .. " " .. (tostring(ktr.error) or "")
    else
      return ktr.name .. " " .. tostring(ktr.retval) .. " " .. tostring(ktr.retval1) .. " "
    end
  end
}

addtype(types, "ktr_sysret", "struct ktr_sysret", mt.ktr_sysret)

mt.ktr_csw = {
  __tostring = function(ktr)
    return "context switch" -- TODO
  end,
}

addtype(types, "ktr_csw", "struct ktr_csw", mt.ktr_csw)

-- slightly miscellaneous types, eg need to use Lua metatables

-- TODO see Linux notes
mt.wait = {
  __index = function(w, k)
    local _WSTATUS = bit.band(w.status, octal("0177"))
    local _WSTOPPED = octal("0177")
    local WTERMSIG = _WSTATUS
    local EXITSTATUS = bit.band(bit.rshift(w.status, 8), 0xff)
    local WIFEXITED = (_WSTATUS == 0)
    local tab = {
      WIFEXITED = WIFEXITED,
      WIFSTOPPED = bit.band(w.status, 0xff) == _WSTOPPED,
      WIFSIGNALED = _WSTATUS ~= _WSTOPPED and _WSTATUS ~= 0
    }
    if tab.WIFEXITED then tab.EXITSTATUS = EXITSTATUS end
    if tab.WIFSTOPPED then tab.WSTOPSIG = EXITSTATUS end
    if tab.WIFSIGNALED then tab.WTERMSIG = WTERMSIG end
    if tab[k] then return tab[k] end
    local uc = 'W' .. k:upper()
    if tab[uc] then return tab[uc] end
  end
}

function t.waitstatus(status)
  return setmetatable({status = status}, mt.wait)
end

mt.ifdrv = {
  index = {
    name = function(self) return ffi.string(self.ifd_name) end,
  },
  newindex = {
    name = function(self, v)
      assert(#v < c.IFNAMSIZ, "name too long")
      self.ifd_name = v
    end,
    cmd = function(self, v) self.ifd_cmd = v end, -- TODO which namespace(s)?
    data = function(self, v)
      self.ifd_data = v
      self.ifd_len = #v
    end,
    len = function(self, v) self.ifd_len = v end,
  },
  __new = newfn,
}

addtype(types, "ifdrv", "struct ifdrv", mt.ifdrv)

mt.ifbreq = {
  index = {
    ifsname = function(self) return ffi.string(self.ifbr_ifsname) end,
  },
  newindex = {
    ifsname = function(self, v)
      assert(#v < c.IFNAMSIZ, "name too long")
      self.ifbr_ifsname = v
    end,
  },
  __new = newfn,
}

addtype(types, "ifbreq", "struct ifbreq", mt.ifbreq)

mt.flock = {
  index = {
    type = function(self) return self.l_type end,
    whence = function(self) return self.l_whence end,
    start = function(self) return self.l_start end,
    len = function(self) return self.l_len end,
    pid = function(self) return self.l_pid end,
  },
  newindex = {
    type = function(self, v) self.l_type = c.FCNTL_LOCK[v] end,
    whence = function(self, v) self.l_whence = c.SEEK[v] end,
    start = function(self, v) self.l_start = v end,
    len = function(self, v) self.l_len = v end,
    pid = function(self, v) self.l_pid = v end,
  },
  __new = newfn,
}

addtype(types, "flock", "struct flock", mt.flock)

return types

end

return {init = init}

