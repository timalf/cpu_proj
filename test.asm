pocz:
MOV R0,#0x00
MOV R1,#0x04
petla:
DEC R1
INC R0
CMP R0,R1
JE pocz
JMP petla