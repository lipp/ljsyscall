-- NetBSD syscall numbers

local nr = {
  SYS = {
  syscall = 0,
  exit = 1,
  fork = 2,
  read = 3,
  write = 4,
  open = 5,
  close = 6,
  compat_50_wait4 = 7,
  compat_43_ocreat = 8,
  link = 9,
  unlink = 10,
  chdir = 12,
  fchdir = 13,
  compat_50_mknod = 14,
  chmod = 15,
  chown = 16,
  ["break"] = 17,
  compat_20_getfsstat = 18,
  compat_43_olseek = 19,
  getpid = 20,
  compat_40_mount = 21,
  unmount = 22,
  setuid = 23,
  getuid = 24,
  geteuid = 25,
  ptrace = 26,
  recvmsg = 27,
  sendmsg = 28,
  recvfrom = 29,
  accept = 30,
  getpeername = 31,
  getsockname = 32,
  access = 33,
  chflags = 34,
  fchflags = 35,
  sync = 36,
  kill = 37,
  compat_43_stat43 = 38,
  getppid = 39,
  compat_43_lstat43 = 40,
  dup = 41,
  pipe = 42,
  getegid = 43,
  profil = 44,
  ktrace = 45,
  compat_13_sigaction13 = 46,
  getgid = 47,
  compat_13_sigprocmask13 = 48,
  __getlogin = 49,
  __setlogin = 50,
  acct = 51,
  compat_13_sigpending13 = 52,
  compat_13_sigaltstack13 = 53,
  ioctl = 54,
  compat_12_oreboot = 55,
  revoke = 56,
  symlink = 57,
  readlink = 58,
  execve = 59,
  umask = 60,
  chroot = 61,
  compat_43_fstat43 = 62,
  compat_43_ogetkerninfo = 63,
  compat_43_ogetpagesize = 64,
  compat_12_msync = 65,
  vfork = 66,
  sbrk = 69,
  sstk = 70,
  compat_43_ommap = 71,
  vadvise = 72,
  munmap = 73,
  mprotect = 74,
  madvise = 75,
  mincore = 78,
  getgroups = 79,
  setgroups = 80,
  getpgrp = 81,
  setpgid = 82,
  compat_50_setitimer = 83,
  compat_43_owait = 84,
  compat_12_oswapon = 85,
  compat_50_getitimer = 86,
  compat_43_ogethostname = 87,
  compat_43_osethostname = 88,
  compat_43_ogetdtablesize = 89,
  dup2 = 90,
  fcntl = 92,
  compat_50_select = 93,
  fsync = 95,
  setpriority = 96,
  compat_30_socket = 97,
  connect = 98,
  compat_43_oaccept = 99,
  getpriority = 100,
  compat_43_osend = 101,
  compat_43_orecv = 102,
  compat_13_sigreturn13 = 103,
  bind = 104,
  setsockopt = 105,
  listen = 106,
  compat_43_osigvec = 108,
  compat_43_osigblock = 109,
  compat_43_osigsetmask = 110,
  compat_13_sigsuspend13 = 111,
  compat_43_osigstack = 112,
  compat_43_orecvmsg = 113,
  compat_43_osendmsg = 114,
  compat_50_gettimeofday = 116,
  compat_50_getrusage = 117,
  getsockopt = 118,
  readv = 120,
  writev = 121,
  compat_50_settimeofday = 122,
  fchown = 123,
  fchmod = 124,
  compat_43_orecvfrom = 125,
  setreuid = 126,
  setregid = 127,
  rename = 128,
  compat_43_otruncate = 129,
  compat_43_oftruncate = 130,
  flock = 131,
  mkfifo = 132,
  sendto = 133,
  shutdown = 134,
  socketpair = 135,
  mkdir = 136,
  rmdir = 137,
  compat_50_utimes = 138,
  compat_50_adjtime = 140,
  compat_43_ogetpeername = 141,
  compat_43_ogethostid = 142,
  compat_43_osethostid = 143,
  compat_43_ogetrlimit = 144,
  compat_43_osetrlimit = 145,
  compat_43_okillpg = 146,
  setsid = 147,
  compat_50_quotactl = 148,
  compat_43_oquota = 149,
  compat_43_ogetsockname = 150,
  nfssvc = 155,
  compat_43_ogetdirentries = 156,
  compat_20_statfs = 157,
  compat_20_fstatfs = 158,
  compat_30_getfh = 161,
  compat_09_ogetdomainname = 162,
  compat_09_osetdomainname = 163,
  compat_09_ouname = 164,
  sysarch = 165,
  compat_10_osemsys = 169,
  compat_10_omsgsys = 170,
  compat_10_oshmsys = 171,
  pread = 173,
  pwrite = 174,
  compat_30_ntp_gettime = 175,
  ntp_adjtime = 176,
  setgid = 181,
  setegid = 182,
  seteuid = 183,
  lfs_bmapv = 184,
  lfs_markv = 185,
  lfs_segclean = 186,
  compat_50_lfs_segwait = 187,
  compat_12_stat12 = 188,
  compat_12_fstat12 = 189,
  }
}

return nr
