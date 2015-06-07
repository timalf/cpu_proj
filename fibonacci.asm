MOV R1,#0xFF  ; Initialize
MOV R2,#0x21
lbl1:
MOV R1,R3    ; Calculate the next fibonacci number
MOV R2,R1       ; Shift the result into the proper registers.
MOV R3,R2
MOV R1,0xFF
label2:
MOV 0xFF,R1
JMP label2