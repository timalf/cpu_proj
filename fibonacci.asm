MOV R3,0x00
CMP R3, #0x00
JE zero
CMP R3, #0x00
JE jeden
MOV R0,#0x00
MOV R1,#0x01
MOV R2,R0
ADD R2,R1
MOV R0,R1
MOV R1,R2
DEC R3
CMP R3, #0x00
JE zapis
jeden:
MOV R0, #0x01
MOV 0x01,R0
JMP koniec
zero:
MOV R0, #0x00
MOV 0x01,R0
JMP koniec
zapis:
MOV 0x01, R1
koniec: