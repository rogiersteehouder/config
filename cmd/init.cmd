@echo off
chcp 65001 > nul

rem Environment variables

set USER_IS_ADMIN=false
net session > nul 2>&1
if %errorlevel% == 0 (
	set USER_IS_ADMIN=true
)

rem Prompt

if %USER_IS_ADMIN% == true (
	rem Admin (red)
	rem Simple prompt
	rem prompt %COMPUTERNAME%$s$b$s$p$_$e[0;31m$g$e[0m$s
	rem Fancy prompt
	prompt $e[0;31m┌─┤$e[0m$s%COMPUTERNAME%$s$e[0;31m├─┤$e[0m$s$p$s$e[0;31m├──$_└─$e[0m$s
) else (
	rem Regular (green)
	rem Simple prompt
	rem prompt %COMPUTERNAME%$s$b$s$p$_$e[0;32m$g$e[0m$s
	rem Fancy prompt
	prompt $e[0;32m┌─┤$e[0m$s%COMPUTERNAME%$s$e[0;32m├─┤$e[0m$s$p$s$e[0;32m├──$_└─$e[0m$s
)
