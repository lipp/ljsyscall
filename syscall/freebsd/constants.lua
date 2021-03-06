-- tables of constants for NetBSD

local require, error, assert, tonumber, tostring,
setmetatable, pairs, ipairs, unpack, rawget, rawset,
pcall, type, table, string = 
require, error, assert, tonumber, tostring,
setmetatable, pairs, ipairs, unpack, rawget, rawset,
pcall, type, table, string

local abi = require "syscall.abi"

local h = require "syscall.helpers"

local bit = require "syscall.bit"

local octal, multiflags, charflags, swapflags, strflag, atflag, modeflags
  = h.octal, h.multiflags, h.charflags, h.swapflags, h.strflag, h.atflag, h.modeflags

local c = {}

c.errornames = require "syscall.freebsd.errors"

c.STD = strflag {
  IN_FILENO = 0,
  OUT_FILENO = 1,
  ERR_FILENO = 2,
  IN = 0,
  OUT = 1,
  ERR = 2,
}

c.PATH_MAX = 1024

c.E = strflag {
  PERM          =  1,
  NOENT         =  2,
  SRCH          =  3,
  INTR          =  4,
  IO            =  5,
  NXIO          =  6,
  ["2BIG"]      =  7,
  NOEXEC        =  8,
  BADF          =  9,
  CHILD         = 10,
  DEADLK        = 11,
  NOMEM         = 12,
  ACCES         = 13,
  FAULT         = 14,
  NOTBLK        = 15,
  BUSY          = 16,
  EXIST         = 17,
  XDEV          = 18,
  NODEV         = 19,
  NOTDIR        = 20,
  ISDIR         = 21,
  INVAL         = 22,
  NFILE         = 23,
  MFILE         = 24,
  NOTTY         = 25,
  TXTBSY        = 26,
  FBIG          = 27,
  NOSPC         = 28,
  SPIPE         = 29,
  ROFS          = 30,
  MLINK         = 31,
  PIPE          = 32,
  DOM           = 33,
  RANGE         = 34,
  AGAIN         = 35,
  INPROGRESS    = 36,
  ALREADY       = 37,
  NOTSOCK       = 38,
  DESTADDRREQ   = 39,
  MSGSIZE       = 40,
  PROTOTYPE     = 41,
  NOPROTOOPT    = 42,
  PROTONOSUPPORT= 43,
  SOCKTNOSUPPORT= 44,
  OPNOTSUPP     = 45,
  PFNOSUPPORT   = 46,
  AFNOSUPPORT   = 47,
  ADDRINUSE     = 48,
  ADDRNOTAVAIL  = 49,
  NETDOWN       = 50,
  NETUNREACH    = 51,
  NETRESET      = 52,
  CONNABORTED   = 53,
  CONNRESET     = 54,
  NOBUFS        = 55,
  ISCONN        = 56,
  NOTCONN       = 57,
  SHUTDOWN      = 58,
  TOOMANYREFS   = 59,
  TIMEDOUT      = 60,
  CONNREFUSED   = 61,
  LOOP          = 62,
  NAMETOOLONG   = 63,
  HOSTDOWN      = 64,
  HOSTUNREACH   = 65,
  NOTEMPTY      = 66,
  PROCLIM       = 67,
  USERS         = 68,
  DQUOT         = 69,
  STALE         = 70,
  REMOTE        = 71,
  BADRPC        = 72,
  BADRPC        = 72,
  RPCMISMATCH   = 73,
  PROGUNAVAIL   = 74,
  PROGMISMATCH  = 75,
  PROCUNAVAIL   = 76,
  NOLCK         = 77,
  NOSYS         = 78,
  FTYPE         = 79,
  AUTH          = 80,
  NEEDAUTH      = 81,
  IDRM          = 82,
  NOMSG         = 83,
  OVERFLOW      = 84,
  CANCELED      = 85,
  ILSEQ         = 86,
  NOATTR        = 87,
  DOOFUS        = 88,
  BADMSG        = 89,
  MULTIHOP      = 90,
  NOLINK        = 91,
  PROTO         = 92,
  NOTCAPABLE    = 93,
  CAPMODE       = 94,
  NOTRECOVERABLE= 95,
  OWNERDEAD     = 96,
}

