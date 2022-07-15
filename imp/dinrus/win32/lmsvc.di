﻿/***********************************************************************\
*                                lmsvc.d                                *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.lmsvc;

// FIXME: Is this file deprecated? All of the functions are only for Win16.
/**
  Changes relative to MinGW:
  lmsname is not imported publicly (instead, win32.lm imports it directly).
*/
// TODO: 5 macros

private import win32.lmcons, win32.lmsname, win32.windef;

const TCHAR[] SERVICE_DOS_ENCRYPTION = "ENCRYPT";

const SERVICE_UNINSTALLED=0;
const SERVICE_INSTALL_PENDING=1;
const SERVICE_UNINSTALL_PENDING=2;
const SERVICE_INSTALLED=3;
const SERVICE_INSTALL_STATE=3;
const SERVICE_PAUSE_STATE=18;
const LM20_SERVICE_ACTIVE=0;
const LM20_SERVICE_CONTINUE_PENDING=4;
const LM20_SERVICE_PAUSE_PENDING=8;
const LM20_SERVICE_PAUSED=18;
const SERVICE_NOT_UNINSTALLABLE=0;
const SERVICE_UNINSTALLABLE=16;
const SERVICE_NOT_PAUSABLE=0;
const SERVICE_PAUSABLE=32;
const SERVICE_REDIR_PAUSED=0x700;
const SERVICE_REDIR_DISK_PAUSED=256;
const SERVICE_REDIR_PRINT_PAUSED=512;
const SERVICE_REDIR_COMM_PAUSED=1024;
const SERVICE_CTRL_INTERROGATE=0;
const SERVICE_CTRL_PAUSE=1;
const SERVICE_CTRL_CONTINUE=2;
const SERVICE_CTRL_UNINSTALL=3;
const SERVICE_CTRL_REDIR_DISK=1;
const SERVICE_CTRL_REDIR_PRINT=2;
const SERVICE_CTRL_REDIR_COMM=4;
const SERVICE_IP_NO_HINT=0;
const SERVICE_CCP_NO_HINT=0;
const SERVICE_IP_QUERY_HINT=0x10000;
const SERVICE_CCP_QUERY_HINT=0x10000;
const SERVICE_IP_CHKPT_NUM=255;
const SERVICE_CCP_CHKPT_NUM=255;
const SERVICE_IP_WAIT_TIME=0xFF00;
const SERVICE_CCP_WAIT_TIME=0xFF00;
const SERVICE_IP_WAITTIME_ШИФТ=8;
const SERVICE_NTIP_WAITTIME_ШИФТ=12;
const UPPER_HINT_MASK=0xFF00;
const LOWER_HINT_MASK=255;
const UPPER_GET_HINT_MASK=0xFF00000;
const LOWER_GET_HINT_MASK=0xFF00;
const SERVICE_NT_MAXTIME=0xFFFF;
const SERVICE_RESRV_MASK=0x1FFFF;
const SERVICE_MAXTIME=255;
const SERVICE_BASE=3050;
const SERVICE_UIC_NORMAL=0;

