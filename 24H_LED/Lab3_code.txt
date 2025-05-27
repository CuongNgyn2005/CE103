$NOMOD51
$INCLUDE (8051.MCU)

org 0000h
    LJMP START

START:
    MOV R0, #0 ;FRACTION OF SEC
    MOV R1, #0  ; Hours
    MOV R2, #0  ; Minutes
    MOV R3, #0  ; Seconds
    
MAIN:
    ;== increments
    INC R0
    CJNE R0, #60, DISPLAY_TIME
    MOV R0, #0
    
    INC R3
    CJNE R3, #60, DISPLAY_TIME
    MOV R3, #0
    
    INC R2
    CJNE R2, #60, DISPLAY_TIME
    MOV R2,#0
    INC R1
    CJNE R1, #24, DISPLAY_TIME
    MOV R1,#0
    SJMP MAIN

DISPLAY_TIME:
    ACALL DISPLAY_SEC
    ACALL DISPLAY_MIN
    ACALL DISPLAY_HOUR
    SJMP MAIN   
DISPLAY_SEC:
   MOV A,R3
   MOV B, #10
   DIV AB
   MOV P2,B
   MOV P3,#00H
   SETB P3.5
   ACALL DELAY
   CLR P3.5
   
   MOV P2,A
   MOV P3,#00H
   SETB P3.4
   ACALL DELAY
   CLR P3.4
   DJNZ R6, DELAY
   SJMP MAIN
DISPLAY_MIN:
    MOV A, R2
    MOV B, #10
    DIV AB

    MOV P2, B
    MOV P3, #00H
    SETB P3.3
    ACALL DELAY
    CLR P3.3

    MOV P2, A
    MOV P3, #00H
    SETB P3.2
    ACALL DELAY
    CLR P3.2
    RET
DISPLAY_HOUR:
    MOV A, R1
    MOV B, #10
    DIV AB

    MOV P2, B
    MOV P3, #00H
    SETB P3.1
    ACALL DELAY
    CLR P3.1

    MOV P2, A
    MOV P3, #00H
    SETB P3.0
    ACALL DELAY
    CLR P3.0
    RET

DELAY:
    MOV TMOD, #01H ; Timer 0 mode 1
    MOV TH0, #0F7H       
    MOV TL0, #28H
    SETB TR0
WAIT:
    JNB TF0, $    
    CLR TF0
    CLR TR0
    RET
END
