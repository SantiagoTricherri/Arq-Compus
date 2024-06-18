.text

.global cohete

.extern ledShow
.extern disp_binary
.extern turnOff
.extern delay
.extern keyHit

cohete:
    PUSH {R4, R5, R6, R7, LR}
    
    // Inicializar variables
    MOV R7, #10        
    MOV R5, #8         
    MOV R6, #5         
    MOV R4, #10        

launch:
    
    MOV R3, #0        
launch_loop:
    CMP R3, R5        
    BGE flight        

    MOV R0, #1
    LSL R0, R0, R3    
    BL ledShow        
    MOV R0, R0        
    BL disp_binary   

   
    MOV R0, #3        
    MOV R1, #1        
    BL delay_wrapper
    BL check_key      

    
    SUBS R7, R7, #500 
    ADD R3, R3, #1    
    B launch_loop     

flight:
    
    MOV R3, #0        
flight_loop:
    CMP R3, R6        
    BGE explosion     

    MOV R0, #0xFF     
    BL ledShow        
    MOV R0, R0        
    BL disp_binary    

    
    MOV R0, #3        
    MOV R1, #1        
    BL delay_wrapper
    BL check_key      

    MOV R0, #0x00     
    BL ledShow        
    MOV R0, R0        
    BL disp_binary    

  
    MOV R0, #3       
    MOV R1, #1       
    BL delay_wrapper
    BL check_key      

    ADD R3, R3, #1    
    B flight_loop     

explosion:
    
    MOV R3, #0       
explosion_loop:
    CMP R3, R4        
    BGE reset_delay   

    MOV R0, #0xAA     
    BL ledShow        
    MOV R0, R0        
    BL disp_binary    

    
    MOV R0, #3        
    MOV R1, #1        
    BL delay_wrapper
    BL check_key      

    MOV R0, #0x55    
    BL ledShow        
    MOV R0, R0        
    BL disp_binary    

    
    MOV R0, #3       
    MOV R1, #1        
    BL delay_wrapper
    BL check_key      

    ADD R3, R3, #1    
    B explosion_loop  

reset_delay:
    
    MOV R7, #10000
    B launch         

check_key:
    MOV R0, #3        
    MOV R1, #1        
    BL keyHit        
    CMP R0, #0        
    BEQ continue_seq 

    BL turnOff        
    POP {R4, R5, R6, R7, LR}
    BX LR             

continue_seq:
    BX LR             

delay_wrapper:
    PUSH {LR}        
    MOV R0, R7        
    BL delay
    POP {LR}         
    MOV PC, LR       


  .global luciernagas
.extern ledShow
.extern disp_binary
.extern turnOff
.extern delayC

luciernagas:
    push {lr}              
    ldr r4, =pattern       
    mov r5, #12            
    mov r6, #2             

loop_start:
    ldrb r0, [r4]          
    bl ledShow             
    mov r1, r0             
    bl disp_binary         
    bl delay_wrapper       

    add r4, r4, #1         
    subs r5, r5, #1        
    bgt loop_start         

    bl turnOff             
    pop {lr}               
    mov pc, lr             

delay_wrapper:
    push {lr}              
    mov r0, r6             
    bl delay              
    pop {lr}               
    mov pc, lr             

pattern:
    .byte 0x00, 0x44, 0x80, 0x25, 0x60, 0x00, 0x3A, 0x91, 0x04, 0x00, 0x48, 0x00

