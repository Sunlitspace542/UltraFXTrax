cls
set path=%path%;c:\bin
set sasmheap=14400
cd xl
@echo off
del *.sob
del lastasm.*
del *.bak /s
@echo on
make xl.rom
cd ..
copy xl\xl.rom XLBuilt.SFC
del xl\xl.rom
del xl\*.sob
del xl\status.doc
del xl\lastasm.tmp
del xl\msgs.txt
del xl\alvars.txt
copy xl\symbols.txt symbols.txt
del xl\symbols.txt
pause
exit
