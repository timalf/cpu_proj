pocz:
MOV R0,#0x00
MOV R1,#0x05
petla:
DEC R1
INC R0
CMP R1,#0x02
JG petla