-- alternate names
c.E.WOULDBLOCK    = c.E.AGAIN

c.AF = strflag {
  UNSPEC      = 0,
  LOCAL       = 1,
  INET        = 2,
  IMPLINK     = 3,
  PUP         = 4,
  CHAOS       = 5,
  NETBIOS     = 6,
  ISO         = 7,
  ECMA        = 8,
  DATAKIT     = 9,
  CCITT       = 10,
  SNA         = 11,
  DECNET      = 12,
  DLI         = 13,
  LAT         = 14,
  HYLINK      = 15,
  APPLETALK   = 16,
  ROUTE       = 17,
  LINK        = 18,
-- #define pseudo_AF_XTP   19
  COIP        = 20,
  CNT         = 21,
-- #define pseudo_AF_RTIP  22
  IPX         = 23,
  SIP         = 24,
-- pseudo_AF_PIP   25
  ISDN        = 26,
-- pseudo_AF_KEY   27
  INET6       = 28,
  NATM        = 29,
  ATM         = 30,
-- pseudo_AF_HDRCMPLT 31
  NETGRAPH    = 32,
  SLOW        = 33,
  SCLUSTER    = 34,
  ARP         = 35,
  BLUETOOTH   = 36,
  IEEE80211   = 37,
  INET_SDP    = 40,
  INET6_SDP   = 42,
}

c.AF.UNIX = c.AF.LOCAL
c.AF.OSI = c.AF.ISO
c.AF.E164 = c.AF.ISDN

c.O = multiflags {
  RDONLY      = 0x0000,
  WRONLY      = 0x0001,
  RDWR        = 0x0002,
  ACCMODE     = 0x0003,
  NONBLOCK    = 0x0004,
  APPEND      = 0x0008,
  SHLOCK      = 0x0010,
  EXLOCK      = 0x0020,
  ASYNC       = 0x0040,
  FSYNC       = 0x0080,
  SYNC        = 0x0080,
  NOFOLLOW    = 0x0100,
  CREAT       = 0x0200,
  TRUNC       = 0x0400,
  EXCL        = 0x0800,
  NOCTTY      = 0x8000,
  DIRECT      = 0x00010000,
  DIRECTORY   = 0x00020000,
  EXEC        = 0x00040000,
  TTY_INIT    = 0x00080000,
  CLOEXEC     = 0x00100000,
}

-- for pipe2, selected flags from c.O
c.OPIPE = multiflags {
  NONBLOCK  = 0x0004,
  CLOEXEC   = 0x00100000,
}

-- sigaction, note renamed SIGACT from SIG_
c.SIGACT = strflag {
  ERR = -1,
  DFL =  0,
  IGN =  1,
  HOLD = 3,
}

c.SIG = strflag {
  HUP = 1,
  INT = 2,
  QUIT = 3,
  ILL = 4,
  TRAP = 5,
  ABRT = 6,
  EMT = 7,
  FPE = 8,
  KILL = 9,
  BUS = 10,
  SEGV = 11,
  SYS = 12,
  PIPE = 13,
  ALRM = 14,
  TERM = 15,
  URG = 16,
  STOP = 17,
  TSTP = 18,
  CONT = 19,
  CHLD = 20,
  TTIN = 21,
  TTOU = 22,
  IO   = 23,
  XCPU = 24,
  XFSZ = 25,
  VTALRM = 26,
  PROF = 27,
  WINCH = 28,
  INFO = 29,
  USR1 = 30,
  USR2 = 31,
  THR = 32,
  LIBRT = 33,
}

c.SIG.LWP = c.SIG.THR

c.EXIT = strflag {
  SUCCESS = 0,
  FAILURE = 1,
}

c.OK = charflags {
  F = 0,
  X = 0x01,
  W = 0x02,
  R = 0x04,
}

c.MODE = modeflags {
  SUID = octal('04000'),
  SGID = octal('02000'),
  STXT = octal('01000'),
  RWXU = octal('00700'),
  RUSR = octal('00400'),
  WUSR = octal('00200'),
  XUSR = octal('00100'),
  RWXG = octal('00070'),
  RGRP = octal('00040'),
  WGRP = octal('00020'),
  XGRP = octal('00010'),
  RWXO = octal('00007'),
  ROTH = octal('00004'),
  WOTH = octal('00002'),
  XOTH = octal('00001'),
}

c.SEEK = strflag {
  SET  = 0,
  CUR  = 1,
  END  = 2,
  DATA = 3,
  HOLE = 4,
}

c.SOCK = multiflags {
  STREAM    = 1,
  DGRAM     = 2,
  RAW       = 3,
  RDM       = 4,
  SEQPACKET = 5,
  CLOEXEC   = 0x10000000,
  NONBLOCK  = 0x20000000,
}

c.SOL = strflag {
  SOCKET    = 0xffff,
}

c.POLL = multiflags {
  IN         = 0x0001,
  PRI        = 0x0002,
  OUT        = 0x0004,
  RDNORM     = 0x0040,
  RDBAND     = 0x0080,
  WRBAND     = 0x0100,
  INIGNEOF   = 0x2000,
  ERR        = 0x0008,
  HUP        = 0x0010,
  NVAL       = 0x0020,
}

c.POLL.WRNORM = c.POLL.OUT
c.POLL.STANDARD = c.POLL["IN,PRI,OUT,RDNORM,RDBAND,WRBAND,ERR,HUP,NVAL"]

c.AT_FDCWD = atflag {
  FDCWD = -100,
}

c.AT = multiflags {
  EACCESS          = 0x100,
  SYMLINK_NOFOLLOW = 0x200,
  SYMLINK_FOLLOW   = 0x400,
  REMOVEDIR        = 0x800,
}

c.S_I = modeflags {
  FMT   = octal('0170000'),
  FWHT  = octal('0160000'),
  FSOCK = octal('0140000'),
  FLNK  = octal('0120000'),
  FREG  = octal('0100000'),
  FBLK  = octal('0060000'),
  FDIR  = octal('0040000'),
  FCHR  = octal('0020000'),
  FIFO  = octal('0010000'),
  SUID  = octal('0004000'),
  SGID  = octal('0002000'),
  SVTX  = octal('0001000'),
  STXT  = octal('0001000'),
  RWXU  = octal('00700'),
  RUSR  = octal('00400'),
  WUSR  = octal('00200'),
  XUSR  = octal('00100'),
  RWXG  = octal('00070'),
  RGRP  = octal('00040'),
  WGRP  = octal('00020'),
  XGRP  = octal('00010'),
  RWXO  = octal('00007'),
  ROTH  = octal('00004'),
  WOTH  = octal('00002'),
  XOTH  = octal('00001'),
}

c.S_I.READ  = c.S_I.RUSR
c.S_I.WRITE = c.S_I.WUSR
c.S_I.EXEC  = c.S_I.XUSR

c.PROT = multiflags {
  NONE  = 0x0,
  READ  = 0x1,
  WRITE = 0x2,
  EXEC  = 0x4,
}

c.MAP = multiflags {
  SHARED     = 0x0001,
  PRIVATE    = 0x0002,
  FILE       = 0x0000,
  FIXED      = 0x0010,
  RENAME     = 0x0020,
  NORESERVE  = 0x0040,
  RESERVED0080 = 0x0080,
  RESERVED0100 = 0x0100,
  HASSEMAPHORE = 0x0200,
  STACK      = 0x0400,
  NOSYNC     = 0x0800,
  ANON       = 0x1000,
  NOCORE     = 0x00020000,
-- TODO add aligned maps in
}

if abi.abi64 then c.MAP["32BIT"] = 0x00080000 end

c.MAP.ANONYMOUS = c.MAP.ANON -- for compatibility

c.MCL = strflag {
  CURRENT    = 0x01,
  FUTURE     = 0x02,
}

