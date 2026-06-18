import serial 
from time import sleep
#1000000 baud rate

'''
design goals:
    1. take an assembly like text file and convert it into "machine code"
    2. open the "machine code" file, transmit via UART line by line until reach end of file
    3. send next line IF and ONLY IF FPGA Board sends a "ready" message
'''

'''
test 1:
    making sure my python code can communicate with the FPGA board at all. seems operational

test 2: converting an assembly code file into machine code file and being ableto open the machine code and print it
'''


'''
currently does not support identifying labels
also not currently capable of splitting strings by spaces OR commas
'''

def labelIdentifier():
    pass
    #scan through file once to identify any labels. only useful when address numbers are in place

def registerIdentifier(inputReg):

    if(inputReg=="0"):
        inputReg="000"
    elif(inputReg=="1"):
        inputReg="001"
    elif(inputReg=="2"):
        inputReg="010"
    elif(inputReg=="3"):
        inputReg="011"
    elif(inputReg=="4"):
        inputReg="100"
    elif(inputReg=="5"):
        inputReg="101"
    elif(inputReg=="6"):
        inputReg="110"
    elif(inputReg=="7"):
        inputReg="111"
    return inputReg


def to_twos_complement(val, bits):
    # Compute the mask for the specified bit-width (e.g., 255 for 8 bits)
    mask = (1 << bits) - 1
    # Apply the mask and format as a binary string padded with leading zeros
    return f"{val & mask:0{bits}b}"

def binary_to_signed_int(binary_str, bits):
    # Step 1: Parse as a standard unsigned base-2 integer
    val = int(binary_str, 2)
    
    # Step 2: If sign bit is 1, subtract 2^bits to make it negative
    if val >= (1 << (bits - 1)):
        val -= (1 << bits)
    return val

def numTypeIdentifier(inputNum):

    convertednum=0
    if(inputNum[0]=="#"):
        convertednum=int(inputNum[1:])
    elif(inputNum[0].casefold()=="x"):
        #print("hexadecimal encoding")
        currentDigit=1

        #bug, returns string as positive values
        '''
        
        how to convert string as 2-comp's hex number?
        
        '''
        for i in range(len(inputNum)-1,0,-1):

            if(inputNum[i]=="-"):
                convertednum*=-1

            elif(inputNum[i].casefold()=="a"):
                convertednum+=currentDigit*10
            elif(inputNum[i].casefold()=="b"):
                convertednum+=currentDigit*11
            elif(inputNum[i].casefold()=="c"):
                convertednum+=currentDigit*12
            elif(inputNum[i].casefold()=="d"):
                convertednum+=currentDigit*13
            elif(inputNum[i].casefold()=="e"):
                convertednum+=currentDigit*14
            elif(inputNum[i].casefold()=="f"):
                convertednum+=currentDigit*15
            else:
                convertednum+=int(inputNum[i])*currentDigit
            currentDigit*=16            
        #print("raw value=",str(convertednum))
        convertednum=to_twos_complement(convertednum,5)
        convertednum=binary_to_signed_int(convertednum,5)
        #print("converted?=",str(convertednum))
        
    else:
        print("illegal encoding")
        convertednum=-999
    return convertednum


