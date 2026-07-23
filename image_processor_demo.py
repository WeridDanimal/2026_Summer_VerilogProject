import serial
import cv2
import numpy as np
from PIL import Image

def formatIntoArray(mode, filename,rows,cols):

    print("Confirming 'formatIntoArray' has been called")
    img_array = cv2.imread(filename)

    # OpenCV reads images in BGR format. Convert to RGB if needed:
    img_array_rgb = cv2.cvtColor(img_array, cv2.COLOR_BGR2RGB)

    #print(img_array_rgb)
    #return img_array_rgb

    #print("confirming array via reconstruction")
    #img = Image.fromarray(img_array_rgb)   #this converts a numpy array into an image
    #img.show()                 #this shows the image
    

    if(mode=="scaledown"):
        pass    #this scales an image down to some array size
        scaledDownImg=np.zeros((rows, cols, 3), dtype=np.uint8)
        image = Image.open(filename)

        # Define target dimensions (Width, Height)
        new_size = (rows, cols)

        # Resize the image using the high-quality Lanczos filter
        resized_image = image.resize(new_size, resample=Image.Resampling.LANCZOS)
        resized_image.save("scaled_down_resize.jpg")

        resized_img_array = cv2.imread("scaled_down_resize.jpg")

        # OpenCV reads images in BGR format. Convert to RGB if needed:
        resized_array_rgb = cv2.cvtColor(resized_img_array, cv2.COLOR_BGR2RGB)
        for i in range(0,rows):
            for j in range(0,cols):
                for k in range(0,3):
                    scaledDownImg[i][j][k]=resized_array_rgb[i][j][k]
        return scaledDownImg

    elif(mode=="crop"):
        croppedImage = np.zeros((rows, cols, 3), dtype=np.uint8) #x rows, y columns, 3 for RGB

        for i in range(0,rows):
            for j in range(0,cols):
                for k in range(0,3):
                    croppedImage[i][j][k]=img_array_rgb[i][j][k]
        #print("Testing cropping function")
        #croppedOut=Image.fromarray(croppedImage)
        #croppedOut.show()
        return croppedImage
    
    pass

def transmit_longMessage():
    print("Testing the array...")

    testArray=[3,3,3,  #the first 3 elements MUST ALWAYS be: Number of rows, number of columns, # of bytes each element takes
               1,2,3, 11,12,13, 24,22,23,
               39,38,35,  44,43,44,  59,58,51,
               66,62,60,  88,89,82,  99,99,99];
    

    '''
    testArray=[2,2,3, 
               1,2,3,    11,12,13,
               24,22,23,     39,38,35];
    '''
    
    dimensionArray=[9,7,2]      #required parameters in order: rows, columns, bit size of each element

    ser=serial.Serial()
    ser.baudrate=1000000
    ser.port='COM3'
    ser.open()
    
    
    for elem in testArray:
    #for elem in dimensionArray: 
        #print(f"Decimal: {elem:3d} | " f"Binary: {elem:08b} | " f"Hex: 0x{elem:02X} | ") DEBUG ONLY
        ser.write(bytes([elem]))

    print("Array should have finished being sent...")
    ser.close()


def transmitImage(rows,cols, imgArray):
    print("CALLING Transmit Image")
    ser=serial.Serial()
    ser.baudrate=1000000
    ser.port='COM3'
    ser.open()

    ser.write(bytes([rows]))
    ser.write(bytes([cols]))
    ser.write(bytes([3]))

    #print("rows=",rows," bytes=",bytes([rows]))
    #print("cols=",cols," bytes=",bytes([cols]))
    #print("bytes=",3," bytes=",bytes([3]))
    

    with open("imgageIN.txt", "w", encoding="utf-8") as file:
    
        for i in range(0,rows):
            for j in range(0,cols):
                for k in range(0,3):
                    file.write("subpixel value= "+str(imgArray[i][j][k])+" x="+str(i)+" y="+str(j)+" z="+str(k)+"\n")
                    #print("current value=",imgArray[i][j][k],   " bytes=",bytes([imgArray[i][j][k]]))
                    ser.write(bytes([imgArray[i][j][k]]))
                    pass

    ser.close()


def receiveMessage(rows,cols):
    ser=serial.Serial()
    ser.baudrate=250000
    ser.port='COM3'
    ser.open()
    
    receiverImage = np.zeros((rows, cols, 3), dtype=np.uint8) #3 rows, 3 columns, 3 for RGB

    print("=====================================================================")
    print("TESTING RECEIVER")
    print("=====================================================================")

    x=0 
    y=0
    z=0

    with open("imgageOUT.txt", "w", encoding="utf-8") as file:

        while(x<rows):
            receiverInput = ser.read(1)

            value = int.from_bytes(receiverInput, byteorder='big')

            file.write("subpixel value= "+str(value)+" x="+str(x)+" y="+str(y)+" z="+str(z)+"\n")
            print("Received:", value, "x=",x," y=",y," z=",z)
            receiverImage[x][y][z]=value
            z+=1

            if(z==3):
                z=0
                y+=1
            if(y==cols):
                y=0
                x+=1


    print("Receiver done")
    print("Image array double-check", receiverImage)
    img=Image.fromarray(receiverImage)
    img.show()


def transmitReceive(rows,cols,imgArray):
    print("CALLING Transmit Image")
    ser=serial.Serial()
    ser.baudrate=1000000
    ser.port='COM3'
    ser.open()

    ser.write(bytes([rows]))
    ser.write(bytes([cols]))
    ser.write(bytes([3]))

    

    with open("imgageIN.txt", "w", encoding="utf-8") as file:
    
        for i in range(0,rows):
            for j in range(0,cols):
                for k in range(0,3):
                    file.write("subpixel value= "+str(imgArray[i][j][k])+" x="+str(i)+" y="+str(j)+" z="+str(k)+"\n")
                    #print("current value=",imgArray[i][j][k],   " bytes=",bytes([imgArray[i][j][k]]))
                    ser.write(bytes([imgArray[i][j][k]]))
                    pass


    receiverImage = np.zeros((rows, cols, 3), dtype=np.uint8) #3 rows, 3 columns, 3 for RGB
    
    print("=====================================================================")
    print("TESTING RECEIVER")
    print("=====================================================================")

    x=0 
    y=0
    z=0

    with open("imgageOUT.txt", "w", encoding="utf-8") as file:

        while(x<rows):
            receiverInput = ser.read(1)

            value = int.from_bytes(receiverInput, byteorder='big')
            
            file.write("subpixel value= "+str(value)+" x="+str(x)+" y="+str(y)+" z="+str(z)+"\n")
            print("Received:", value, "x=",x," y=",y," z=",z)
            receiverImage[x][y][z]=value
            z+=1

            if(z==3):
                z=0
                y+=1
            if(y==cols):
                y=0
                x+=1


    print("Receiver done")
    print("Image array double-check", receiverImage)
    img=Image.fromarray(receiverImage)
    img.show()


    ser.close()

def main():
    pass

    rows=75
    cols=75
    #maximum pass case=63, wait no 64???
    '''
    for reasons i don't know yet, 64x64 worked if i press the transmit button again...
    
    '''
    #croppedImage=formatIntoArray("crop","pureRed.png",rows,cols)
    croppedImage=formatIntoArray("scaledown","testImage.jpg",rows,cols)
    #print("checking array",croppedImage)


    #transmitReceive(rows,cols,croppedImage)

    transmitImage(rows,cols,croppedImage)
    receiveMessage(rows,cols)

    
    #a = np.random.randint(0, 256, (100, 100, 3), dtype=np.uint8)

    #img = Image.fromarray(a)   //this converts a numpy array into an image
    #img.show()                 //this shows the image

if __name__=="__main__":
    main()