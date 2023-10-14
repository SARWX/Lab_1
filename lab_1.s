.globl main
.text
.thumb
.syntax unified

main:
    LDR R1, =0x40021018             // CHECK ADDRESS OF RCC_APB2ENR
    LDR R0, [R1]                    // CHECK ADDR RCC_APB2ENR


    MOV R0, #1                      // Enable port A clocking
    LDR R1, =0x42420340             // Address of bitband RCC_APB2ENR
    STR R0, [R1]                    // Enable port A clocking

    LDR R1, =0x40021018             // CHECK ADDRESS OF RCC_APB2ENR
    LDR R0, [R1]                    // CHECK ADDR RCC_APB2ENR
    MOV R0, #4      // enable GPIOA
    STR R0, [R1]    // write enable
    LDR R0, [R1] 

    LDR R0, =0x11111114             // Configure PA1 - PA7 in output push-pull mode
    LDR R1, =0x40010800               // Address of GPIOA_CRL
    LDR R2, [R1]                    // Load GPIOA_CRL into R2
    BFI R2, R0, #0x0, #0x1C         // Insert configuration into GPIOA_CRL
    STR R2, [R1]                    // Write new configuration to the GPIOA_CRL

    LDR R0, =0x40010810             // Address of GPIOA_BSRR
    LDR R1, =0x20000                // TEST enable GPIOA_1
    STR R1, [R0]                    // Write to BSRR
    MOV R1, #2                      // TEST enable GPIOA_1
    STR R1, [R0]                    // Write to BSRR



    LDR R4, =0x42210100     @       Bit-banding adress of the PA0 button (0 bit of GPIOA_IDR)
    MOV R5, #0              // Counter
    
read_button:
    LDR R2, [R4]            @       Reading of the button state
    CMP R2, #1
    BNE read_button                 // wait for button
increment:
    ADD R5, R5, #1                  // increment R5
    LDR R6, =0xFFFF
wait:
    CMP R6, #0x0            @       While counter R0 > 0
    BEQ load_num              @       If R0 == 0 toggle led
    SUB R6, #0x1            @       Decrement counter
    B wait                  @       Return to the wait
load_num:
    LDR R0, =0x40010814            // BRR
    LDR R1, =0xFFFF                    // Clear
    STR R0, [R1]                    // Clear GPIOA

    LDR R0, =0x40010810         // BSRR
    LDR R1, =0xEE               // write 0
    STR R1, [R0]
    B read_button

check_num:
    LDR R0, =0x40010810
    CMP R5, #0
    BNE check_1
    LDR R1, =0xEE               // write 0
    STR R1, [R0]
    B read_button

check_1:
    CMP R5, #1
    BNE check_2
    LDR R1, =0x88               // write 1
    STR R1, [R0]
    B read_button 

check_2:
    CMP R5, #1
    BNE read_button
    LDR R1, =0x7C               // write 1
    STR R1, [R0]
    B read_button 
    





infinite_loop:
    B infinite_loop
