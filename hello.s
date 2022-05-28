PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

E = %10000000
RW = %01000000
RS = %00100000

    .org $8000
    
reset:
    lda #%11111111 ; Set all pins on port B to out
    sta DDRB

    lda #%11100000 ; Set first 3 pins on port A to out
    sta DDRA


    lda #%00111000 ; 8 bit mode, 2-line display, 5x8 font
    sta PORTB

    lda #0 ;Clear RS/RW/E bits
    sta PORTA

    lda #E ; Set enable bit to send instruction
    sta PORTA

    lda #0 
    sta PORTA


    lda #%00001110 ; display on, curser on, blink off
    sta PORTB

    lda #0 ;Clear RS/RW/E bits
    sta PORTA

    lda #E ; Set enable bit to send instruction
    sta PORTA

    lda #0 
    sta PORTA


    lda #%00000110 ; increment for new character, dont shift display
    sta PORTB

    lda #0 ;Clear RS/RW/E bits
    sta PORTA

    lda #E ; Set enable bit to send instruction
    sta PORTA

    lda #0 
    sta PORTA


    lda #"H"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA


    lda #"E"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA


    lda #"L"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA


    lda #"L"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA

    lda #"O"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA

    lda #" "
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA

    lda #"W"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA

    lda #"O"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA

    lda #"R"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA

    lda #"L"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA

    lda #"D"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA

    lda #"!"
    sta PORTB

    lda #RS ; Set RS to send data
    sta PORTA

    lda #(E | RS) ; Set E bit to send instruciton (bitwise or)
    sta PORTA

    lda #RS ; Clear E
    sta PORTA

loop:
    jmp loop

    .org $fffc
    .word reset
    .word $0000