PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

E = %10000000
RW = %01000000
RS = %00100000

CLEAR = %00000001

    .org $8000
    
reset:
    ldx #$ff ; initalise stack pointer to ff
    txs

    lda #%11111111 ; Set all pins on port B to out
    sta DDRB

    lda #%11100000 ; Set first 3 pins on port A to out
    sta DDRA

    lda #%00111000 ; 8 bit mode, 2-line display, 5x8 font
    jsr lcd_instruction

    lda #%00001110 ; display on, curser on, blink off
    jsr lcd_instruction

    lda #%00000110 ; increment for new character, dont shift display
    jsr lcd_instruction

    lda #CLEAR ; Clear display
    jsr lcd_instruction

    ldx #0
print:    
    lda message,x
    beq loop
    jsr print_char
    inx
    jmp print

loop:
    jmp loop

message: .asciiz "Hello, world!"

lcd_wait:
    pha ; push current value in A register to STACK
    lda #%00000000 ; Set Port B to input
    sta DDRB
lcd_busy:
    lda #RW ;Set RW bit to enable reading of busy flag
    sta PORTA
    lda #(E | RW) ; Set enable bit
    sta PORTA

    lda PORTB ; Read from Port B
    and #%10000000 ; Check for busy flag bit only
    bne lcd_busy

    lda #RW ; Switch off enable bit
    sta PORTA
    lda #%11111111 ; Set Port B to output
    sta DDRB
    pla ; Pull A back from STACK 
    rts

lcd_instruction:
    jsr lcd_wait
    sta PORTB
    lda #0 ;Clear RS/RW/E bits
    sta PORTA
    lda #E ; Set enable bit to send instruction
    sta PORTA
    lda #0 ; Clear enable bit
    sta PORTA
    rts

print_char:
    jsr lcd_wait
    sta PORTB
    lda #RS ; Set RS to send data
    sta PORTA
    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA
    lda #RS ; Clear E
    sta PORTA
    rts

    .org $fffc
    .word reset
    .word $0000