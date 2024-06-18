.text
.global cohete

.extern disp_binary
.extern ledShow
.extern delay
.extern turnOff

cohete:
    PUSH {R4, R5, R6, R7, LR}   

    MOV R4, #10                  
    MOV R5, #0x01               

launch:
    BL printf                   
    MOV R4, #8                   
    MOV R6, #700                 

launch_loop:
    CMP R4, #0                   
    BEQ flight                 

    MOV R5, #0x01                
    B launch_loop_inner          

flight:
    BL printf                   
    MOV R4, #5                  
    MOV R6, #10000               

flight_loop:
    CMP R4, #0                  
    BEQ explosion               

    MOV R5, #0xFF                
    BL ledShow                  
    MOV R0, R5                   
    BL disp_binary              
    MOV R0, R6                   
    BL delay                     

    MOV R5, #0x00               
    BL ledShow                  
    MOV R0, R5                   
    BL disp_binary               
    MOV R0, R6                  
    BL delay                     

    SUBS R4, R4, #1              
    B flight_loop                
explosion:
    BL printf                   
    MOV R4, #10                 
    MOV R6, #10000               

explosion_loop:
    CMP R4, #0                  
    BEQ reset_delay              

    MOV R5, #0xAA               
    BL ledShow                   
    MOV R0, R5                  
    BL disp_binary              
    MOV R0, R6                   
    BL delay                    

    MOV R5, #0x55               
    BL ledShow                   
    MOV R0, R5                   
    BL disp_binary               
    MOV R0, R6                   
    BL delay                    

    SUBS R4, R4, #1             
    B explosion_loop            

reset_delay:
    MOV R6, #10000              
    B launch                     

.end
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

.extern disp_binary
.extern ledShow
.extern delay
.extern turnOff

luciernagas:
    PUSH {R4, R5, LR}          
    LDR R4, =pattern           
    MOV R5, #12               

loop_luciernagas:
    LDR R6, [R4], #4           
    BL ledShow                
    MOV R0, R6                 
    BL disp_binary            
    MOV R0, #2                 
    BL delay                  

    CMP R0, #0                
    BEQ exit_luciernagas     

    SUBS R5, R5, #1            
    BNE loop_luciernagas      
    B loop_luciernagas        

exit_luciernagas:
    BL turnOff                
    POP {R4, R5, PC}          

.data
pattern:
    .word 0x00, 0x44, 0x80, 0x25, 0x60, 0x00, 0x3A, 0x91, 0x04, 0x00, 0x48, 0x00  

.end

