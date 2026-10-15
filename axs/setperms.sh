#!/bin/sh
# <xmp><meta name="robots" content="none" />

echo __________________________________________________________________
echo
echo Updated 28 Aug 2001 by Zoltan Milosevic
echo
echo This batch file sets the proper file permissions on Unix for the
echo AXS Site Tracking System.  Use "setperms.bat" for Windows
echo systems.
echo
echo To run, open a command prompt or telnet window and navigate to
echo the folder that contains the AXS scripts and data files.  Type
echo the name for this script, and hit
echo Enter.  All proper permissions will be set.
echo
echo Run this file from an account which has change permission rights
echo for all files in the "axs" folder.  Typically the root or
echo file owner accounts would be appropriate.
echo
echo For more information, visit http://www.xav.com/scripts/axs/
echo
echo __________________________________________________________________
echo

echo Setting permissions...
chmod 755 ax*.*
chmod 755 convert.*
chmod 766 log.txt
chmod 766 axs.dat
echo

echo __________________________________________________________________
echo
echo Note: if AXS has already been installed, then some operations
echo will fail as \"chmod: xxx.txt: Operation not permitted\".  This is
echo expected and is not a problem.
echo
echo Permissions finished.
echo __________________________________________________________________
echo

