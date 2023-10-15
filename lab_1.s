.globl main
.text
.thumb
.syntax unified

main:
    MOV R0, #1                      // Enable port A clocking
    LDR R1, =0x42420308             // Address of bitband RCC_APB2ENR
    STR R0, [R1]                    // Enable port A clocking
    // port A clocking enabled

    LDR R0, =0x11111114             // Configure PA1 - PA7 in output push-pull mode
    LDR R1, =0x40010800             // Address of GPIOA_CRL
    STR R0, [R1]                    // Write new configuration to the GPIOA_CRL
    // GPIOA 1 - 7 configured as output push-pull, GPIOA_0 - is User button

begining:
    LDR R4, =0x42210100             // Bit-banding adress of the PA0 button (0 bit of GPIOA_IDR)
    MOV R5, #0                      // Reset counter
    LDR R6, =0xFFFFF                // Set delay
    B wait                          // Set indicator to zero state
    
read_button:
    LDR R2, [R4]                    // Reading of the button state
    CMP R2, #1
    BNE read_button                 // wait for button
increment:
    ADD R5, R5, #1                  // increment R5
    CMP R5, #10                     // check if counter > max value (9)
    BEQ begining                    // begin again

    LDR R6, =0xFFFFF                 // set counter
wait:
    CMP R6, #0x0                    // While delay_counter R6 > 0
    BEQ load_num                    // If R6 == 0 increment 7 segment indicator
    SUB R6, #0x1                    // Decrement delay_counter
    B wait                          // Return to the wait
load_num:

    LDR R0, =0x4001080C             // Address of GPIOA_ODR
    LDR R1, [R0]                    // Read GPIOA_ODR
    LDR R2, =0xFF01                 // Mask where 1 - 7 bits are 0, other are 1
    AND R1, R1, R2                  // Clear 1 - 7 pin (reset)
    STR R1, [R0]                    // Write Cleared ODR
    LDR R0, =0x40010810             // Address of GPIOA_BSRR

    TBB.W [PC, R5]                  // R5 - counter
branchtable:
    .byte ((indicate_0 - branchtable) / 2)
    .byte ((indicate_1 - branchtable) / 2)
    .byte ((indicate_2 - branchtable) / 2)
    .byte ((indicate_3 - branchtable) / 2)
    .byte ((indicate_4 - branchtable) / 2)
    .byte ((indicate_5 - branchtable) / 2)
    .byte ((indicate_6 - branchtable) / 2)
    .byte ((indicate_7 - branchtable) / 2)
    .byte ((indicate_8 - branchtable) / 2)
    .byte ((indicate_9 - branchtable) / 2)

indicate_0:
    LDR R1, =0xEE                   // 0xEE = simbol 0 in 7segment indicator
    STR R1, [R0]                    // Write to BSRR
    B read_button
    // 7 segment indicator is set to show '0'
indicate_1:
    LDR R1, =0x88                   // 0x88 = simbol 1 in 7segment indicator
    STR R1, [R0]                    // Write to BSRR
    B read_button
    // 7 segment indicator is set to show '1'
indicate_2:
    LDR R1, =0x7C                   // 0x7C = simbol 2 in 7segment indicator
    STR R1, [R0]                    // Write to BSRR
    B read_button
    // 7 segment indicator is set to show '2'
indicate_3:
     LDR R1, =0xDC                   // 0xDC = simbol 3 in 7segment indicator
     STR R1, [R0]                    // Write to BSRR
     B read_button
     // 7 segment indicator is set to show '3'
indicate_4:
     LDR R1, =0x9A                   // 0x9A = simbol 4 in 7segment indicator
     STR R1, [R0]                    // Write to BSRR
     B read_button
     // 7 segment indicator is set to show '4'
indicate_5:
     LDR R1, =0xD6                   // 0xD6 = simbol 5 in 7segment indicator
     STR R1, [R0]                    // Write to BSRR
     B read_button
     // 7 segment indicator is set to show '5'
indicate_6:
     LDR R1, =0xF6                   // 0xF6 = simbol 6 in 7segment indicator
     STR R1, [R0]                    // Write to BSRR
     B read_button
     // 7 segment indicator is set to show '6'
indicate_7:
     LDR R1, =0x8C                   // 0x8C = simbol 7 in 7segment indicator
     STR R1, [R0]                    // Write to BSRR
     B read_button
     // 7 segment indicator is set to show '7'
indicate_8:
     LDR R1, =0xFE                   // 0xFE = simbol 8 in 7segment indicator
     STR R1, [R0]                    // Write to BSRR
     B read_button
     // 7 segment indicator is set to show '8'
indicate_9:
     LDR R1, =0xDE                   // 0xDE = simbol 9 in 7segment indicator
     STR R1, [R0]                    // Write to BSRR
     B read_button
     // 7 segment indicator is set to show '9'

/* Scheme of connection
 ----2----
|         |         PA1 - PA7
1         3
|         |         ON  - high voltage
 ----4----          OFF - low voltage
|         |         
5         7
|         |
 ----6----     
*/