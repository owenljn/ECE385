# Include nios_macros.s to workaround a bug in the movia pseudo-instruction.
#.include "nios_macros.s"

.equ RED_LEDS, 0x10000000
.equ GREEN_LEDS, 0x10000010     # (Hint: See DESL website for documentation on LEDs)

.data                  # "data" section for input and output lists

IN_LIST:               # List of 10 words starting at location IN_LIST
    .word 1
    .word -1
    .word -2
    .word 2
    .word -3
    .word 100
    .word 0xffffff9c
    .word 0x100
    .word 0b111
	.word 0
    
OUT_NEGATIVE:
	.skip 40 # Reserve space for 10 output words
	
    
OUT_POSITIVE:
    .skip 40            # Reserve space for 10 output words


.text
#-----------------------------------------
.global main

main:          # "text" section for (read-only) code
	movi r2, 0
	movi r3, 0
	
	movia r15, OUT_NEGATIVE # neg array adr
	movia r16, OUT_POSITIVE # pos array adr 
	
	movia r11, IN_LIST # gets address of inlist
	
	movi r8, 0 # INDEX of the loop
	movi r9, 20 # SIZE of IN_LIST
	
	movia  r17, RED_LEDS          # r17 is a temporary value
	movia  r18, GREEN_LEDS
	
	
	/* There was a bug where r9 is set to 10000000 to work as a delay counter, however r20 used below was never
	 initialized. The code here was originally "movia r9,  10000000", now it's moved inside the loop and
	 r20 is now the counter */


loop:
	ldw r12, 0(r11) # dereferences the pointer @ index
	# branch if INDEX > SIZE -> LOOP_FOREVER
	beq r8, r9, LOOP_FOREVER
	
	bge r12, r0, NUM_POS
		stw r12, 0(r15)
		addi r15, r15, 4
		addi r2, r2, 1
		br ENDIF
	NUM_POS:
		stw r12, 0(r16)
		addi r16, r16, 4
		addi r3, r3, 1
		br ENDIF # This line is added so that it goes to branch ENDIF correctly
	ENDIF:
		addi r11,r11,4
		addi r8,r8,1
		
		stwio  r2, 0(r17)             # Send r2 out to the red LEDs device
		stwio  r3, 0(r18)    		  # Send r3 out to the green LEDs device
		movia r20,  10000000          # set delay timer
		call DELAY
		

		
Terminate:
    Exit                   # Exit the program.
	
LOOP_FOREVER:
	beq r12, r0, Terminate    # Exit the program since the last element of the list is zero
    br LOOP_FOREVER                   # Loop forever if the last element of the list is not zero.

DELAY:						/* Delay loop to slow down */
  subi  r20,  r20, 1			/*   the program */
  bne   r20,  r0, DELAY
  br loop
	
