
cd execute
del *.o *.exe
copy ..\..\source\* .
gcc -c downloadHex.c -I. -o downloadHex.o
gcc -o downloadHex.exe downloadHex.o -L. -lftd2xx  

downloadHex
cd ..