def isa_translator():   #function, open a ISA file and write a machine-code file
    '''
    open ISA file
    while not reach end-of-file
        extract line of code
        break line of code into list by spaces
        case(instruction)
            when instruction identified, ensure remaining items in the list are compatible
            if any error is found, terminate program
    '''
    with open('demo.txt', 'r') as inputFile:
        with open('intermediateLevel.txt','w') as outputFile:
            for line in inputFile:
                #how do i split by both space and ","?
                current_instruction=line.split()
                print(current_instruction)

                if(not current_instruction):    #skips any empty lines
                    continue

                if(current_instruction[0].casefold()=="and".casefold()):
                    #print("command = AND")
                    destReg=current_instruction[1][1]  
                    sourceReg=current_instruction[2][1]
                    secondArg=""

                    if(current_instruction[3][0].casefold()=="r"):
                        secondReg=current_instruction[3][1]
                        secondArg="000"+registerIdentifier(secondReg)
                    else:
                        offset=numTypeIdentifier(current_instruction[3])
                        if offset<-16 or offset>15:
                            print("out of bounds. terminating program")
                        else:
                            #convert offset to binary
                            secondArg="1"+to_twos_complement(offset,bits=5)

                    machineCode="0101"+registerIdentifier(destReg)+registerIdentifier(sourceReg)+secondArg+"\n"
                    outputFile.write(machineCode)  
                      


                elif(current_instruction[0].casefold()=="add".casefold()):
                    #print("command= ADD")
                    destReg=current_instruction[1][1]  
                    #print(destReg)
                    sourceReg=current_instruction[2][1]
                    #print(sourceReg)
                    secondArg=""

                    if(current_instruction[3][0].casefold()=="r"):
                        #print("2nd source reg")
                        secondReg=current_instruction[3][1]
                        secondArg="000"+registerIdentifier(secondReg)
                    else:
                        #print("argument is not a register number")
                        offset=numTypeIdentifier(current_instruction[3])
                        if offset<-16 or offset>15:
                            print("out of bounds. terminating program")
                        else:
                            #convert offset to binary
                            secondArg="1"+to_twos_complement(offset,bits=5)

                    machineCode="0001"+registerIdentifier(destReg)+registerIdentifier(sourceReg)+secondArg+"\n"
                    outputFile.write(machineCode)

                    
                
                elif(current_instruction[0].casefold()[0:2]=="br".casefold()):  #recognizes types of BR instructions
                    print("command= BR")
                elif(current_instruction[0].casefold()=="jmp".casefold()):
                    print("command= JMP")
                elif(current_instruction[0].casefold()=="jsr".casefold()):
                    print("command= JSR")
                elif(current_instruction[0].casefold()=="jsrr".casefold()):
                    print("command= JSRR")
                elif(current_instruction[0].casefold()=="ldb".casefold()):
                    print("command= LDB")
                elif(current_instruction[0].casefold()=="ldw".casefold()):
                    print("command= LDW")
                elif(current_instruction[0].casefold()=="lea".casefold()):
                    print("command= LEA")
                elif(current_instruction[0].casefold()=="rti".casefold()):
                    print("command= RTI")
                elif(current_instruction[0].casefold()=="shf".casefold()):
                    print("command= SHF")
                elif(current_instruction[0].casefold()=="stb".casefold()):
                    print("command= STB")
                elif(current_instruction[0].casefold()=="stw".casefold()):
                    print("command= STW")
                elif(current_instruction[0].casefold()=="trap".casefold()):
                    print("command= TRAP")
                elif(current_instruction[0].casefold()=="xor".casefold()):
                    print("command= XOR")
                else:
                    print("opcode is not first argument. first arg is label?")
            
    

def machine_code_transmitter(): #functiom, open the machine-code file and sequentially pass each 16bit input

    #open machine code file

    
    '''
    coded the looping logic wrong: should look like

    while still have line of machine code
        send machine code
        wait until FPGA Board receives anything not a ""
        break inner loop

    '''

    ser=serial.Serial()
    ser.baudrate=1000000
    ser.port='COM3'
    ser.open()

    readySignal=1

    with open('intermediateLevel.txt', 'r') as mcodeInput:

        for line in mcodeInput:
            line = line.strip()

            print("machine code =", line)

            value = int(line, 2)
            data = value.to_bytes((len(line) + 7) // 8, 'little')

            ser.write(data)

            # Wait for FPGA acknowledgement
            received_data=0
            while received_data==0:
                received_data = ser.read().decode('utf-8')
                print("FPGA says:")
                print(received_data)

'''
#original code: messy looping logic
    with open('intermediateLevel.txt','r') as mcodeInput:
        while (readySignal==1):
            line=mcodeInput.readline()
            if(line==""):
                print("no more transmission. program terminated")
                break
            else:
                print("machine code=",line.strip())
                machineCode=line.strip()
                readySignal=0
                value = int(line, 2)
                data = value.to_bytes(len(line) // 8, 'little')

                print(' '.join(f'{b:08b}' for b in data))
                ser.write(data)

                received_data = ser.read().decode('utf-8')
                print("FPGA says:")
                print(received_data)
'''


def main():
    isa_translator()
    machine_code_transmitter()
    
    

if __name__=="__main__":
    main()
