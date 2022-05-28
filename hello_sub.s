PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

E = %10000000
RW = %01000000
RS = %00100000

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

    lda #"H"
    jsr print_char

    lda #"E"
    jsr print_char

    lda #"L"
    jsr print_char

    lda #"L"
    jsr print_char

    lda #"O"
    jsr print_char

    lda #" "
    jsr print_char

    lda #"W"
    jsr print_char

    lda #"O"
    jsr print_char

    lda #"R"
    jsr print_char

    lda #"L"
    jsr print_char

    lda #"D"
    jsr print_char

    lda #"!"
    jsr print_char

loop:
    jmp loop

lcd_instruction:
    sta PORTB
    lda #0 ;Clear RS/RW/E bits
    sta PORTA
    lda #E ; Set enable bit to send instruction
    sta PORTA
    lda #0 ; Clear enable bit
    sta PORTA
    rts

print_char:
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