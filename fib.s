PORTB = $6000 ; lcd port B
PORTA = $6001 ; lcd port A
DDRB = $6002 ; data direction for port B
DDRA = $6003 ; data direction of port A

SHIFT = $600a
ACR = $600b

PCR = $600c
IFR = $600d
IER = $600e

value = $0200 ; 2 bytes
mod10 = $0202 ; 2 bytes
message = $0204; 6 bytes
counter = $020a; 2 bytes

x = $0210 ; 2 bytes
y = $0212 ; 2 bytes
z = $0214 ; 2 bytes
continue = $0001 ; 1 byte, zero page address

; lcd settings and status
E = %10000000 ; enable bit
RW = %01000000 ; read/write bit, 1 = read?
RS = %00100000 ; register select bit
CLEAR = %00000001 ; 
HOME = %00000010 ; 


    .org $8000 ; start program at $8000
reset:
    ldx #$ff ; initalise stack pointer to ff
    txs ; transfer to the stack pointer

    ; Configure interrupts
    cli ; Clear interup disable bit to enable interrupts

    lda #$82 ; Enable interrupt interface, Allow interrupts on CA1
    sta IER
    lda #$0 ; Set interrupt on button press (high to low transition)
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

initalise_fibb:
    lda #1
    sta x
    sta y
    lda #0
    sta x + 1
    sta y + 1
    sta z
    sta z + 1

loop:
    lda #0
    sta continue

    sei ; Disable interrupts
    lda z
    sta value
    lda z + 1 ; 16 bit number so load 1 byte at a time
    sta value + 1
    cli ; Enable interrupts

    jsr initalise_print

    ; z = y
    lda y
    sta z
    lda y + 1
    sta z + 1

    ; y = x
    lda x
    sta y
    lda x + 1
    sta y + 1

    ; x = y + z
    clc
    lda z
    adc y
    sta x

    lda z + 1
    adc y + 1 
    sta x + 1

wait:
    lda continue
    bne loop
    jmp wait

initalise_print:
    lda #HOME ; Cursor to home
    jsr lcd_instruction

    lda #0
    ldx #6
rest_message
    dex ; decrement x
    sta message, x
    bne rest_message

    ; Initalise value to number to convert
    ;sei ; Disable interrupts
    ;lda counter
    ;sta value
    ;lda counter + 1 ; 16 bit number so load 1 byte at a time
    ;sta value + 1
    ;cli ; Enable interrupts

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
    beq return ; return from printing sub routine
    jsr print_char
    inx
    jmp print
return:
    rts

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
    bne lcd_busy ; loop if lcd is busy

    lda #RW ; Switch off enable bit
    sta PORTA
    lda #%11111111 ; Set Port B to output
    sta DDRB
    pla ; Pull A back from STACK 
    rts

lcd_instruction:
    jsr lcd_wait ; Wait if lcd is busy
    sta PORTB ; Instruction in A out on port B
    lda #0 ;Clear RS/RW/E bits
    sta PORTA ; 
    lda #E ; Set enable bit to send instruction
    sta PORTA ; 
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

nmi: ; non maskable interrupt
    rti ; return from interrupt

irq: ; maskable interrupt
    pha
    lda IFR
    and #%00000010 ; Test for CA1 interrupt
    beq exit_irq ; Branch if not CA1
    lda #1
    sta continue
    txa
    pha
    ldx #$ff
debounce_loop:
    dex
    bne debounce_loop
    pla
    tax
exit_irq:
    bit PORTA ; Read port A to clear interrupt
    pla
    rti

    .org $fffa
    .word nmi ; non maskable interrupt vector
    .word reset ; rest vector
    .word irq ; interrupt request vector