import sys
import argparse
import re

#wzorzec etykiety
labelre = re.compile("([A-Z,a-z][A-Z,a-z,0-9]*):$")
#wzorzec rozkazu
statementre = re.compile("([A-Z,a-z]{2,4})")

def parser(src):
    with open(src,'r') as f:
        for line in f:
            line = line.strip()
            # ';' do komentarzy
            line = line.split(";")[0].strip()
            if not line:
                # jesli pusta linia w kodzie
                continue
            mo = labelre.match(line)
            if mo:
                # jesli etykieta
                yield "ETYKIETA", mo.group(1)
                continue
            if statementre.match(line):
                # jesli rozkaz
                parts = line.split()
                opcode = parts[0]
                rest = "".join(parts[1:])
                operands = rest.split(',')
                yield "ROZKAZ", (opcode, operands)
                continue
            # jesli nie rozpoznano zadnego z powyzszych
            raise SyntaxError, "Nie mozna rozpoznac jako rozkaz lub etykiete: %r" % line

#wzorce typow operandow
operand_type_re = [
    ("IMM",re.compile("#0x[0-9,a-f,A-F]+$")),
    ("MEM",re.compile("0x[0-9,a-f,A-F]+$")),
    ("REG",re.compile("R[0-3]$")),
    ("LBL",re.compile("([A-Z,a-z][A-Z,a-z,0-9]*)$")),
]
            
#rozpoznawanie operandow
def operand_type(operand):
    if not operand:
        return ""
    for code, opre in operand_type_re:
        if opre.match(operand):
            return code
    raise SyntaxError, "Nie mozna rozpoznac argumentu: %r" % operand

#kodowanie kolejnych instrukcji
def movRIMM(operands):
    inst = "000000"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][3:],16))[2:].zfill(8)
    return inst

def movREGR(operands):
    inst = "000001"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][1]))[2:].zfill(8)
    return inst

def movMEMR(operands):
    inst = "000011"
    inst+= bin(int(operands[1][1]))[2:].zfill(2)
    inst+= bin(int(operands[0][2:],16))[2:].zfill(8)
    return inst

def movRMEM(operands):
    inst = "000010"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][2:],16))[2:].zfill(8)
    return inst

def addRIMM(operands):
    inst = "000100"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][3:],16))[2:].zfill(8)
    return inst

def addREGR(operands):
    inst = "000110"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][1]))[2:].zfill(8)
    return inst

def adcRIMM(operands):
    inst = "000111"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][3:],16))[2:].zfill(8)
    return inst

def adcREGR(operands):
    inst = "001000"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][1]))[2:].zfill(8)
    return inst

def subRIMM(operands):
    inst = "001001"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][3:],16))[2:].zfill(8)
    return inst

def subREGR(operands):
    inst = "001010"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][1]))[2:].zfill(8)
    return inst

def subbRIMM(operands):
    inst = "001011"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][3:],16))[2:].zfill(8)
    return inst

def subbREGR(operands):
    inst = "001100"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][1]))[2:].zfill(8)
    return inst

def mulREGR(operands):
    inst = "001111"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][1]))[2:].zfill(8)
    return inst

def incREGR(operands):
    inst = "001101"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(0)[2:].zfill(8)
    return inst

def decREGR(operands):
    inst = "001110"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(0)[2:].zfill(8)
    return inst

def anlRIMM(operands):
    inst = "010000"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][3:],16))[2:].zfill(8)
    return inst

def anlREGR(operands):
    inst = "010001"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][1]))[2:].zfill(8)
    return inst

def orlRIMM(operands):
    inst = "010010"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][3:],16))[2:].zfill(8)
    return inst

def orlREGR(operands):
    inst = "010011"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][1]))[2:].zfill(8)
    return inst

def xrlRIMM(operands):
    inst = "010100"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][3:],16))[2:].zfill(8)
    return inst

def xrlREGR(operands):
    inst = "010101"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][1]))[2:].zfill(8)
    return inst

def cmpRIMM(operands):
    inst = "010110"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][3:],16))[2:].zfill(8)
    return inst

