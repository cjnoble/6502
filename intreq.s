PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

SHIFT = $600a
ACR = $600b

PCR = $600c
IFR = $600d
IER = $600e

value = $0200 ; 2 bytes
mod10 = $0202 ; 2 bytes
message = $0204; 6 bytes
counter = $020a; 2 bytes

E = %10000000
RW = %01000000
RS = %00100000
CLEAR = %00000001
HOME = %00000010 

    .org $8000
reset:
    ldx #$ff ; initalise stack pointer to ff
    txs

    ; Configure interupts
    cli ; Clear interup disable bit to enable interupts

    lda #$82 ; Enable interupt interface, Allow interupts on CA1
    sta IER
    lda #$0 ; Set interupt on button press (high ot low transition)
    sta PCR

    ; Configure interface ports
    lda #%11111111 ; Set all pins on port B to out
    sta DDRB

    lda #%11100000 ; Set first 3 pins on port A to out
    sta DDRA

lcd_rest:
    lda #%00111000 ; 8 bit mode, 2-line display, 5x8 font
    jsr lcd_instruction

    lda #%00001110 ; display on, curser on, blink off
    jsr lcd_instruction

    lda #%00000110 ; increment for new character, dont shift display
    jsr lcd_instruction

    lda #CLEAR ; Clear display
    jsr lcd_instruction

initalise_counter:
    ; Initalise counter to zero
    lda #0
    sta counter
    sta counter + 1

initalise_print:
    lda #HOME ; Cursor to home
    jsr lcd_instruction

    lda #0
    sta message

    ; Initalise value to number to convert
    sei ; Disable interupts
    lda counter
    sta value
    lda counter + 1 ; 16 bit number so load 1 byte at a time
    sta value + 1
    cli ; Enable interupts

divide:
    ; Initalise remainder to zero
    lda #0 
    sta mod10
    sta mod10 + 1
    clc ; clear carry bit

    ldx #16 ; Loop 16 times
divloop:
    ; Rotate quotient and remainder
    rol value
    rol value + 1
    rol mod10
    rol mod10 + 1

    ; a, y = dividend - divisor
    sec ; set the carry bit
    lda mod10
    sbc #10
    tay ; save the low byte into Y register
    lda mod10 + 1
    sbc #0 ; high byte into A register

    bcc ignore_result ; Branch if carry bit not set, meaning we DID do a carry - means branch if dividend < divisor
    ; If not, means that we save the result, beacause dividend > divisor
    sty mod10
    sta mod10 + 1
ignore_result:
    dex
    bne divloop ; Loop if x is not zero 

    rol value ; shift carry  bit into last bit of quotient
    rol value + 1

    ; Get the answer and display
    lda mod10
    clc
    adc #"0" ; Add to 0 ascii to get ascii representarion
    jsr push_char

    ; Check if value or value plus 1 are zero
    lda value
    ora value + 1
    bne divide ; Contunue if not done

; print_message
    ldx #0
print:    
    lda message,x
    beq loop
    jsr print_char
    inx
    jmp print

loop:
    jmp initalise_print

number: .word 172


; Add char in A register to beggining of message
push_char:
    pha ; push A onto Stack
    ldy #0
char_loop:
    lda message, y
    tax ; move to X
    pla ; pull A from stack
    sta message, y
    iny
    txa
    pha ; push X to Stack
    bne char_loop ;If next char is not zero then loop

    pla
    sta message, y ; Pull null from stack and add to string

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

nmi:
    rti

irq:
    pha
    lda IFR
    and #%00000010 ; Test for CA1 Interupt
    beq exit_irq ; Branch if not CA1
    inc counter
    bne exit_irq ; Ceck if roll over
    inc counter + 1 ; If we did roll over then incrementr next byte
exit_irq:
    bit PORTA ; Read port A to clear interupt
    pla
    rti

    .org $fffa
    .word nmi ; non maskable interupt vector
    .word reset ; rest vector
    .word irq ; #interupt request vector