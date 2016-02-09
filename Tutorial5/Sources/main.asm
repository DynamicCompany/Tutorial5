;*                       Mac University                              *
;*********************************************************************               
;*                      2DP4 Microcontrollers                        *
;*                            Tutorial 5                             *
;*                           Feb 9, 2016                             *
;*********************************************************************
;*********************************************************************
;*                       Tutorial 5 Companion Code                         
; BEFORE YOU START!!!!!!!!!!!!! READ THIS!!!!!!!!!!!!!!!!
;
; Read Tutorial 5
; This code does not contain any I/O beyond heatbeat LED
; Challenge 3/4 handle input/ output on the Esduino
;
; You will be jumping around alot as you enter and exit subroutines. 
; Use the SP and PC to keep yourself oriented
; The code is designed to go through each section of the subroutine 
; following the tutorial. Keep in mind you can use the software reset 
; restart the code if you get lost 
;
; There are 5 subroutines (labelled function1-function5). Each subroutine
; highlights a different part of the subroutine structure
;
; Follow along using Tutorial 5 to trace the code as it executes                                                          
;*********************************************************************
;*********************************************************************
;*                            References                             
;* Tutorial 5                                                            
;* HCS12/9S12 Textbook               
;* Instruction Set                                                    
;*                                                                   
;*********************************************************************
;*********************************************************************
;*                   Setup Code (Don't Change)                       
;*********************************************************************
; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry                  ; for absolute assembly: mark this as application entry point

; Include derivative-specific definitions 
		        INCLUDE 'derivative.inc' 
		        
ROMStart    EQU  $0400  ; absolute address to place my code/constant data

; variable/data section

            ORG RAMStart
 ; Insert here your data definition.


            ORG   ROMStart
_Startup
Entry
   
;*********************************************************************
;*                        CODE STARTS HERE                           *
;*********************************************************************
;*********************************************************************		        
;*                         ASSEMBLY FORMAT                           *
;*                                                                   *
;*                  LABEL OPERATION OPERAND COMMENT                  *
;*                                                                   *
;* LABEL: Must start in column 1 (check bottom corner to see col #)  *
;* OPERATION is a command to CPU/ Directive is a command to assembler*
;* OPERAND: Addressing Mode must be indicated in front of operand    *
;* COMMENT: Semi colon begins a comment. Makes code easier ot read   *
;*********************************************************************
;*********************************************************************
;*                       Tutorial 5 Companion Code                         
; BEFORE YOU START!!!!!!!!!!!!! READ THIS!!!!!!!!!!!!!!!!
;
; Read Tutorial 5
; This code does not contain any I/O beyond heatbeat LED (Port J)
; Challenge 3/4 handle input/ output on the Esduino
;
; You will be jumping around alot as you enter and exit subroutines. 
; Use the SP and PC to keep yourself oriented
; The code is designed to go through each section of the subroutine 
; following the tutorial. Keep in mind you can use the software reset 
; restart the code if you get lost 
;
; There are 5 subroutines (labelled function1-function5). Each subroutine
; highlights a different part of the subroutine structure
;
; Follow along using Tutorial 5 to trace the code as it executes                                                          
;*********************************************************************

; Your code will be stored starting at address $0400 (you can change it at line 31)

; Heartbeat LED Code 	
            LDS   #RAMEnd+1       ; initialize the stack pointer

            LDAA #$01
            STAA DDRJ             ; turn on uC LED to show "I'm alive!"
            STAA PTJ     ;

; Tutorial 5 Code 


; Tutorial 5 Page 24
; STACK
           LDS #$1607 

; Tutorial 5 Page 25
           LDAA #$02 ; Load Accumulator A
           PSHA      ; PUSH first item onto the stack

; Tutorial 5 page 26
           PULB      ; PULL item from stack and store in accumulator B  
                    
; Tutorial 5 Page 27
           LDAA #$FF ; Load Accumulator A
           PSHA      ; What Happens?
           
; SUBROUTINES    
; We first need a subroutine (I have labelled it "function" that we will jump to when we trigger the subroutine). 
; You can find it at the buttom of the code     

; Now we can start building our subroutine

; Tutorial 5 Page 40 (IMPORTANT- READ SLIDE 41 BEFORE CONTINUING!!!)
          LDS #$1607; Reset our stack pointer for our new subroutine
          BSR FUNCTION1; Go to Function1 below. Look at the instruction sheet! What three things happen? FUNCTION1 IS STORED IN MEMORY ADDRESS $041A                          
          
          
; Tutorial 5 page 45-46
          LDS #$1607; Reset our stack pointer for our new subroutine
          LDAA #$01; Store something in A
          LDAB #$02; Store something in B
          BSR FUNCTION2; Go to Function2 below. Keep in mind that FUNCTION2 is stored in memory address $0423
          
          STAA PTJ; Resume Code  Turns off uC LED

; Tutorial 5 page 47-49
          LDS #$1607; Reset our stack pointer for our new subroutine
          LDAA #$03; Our first input paramter
          LDAB #$07; Our second input parameter
          PSHA; store our input parameters on the stack
          PSHB; store our input parameters on the stack 
          BSR FUNCTION3; Go to Function3 below. Keep in mind that FUNCTION3 is stored in memory address $0431
          
          STAA PTJ; Resume Code  Turns on uC LED   
          LDA      

; Tutorial 5 page 50- 59
          LDS #$1607; Reset our stack pointer for our new subroutine
          BSR FUNCTION4; Go to Function4 below. Keep in mind that FUNCTION4 is stored in memory address $0439
          
          STAA PTJ; Resume Code  Turns off uC LED
          
          WAI ; what happens if your remove this WAI and keep clicking assembly step?
 

;*********************************************************************
; OUR SUBROUTINES AKA FUNCTIONS!
;*********************************************************************
          
; Tutorial 5 Page 42 Subroutine                                                                       
FUNCTION1 RTS    ;this is our subroutine!  in this case all we do is return! Look at the datasheet! What two things happen?

; Tutorial 5 Page 43 Subroutine                                                                  
FUNCTION2 PSHA; subroutine setup (Page 45)  
          PSHB; subroutine setup
          
          ;lets do something with our subroutine
          LDAA #$06; lets overwrite A 
          LDAB #$06; lets overwrite B
          
          ;subroutine cleanup (Page 46)
          PULA; what happens?
          PULB        
          
          ;subroutine exit (Page 42)
          RTS     

; Tutorial 5 Page 47 Subroutine 
FUNCTION3 RTS    ;Notice that the return address is NOT the first thing in the stack  

; Tutorial 5 Page 58 Subroutine
FUNCTION4  LEAS -4, SP ; (Page 53) allocate 4 memory locations for local variables
           LDAA #$00 
           STAA 1,SP ; store the accumulator value in our temporary variable 
           LDAB 1,SP ; save the value from our temporary variable in accumulator B
           LEAS 4, SP; (Page 59) Deallocate 4 memory locations used by local varaibles
           RTS    
      
;*********************************************************************
;*                Interrupt Vectors (Don't Change)                   *
;*********************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector           