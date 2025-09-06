# x86-64LINUXcalculator

This is a simple x86-64 Assembly calculator, written for a Linux kernel

# Installation/Setting up

To install and use the program, you must follow those steps:
1. Download the repository with either the GitHub `Download` button or with typing
```bash
git clone https://github.com/fif3x/x86-64LINUXcalculator.git
```
in the terminal

2. Install dependencies with running the [installDependencies.sh](https://github.com/fif3x/x86-64LINUXcalculator/blob/main/installDependencies.sh) script _note: it's written for debian-based systems_
3. Build project with running the [build.sh](https://github.com/fif3x/x86-64LINUXcalculator/blob/main/build.sh) script
4. Go to `bin/` and open the `.out` file

# How it works

Lets break down the program into multiple parts:
1. `.data` section and its contests:
In the `.data` section, we store the string for `output` and its length like this:
```asm
output db 0, 10 ; space for 1 char and a newline char
length equ $ - output
```

2. Operation selection
To select an operation, we change the value of the `r14` register in line 25:
```asm
mov r14, 1  ; mode (1:add, 2:sub, 3:mul, 4:div)
```

3. Printing
After preforming an operation, we store the result in `r8` and call the `_print` function using
```asm
mov r8,  r12      ; store in r8 to print
call     _print   ; call print function
```
then in the `_print` function we firstly make `r8` an ascii text, add the last byte of `r8b` to `output`, and then also add a new line to the `output`
```asm
add r8,      '0'
mov byte [output],   r8b
mov byte [output+1], 10
```
lastly, we call the Linux write function, using the following values:
`rax = 1` for syscall:write
`rdi = 1` for stdout
`rsi = address of output` to point to it
`rdx = length of output`
so the code looks like this:
```asm
mov rax,             1              ; syscall: write
mov rdi,             1              ; stdout
lea rsi,             [rel output]   ; output address
mov rdx,             length         ; output length
syscall
ret ; return control
```
4. Ending program
After completing everything needed, we clear the registers using `xor reg, reg`, which is a bitwise operator making `reg` equal to 0, and we call the syscall for exiting:
```asm
; clear registers
xor r12, r12
xor r13, r13
xor rdx, rdx
xor r8,  r8
xor rsi, rsi
xor r14, r14

mov rax, 60   ; exit program
xor rdi, rdi  ; code 0
syscall
```