-- flags to `msync'. - note was MS_ renamed to MSYNC_
c.MSYNC = multiflags {
  SYNC       = 0x0000,
  ASYNC      = 0x0001,
  INVALIDATE = 0x0002,
}

c.MADV = strflag {
  NORMAL      = 0,
  RANDOM      = 1,
  SEQUENTIAL  = 2,
  WILLNEED    = 3,
  DONTNEED    = 4,
  FREE        = 5,
  NOSYNC      = 6,
  AUTOSYNC    = 7,
  NOCORE      = 8,
  CORE        = 9,
  PROTECT     = 10,
}

c.IPPROTO = strflag {
  HOPOPTS        = 0,
  IGMP           = 2,
  GGP            = 3,
  IPV4           = 4,
  IPIP           = 4,
  ST             = 7,
  EGP            = 8,
  PIGP           = 9,
  RCCMON         = 10,
  NVPII          = 11,
  PUP            = 12,
  ARGUS          = 13,
  EMCON          = 14,
  XNET           = 15,
  CHAOS          = 16,
  MUX            = 18,
  MEAS           = 19,
  HMP            = 20,
  PRM            = 21,
  IDP            = 22,
  TRUNK1         = 23,
  TRUNK2         = 24,
  LEAF1          = 25,
  LEAF2          = 26,
  RDP            = 27,
  IRTP           = 28,
  TP             = 29,
  BLT            = 30,
  NSP            = 31,
  INP            = 32,
  SEP            = 33,
  ["3PC"]        = 34,
  IDPR           = 35,
  XTP            = 36,
  DDP            = 37,
  CMTP           = 38,
  TPXX           = 39,
  IL             = 40,
  IPV6           = 41,
  SDRP           = 42,
  ROUTING        = 43,
  FRAGMENT       = 44,
  IDRP           = 45,
  RSVP           = 46,
  GRE            = 47,
  MHRP           = 48,
  BHA            = 49,
  ESP            = 50,
  AH             = 51,
  INLSP          = 52,
  SWIPE          = 53,
  NHRP           = 54,
  MOBILE         = 55,
  TLSP           = 56,
  SKIP           = 57,
  ICMPV6         = 58,
  NONE           = 59,
  DSTOPTS        = 60,
  AHIP           = 61,
  CFTP           = 62,
  HELLO          = 63,
  SATEXPAK       = 64,
  KRYPTOLAN      = 65,
  RVD            = 66,
  IPPC           = 67,
  ADFS           = 68,
  SATMON         = 69,
  VISA           = 70,
  IPCV           = 71,
  CPNX           = 72,
  CPHB           = 73,
  WSN            = 74,
  PVP            = 75,
  BRSATMON       = 76,
  ND             = 77,
  WBMON          = 78,
  WBEXPAK        = 79,
  EON            = 80,
  VMTP           = 81,
  SVMTP          = 82,
  VINES          = 83,
  TTP            = 84,
  IGP            = 85,
  DGP            = 86,
  TCF            = 87,
  IGRP           = 88,
  OSPFIGP        = 89,
  SRPC           = 90,
  LARP           = 91,
  MTP            = 92,
  AX25           = 93,
  IPEIP          = 94,
  MICP           = 95,
  SCCSP          = 96,
  ETHERIP        = 97,
  ENCAP          = 98,
  APES           = 99,
  GMTP           = 100,
  IPCOMP         = 108,
  SCTP           = 132,
  MH             = 135,
  PIM            = 103,
  CARP           = 112,
  PGM            = 113,
  MPLS           = 137,
  PFSYNC         = 240,
  RAW            = 255,
}

c.SCM = multiflags {
  RIGHTS     = 0x01,
  TIMESTAMP  = 0x02,
  CREDS      = 0x03,
  BINTIME    = 0x04,
}

c.F = strflag {
  DUPFD       = 0,
  GETFD       = 1,
  SETFD       = 2,
  GETFL       = 3,
  SETFL       = 4,
  GETOWN      = 5,
  SETOWN      = 6,
  OGETLK      = 7,
  OSETLK      = 8,
  OSETLKW     = 9,
  DUP2FD      = 10,
  GETLK       = 11,
  SETLK       = 12,
  SETLKW      = 13,
  SETLK_REMOTE= 14,
  READAHEAD   = 15,
  RDAHEAD     = 16,
  DUPFD_CLOEXEC= 17,
  DUP2FD_CLOEXEC= 18,
}

c.FD = multiflags {
  CLOEXEC = 1,
}

-- note changed from F_ to FCNTL_LOCK
c.FCNTL_LOCK = strflag {
  RDLCK = 1,
  UNLCK = 2,
  WRLCK = 3,
  UNLCKSYS = 4,
  CANCEL = 5,
}

-- lockf, changed from F_ to LOCKF_
c.LOCKF = strflag {
  ULOCK = 0,
  LOCK  = 1,
  TLOCK = 2,
  TEST  = 3,
}

-- for flock (2)
c.LOCK = multiflags {
  SH        = 0x01,
  EX        = 0x02,
  NB        = 0x04,
  UN        = 0x08,
}

c.W = multiflags {
  NOHANG      = 1,
  UNTRACED    = 2,
  CONTINUED   = 4,
  NOWAIT      = 8,
  EXITED      = 16,
  TRAPPED     = 32,
  LINUXCLONE  = 0x80000000,
}

c.W.STOPPED = c.W.UNTRACED

-- waitpid and wait4 pid
c.WAIT = strflag {
  ANY      = -1,
  MYPGRP   = 0,
}

c.MSG = multiflags {
  OOB             = 0x1,
  PEEK            = 0x2,
  DONTROUTE       = 0x4,
  EOR             = 0x8,
  TRUNC           = 0x10,
  CTRUNC          = 0x20,
  WAITALL         = 0x40,
  DONTWAIT        = 0x80,
  EOF             = 0x100,
  NOTIFICATION    = 0x2000,
  NBIO            = 0x4000,
  COMPAT          = 0x8000,
  NOSIGNAL        = 0x20000,
  CMSG_CLOEXEC    = 0x40000,
}

c.PC = strflag {
  LINK_MAX          = 1,
  MAX_CANON         = 2,
  MAX_INPUT         = 3,
  NAME_MAX          = 4,
  PATH_MAX          = 5,
  PIPE_BUF          = 6,
  CHOWN_RESTRICTED  = 7,
  NO_TRUNC          = 8,
  VDISABLE          = 9,
  ALLOC_SIZE_MIN    = 10,
  FILESIZEBITS      = 12,
  REC_INCR_XFER_SIZE= 14,
  REC_MAX_XFER_SIZE = 15,
  REC_MIN_XFER_SIZE = 16,
  REC_XFER_ALIGN    = 17,
  SYMLINK_MAX       = 18,
  MIN_HOLE_SIZE     = 21,
  ASYNC_IO          = 53,
  PRIO_IO           = 54,
  SYNC_IO           = 55,
  ACL_EXTENDED      = 59,
  ACL_PATH_MAX      = 60,
  CAP_PRESENT       = 61,
  INF_PRESENT       = 62,
  MAC_PRESENT       = 63,
  ACL_NFS4          = 64,
}

-- getpriority, setpriority flags
c.PRIO = strflag {
  PROCESS = 0,
  PGRP = 1,
  USER = 2,
  MIN = -20, -- TODO useful to have for other OSs
  MAX = 20,
}

c.RUSAGE = strflag {
  SELF     =  0,
  CHILDREN = -1,
  THREAD   = 1,
}

c.SOMAXCONN = 128

c.SO = strflag {
  DEBUG        = 0x0001,
  ACCEPTCONN   = 0x0002,
  REUSEADDR    = 0x0004,
  KEEPALIVE    = 0x0008,
  DONTROUTE    = 0x0010,
  BROADCAST    = 0x0020,
  USELOOPBACK  = 0x0040,
  LINGER       = 0x0080,
  OOBINLINE    = 0x0100,
  REUSEPORT    = 0x0200,
  TIMESTAMP    = 0x0400,
  NOSIGPIPE    = 0x0800,
  ACCEPTFILTER = 0x1000,
  BINTIME      = 0x2000,
  NO_OFFLOAD   = 0x4000,
  NO_DDP       = 0x8000,
  SNDBUF       = 0x1001,
  RCVBUF       = 0x1002,
  SNDLOWAT     = 0x1003,
  RCVLOWAT     = 0x1004,
  SNDTIMEO     = 0x1005,
  RCVTIMEO     = 0x1006,
  ERROR        = 0x1007,
  TYPE         = 0x1008,
  LABEL        = 0x1009,
  PEERLABEL    = 0x1010,
  LISTENQLIMIT = 0x1011,
  LISTENQLEN   = 0x1012,
  LISTENINCQLEN= 0x1013,
  SETFIB       = 0x1014,
  USER_COOKIE  = 0x1015,
  PROTOCOL     = 0x1016,
}

c.SO.PROTOTYPE = c.SO.PROTOCOL

c.DT = strflag {
  UNKNOWN = 0,
  FIFO = 1,
  CHR = 2,
  DIR = 4,
  BLK = 6,
  REG = 8,
  LNK = 10,
  SOCK = 12,
  WHT = 14,
}

c.IP = strflag {
  OPTIONS            = 1,
  HDRINCL            = 2,
  TOS                = 3,
  TTL                = 4,
  RECVOPTS           = 5,
  RECVRETOPTS        = 6,
  RECVDSTADDR        = 7,
  RETOPTS            = 8,
  MULTICAST_IF       = 9,
  MULTICAST_TTL      = 10,
  MULTICAST_LOOP     = 11,
  ADD_MEMBERSHIP     = 12,
  DROP_MEMBERSHIP    = 13,
  MULTICAST_VIF      = 14,
  RSVP_ON            = 15,
  RSVP_OFF           = 16,
  RSVP_VIF_ON        = 17,
  RSVP_VIF_OFF       = 18,
  PORTRANGE          = 19,
  RECVIF             = 20,
  IPSEC_POLICY       = 21,
  FAITH              = 22,
  ONESBCAST          = 23,
  BINDANY            = 24,
  FW_TABLE_ADD       = 40,
  FW_TABLE_DEL       = 41,
  FW_TABLE_FLUSH     = 42,
  FW_TABLE_GETSIZE   = 43,
  FW_TABLE_LIST      = 44,
  FW3                = 48,
  DUMMYNET3          = 49,
  FW_ADD             = 50,
  FW_DEL             = 51,
  FW_FLUSH           = 52,
  FW_ZERO            = 53,
  FW_GET             = 54,
  FW_RESETLOG        = 55,
  FW_NAT_CFG         = 56,
  FW_NAT_DEL         = 57,
  FW_NAT_GET_CONFIG  = 58,
  FW_NAT_GET_LOG     = 59,
  DUMMYNET_CONFIGURE = 60,
  DUMMYNET_DEL       = 61,
  DUMMYNET_FLUSH     = 62,
  DUMMYNET_GET       = 64,
  RECVTTL            = 65,
  MINTTL             = 66,
  DONTFRAG           = 67,
  RECVTOS            = 68,
  ADD_SOURCE_MEMBERSHIP  = 70,
  DROP_SOURCE_MEMBERSHIP = 71,
  BLOCK_SOURCE       = 72,
  UNBLOCK_SOURCE     = 73,
}

c.IP.SENDSRCADDR = c.IP.RECVDSTADDR

-- Baud rates just the identity function  other than EXTA, EXTB
c.B = strflag {
  EXTA = 19200,
  EXTB = 38400,
}

c.CC = strflag {
  VEOF           = 0,
  VEOL           = 1,
  VEOL2          = 2,
  VERASE         = 3,
  VWERASE        = 4,
  VKILL          = 5,
  VREPRINT       = 6,
  VINTR          = 8,
  VQUIT          = 9,
  VSUSP          = 10,
  VDSUSP         = 11,
  VSTART         = 12,
  VSTOP          = 13,
  VLNEXT         = 14,
  VDISCARD       = 15,
  VMIN           = 16,
  VTIME          = 17,
  VSTATUS        = 18,
}

c.IFLAG = multiflags {
  IGNBRK         = 0x00000001,
  BRKINT         = 0x00000002,
  IGNPAR         = 0x00000004,
  PARMRK         = 0x00000008,
  INPCK          = 0x00000010,
  ISTRIP         = 0x00000020,
  INLCR          = 0x00000040,
  IGNCR          = 0x00000080,
  ICRNL          = 0x00000100,
  IXON           = 0x00000200,
  IXOFF          = 0x00000400,
  IXANY          = 0x00000800,
  IMAXBEL        = 0x00002000,
}

c.OFLAG = multiflags {
  OPOST          = 0x00000001,
  ONLCR          = 0x00000002,
  OXTABS         = 0x00000004,
  ONOEOT         = 0x00000008,
  OCRNL          = 0x00000010,
  ONOCR          = 0x00000020,
  ONLRET         = 0x00000040,
}

c.CFLAG = multiflags {
  CIGNORE        = 0x00000001,
  CSIZE          = 0x00000300,
  CS5            = 0x00000000,
  CS6            = 0x00000100,
  CS7            = 0x00000200,
  CS8            = 0x00000300,
  CSTOPB         = 0x00000400,
  CREAD          = 0x00000800,
  PARENB         = 0x00001000,
  PARODD         = 0x00002000,
  HUPCL          = 0x00004000,
  CLOCAL         = 0x00008000,
  CCTS_OFLOW     = 0x00010000,
  CRTS_IFLOW     = 0x00020000,
  CDTR_IFLOW     = 0x00040000,
  CDSR_OFLOW     = 0x00080000,
  CCAR_OFLOW     = 0x00100000,
}

c.CFLAG.CRTSCTS	= c.CFLAG.CCTS_OFLOW + c.CFLAG.CRTS_IFLOW

c.LFLAG = multiflags {
  ECHOKE         = 0x00000001,
  ECHOE          = 0x00000002,
  ECHOK          = 0x00000004,
  ECHO           = 0x00000008,
  ECHONL         = 0x00000010,
  ECHOPRT        = 0x00000020,
  ECHOCTL        = 0x00000040,
  ISIG           = 0x00000080,
  ICANON         = 0x00000100,
  ALTWERASE      = 0x00000200,
  IEXTEN         = 0x00000400,
  EXTPROC        = 0x00000800,
  TOSTOP         = 0x00400000,
  FLUSHO         = 0x00800000,
  NOKERNINFO     = 0x02000000,
  PENDIN         = 0x20000000,
  NOFLSH         = 0x80000000,
}

c.TCSA = multiflags { -- this is another odd one, where you can have one flag plus SOFT
  NOW   = 0,
  DRAIN = 1,
  FLUSH = 2,
  SOFT  = 0x10,
}

-- tcflush(), renamed from TC to TCFLUSH
c.TCFLUSH = strflag {
  IFLUSH  = 1,
  OFLUSH  = 2,
  IOFLUSH = 3,
}

-- termios - tcflow() and TCXONC use these. renamed from TC to TCFLOW
c.TCFLOW = strflag {
  OOFF = 1,
  OON  = 2,
  IOFF = 3,
  ION  = 4,
}

-- for chflags and stat. note these have no prefix
c.CHFLAGS = multiflags {
  UF_NODUMP      = 0x00000001,
  UF_IMMUTABLE   = 0x00000002,
  UF_APPEND      = 0x00000004,
  UF_OPAQUE      = 0x00000008,
  UF_NOUNLINK    = 0x00000010,

  UF_SYSTEM      = 0x00000080,
  UF_SPARSE      = 0x00000100,
  UF_OFFLINE     = 0x00000200,
  UF_REPARSE     = 0x00000400,
  UF_ARCHIVE     = 0x00000800,
  UF_READONLY    = 0x00001000,
  UF_HIDDEN      = 0x00008000,

  SF_ARCHIVED    = 0x00010000,
  SF_IMMUTABLE   = 0x00020000,
  SF_APPEND      = 0x00040000,
  SF_NOUNLINK    = 0x00100000,
  SF_SNAPSHOT    = 0x00200000,
}

c.CHFLAGS.IMMUTABLE = c.CHFLAGS.UF_IMMUTABLE + c.CHFLAGS.SF_IMMUTABLE
c.CHFLAGS.APPEND = c.CHFLAGS.UF_APPEND + c.CHFLAGS.SF_APPEND
c.CHFLAGS.OPAQUE = c.CHFLAGS.UF_OPAQUE
c.CHFLAGS.NOUNLINK = c.CHFLAGS.UF_NOUNLINK + c.CHFLAGS.SF_NOUNLINK

return c