const SERVICE_UIC_BADPARMVAL = SERVICE_BASE+1;
const SERVICE_UIC_MISSPARM = SERVICE_BASE+2;
const SERVICE_UIC_UNKPARM = SERVICE_BASE+3;
const SERVICE_UIC_RESOURCE = SERVICE_BASE+4;
const SERVICE_UIC_CONFIG = SERVICE_BASE+5;
const SERVICE_UIC_SYSTEM = SERVICE_BASE+6;
const SERVICE_UIC_INTERNAL = SERVICE_BASE+7;
const SERVICE_UIC_AMBIGPARM = SERVICE_BASE+8;
const SERVICE_UIC_DUPPARM = SERVICE_BASE+9;
const SERVICE_UIC_KILL = SERVICE_BASE+10;
const SERVICE_UIC_EXEC = SERVICE_BASE+11;
const SERVICE_UIC_SUBSERV = SERVICE_BASE+12;
const SERVICE_UIC_CONFLPARM = SERVICE_BASE+13;
const SERVICE_UIC_FILE = SERVICE_BASE+14;
const SERVICE_UIC_M_NULL=0;
const SERVICE_UIC_M_MEMORY = SERVICE_BASE+20;
const SERVICE_UIC_M_DISK = SERVICE_BASE+21;
const SERVICE_UIC_M_THREADS = SERVICE_BASE+22;
const SERVICE_UIC_M_PROCESSES = SERVICE_BASE+23;
const SERVICE_UIC_M_SECURITY = SERVICE_BASE+24;
const SERVICE_UIC_M_LANROOT = SERVICE_BASE+25;
const SERVICE_UIC_M_REDIR = SERVICE_BASE+26;
const SERVICE_UIC_M_SERVER = SERVICE_BASE+27;
const SERVICE_UIC_M_SEC_FILE_ERR = SERVICE_BASE+28;
const SERVICE_UIC_M_FILES = SERVICE_BASE+29;
const SERVICE_UIC_M_LOGS = SERVICE_BASE+30;
const SERVICE_UIC_M_LANGROUP = SERVICE_BASE+31;
const SERVICE_UIC_M_MSGNAME = SERVICE_BASE+32;
const SERVICE_UIC_M_ANNOUNCE = SERVICE_BASE+33;
const SERVICE_UIC_M_UAS = SERVICE_BASE+34;
const SERVICE_UIC_M_SERVER_SEC_ERR = SERVICE_BASE+35;
const SERVICE_UIC_M_WKSTA = SERVICE_BASE+37;
const SERVICE_UIC_M_ERRLOG = SERVICE_BASE+38;
const SERVICE_UIC_M_FILE_UW = SERVICE_BASE+39;
const SERVICE_UIC_M_ADDPAK = SERVICE_BASE+40;
const SERVICE_UIC_M_LAZY = SERVICE_BASE+41;
const SERVICE_UIC_M_UAS_MACHINE_ACCT = SERVICE_BASE+42;
const SERVICE_UIC_M_UAS_SERVERS_NMEMB = SERVICE_BASE+43;
const SERVICE_UIC_M_UAS_SERVERS_NOGRP = SERVICE_BASE+44;
const SERVICE_UIC_M_UAS_INVALID_ROLE = SERVICE_BASE+45;
const SERVICE_UIC_M_NETLOGON_NO_DC = SERVICE_BASE+46;
const SERVICE_UIC_M_NETLOGON_DC_CFLCT = SERVICE_BASE+47;
const SERVICE_UIC_M_NETLOGON_AUTH = SERVICE_BASE+48;
const SERVICE_UIC_M_UAS_PROLOG = SERVICE_BASE+49;
const SERVICE2_BASE=5600;
const SERVICE_UIC_M_NETLOGON_MPATH = SERVICE2_BASE+0;
const SERVICE_UIC_M_LSA_MACHINE_ACCT = SERVICE2_BASE+1;
const SERVICE_UIC_M_DATABASE_ERROR = SERVICE2_BASE+2;

struct SERVICE_INFO_0 {
	LPWSTR svci0_name;
}
alias SERVICE_INFO_0* PSERVICE_INFO_0, LPSERVICE_INFO_0;

struct SERVICE_INFO_1 {
	LPWSTR svci1_name;
	DWORD svci1_status;
	DWORD svci1_code;
	DWORD svci1_pid;
}
alias SERVICE_INFO_1* PSERVICE_INFO_1, LPSERVICE_INFO_1;

struct SERVICE_INFO_2 {
	LPWSTR svci2_name;
	DWORD svci2_status;
	DWORD svci2_code;
	DWORD svci2_pid;
	LPWSTR svci2_text;
	DWORD svci2_specific_error;
	LPWSTR svci2_display_name;
}
alias SERVICE_INFO_2* PSERVICE_INFO_2, LPSERVICE_INFO_2;

extern (Windows) {
	deprecated {
		NET_API_STATUS NetServiceControl(LPCWSTR, LPCWSTR, DWORD, DWORD,
		  PBYTE*);
		NET_API_STATUS NetServiceEnum(LPCWSTR, DWORD, PBYTE*, DWORD, PDWORD,
		  PDWORD, PDWORD);
		NET_API_STATUS NetServiceGetInfo(LPCWSTR, LPCWSTR, DWORD, PBYTE*);
		NET_API_STATUS NetServiceInstall(LPCWSTR, LPCWSTR, DWORD, LPCWSTR*,
		  PBYTE*);
	}
}
//MACRO #define SERVICE_IP_CODE(t, n) ((long)SERVICE_IP_QUERY_HINT|(long)(n|(t<<SERVICE_IP_WAITTIME_ШИФТ)))
//MACRO #define SERVICE_CCP_CODE(t, n) ((long)SERVICE_CCP_QUERY_HINT|(long)(n|(t<<SERVICE_IP_WAITTIME_ШИФТ)))
//MACRO #define SERVICE_UIC_CODE(c, m) ((long)(((long)c<<16)|(long)(USHORT)m))
//MACRO #define SERVICE_NT_CCP_CODE(t, n) (((long)SERVICE_CCP_QUERY_HINT)|((long)(n))|(((t)&LOWER_HINT_MASK)<<SERVICE_IP_WAITTIME_ШИФТ)|(((t)&UPPER_HINT_MASK)<<SERVICE_NTIP_WAITTIME_ШИФТ))
//MACRO #define SERVICE_NT_WAIT_GET(c) ((((c)&UPPER_GET_HINT_MASK)>>SERVICE_NTIP_WAITTIME_ШИФТ)|(((c)&LOWER_GET_HINT_MASK)>>SERVICE_IP_WAITTIME_ШИФТ))