def cmpREGR(operands):
    inst = "010111"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(int(operands[1][1]))[2:].zfill(8)
    return inst

def cplREGR(operands):
    inst = "011011"
    inst+= bin(int(operands[0][1]))[2:].zfill(2)
    inst+= bin(0)[2:].zfill(8)
    return inst

def jmpIMM(operands):
    inst = "000101"
    inst+= bin(int(operands[0]))[2:].zfill(10)
    return inst

def jeIMM(operands):
    inst = "011000"
    inst+= bin(int(operands[0]))[2:].zfill(10)
    return inst

def jgIMM(operands):
    inst = "011001"
    inst+= bin(int(operands[0]))[2:].zfill(10)
    return inst

def jlIMM(operands):
    inst = "011010"
    inst+= bin(int(operands[0]))[2:].zfill(10)
    return inst

assemblers = {
     ("MOV","REG","IMM"):movRIMM,
     ("MOV","REG","MEM"):movRMEM,
     ("MOV","MEM","REG"):movMEMR,
     ("MOV","REG","REG"):movREGR,
     ("ADD","REG","IMM"):addRIMM,
     ("ADD","REG","REG"):addREGR,
     ("ADC","REG","IMM"):adcRIMM,
     ("ADC","REG","REG"):adcREGR,
     ("SUB","REG","IMM"):subRIMM,
     ("SUB","REG","REG"):subREGR,
     ("SUBB","REG","IMM"):subbRIMM,
     ("SUBB","REG","REG"):subbREGR,
     ("INC","REG"):incREGR,
     ("DEC","REG"):decREGR,
     ("MUL","REG","REG"):mulREGR,
     ("ANL","REG","IMM"):anlREGR,
     ("ANL","REG","REG"):anlREGR,
     ("ORL","REG","IMM"):orlREGR,
     ("ORL","REG","REG"):orlREGR,
     ("XRL","REG","IMM"):xrlREGR,
     ("XRL","REG","REG"):xrlREGR,
     ("CMP","REG","IMM"):cmpRIMM,
     ("CMP","REG","REG"):cmpREGR,
     ("CPL","REG"):cplREGR,
     ("JMP","IMM"):jmpIMM,
     ("JE","IMM"):jeIMM,
     ("JG","IMM"):jgIMM,
     ("JL","IMM"):jlIMM
}

def assemble(src):
    program = []
    labels = {}
    usedlabels = []
    
    i=-1
    for parseresult in parser(src):
        i=i+1
        rtype, res = parseresult
        if rtype == "ROZKAZ":
            #dodawanie rozkazu do programu
            opcode, operands = res
            sig = [opcode]
            for operand in operands:
                sig.append(operand_type(operand))
                print sig
            if "LBL" in sig:
                #jesli etykieta w poleceniu
                usedlabels.append((len(program),sig, operands))
                program.append(0xdeadbeef)
                print usedlabels
            else:
                inst = assemblers[tuple(sig)](operands)
                program.append(inst)
        elif rtype == "ETYKIETA":
            #zapisuje adres etykiety
            labels[res] = i

    for address, sig, operands in usedlabels:
        #zamiana etykiety na adres
        for i,t in enumerate(sig[1:]):
            if t == "LBL":
                sig[i+1] = "IMM"
                if sig[0] == "JMP" or sig[0]=="JG" or sig[0]=="JE" or sig[0]=="JL":
                    operands[i] = labels[operands[i]]-1
                else:
                    raise RuntimeError, "Nieznany kod operacji %r" % sig
        inst = assemblers[tuple(sig)](operands)
        program[address] = inst
    return program


def write_vhdl(of,p):
    for c in enumerate(p):
        print >>of, c[1]

def main():
    parser = argparse.ArgumentParser(description='Asembler Translator')
    parser.add_argument('src', metavar='source.asm', type=unicode, nargs=1,
                       help='the file to assemble')

    args = parser.parse_args()
    src = args.src[0]
    p = assemble(src)

    of = open("instrukcja.txt","w")
    write_vhdl(of,p)

if __name__=="__main__":
    main()