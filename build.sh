nasm src/main.asm -f elf64
ld src/main.o -o main.out
rm -r bin
mkdir bin
mv main.out bin/
chmod 755 bin/main.out
rm src/main.o
echo Build complete