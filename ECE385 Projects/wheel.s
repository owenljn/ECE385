/* MOVIA replacement */
.macro MOVI32 reg, val
  movhi \reg, %hi(\val)
  ori \reg, \reg, %lo(\val)
.endm

# Need to setup the symbols for "." "-" and " " for comparison
.equ dot, 0x2e #'.'
.equ dash, 0x2d #'-'
.equ space, 0x20 #' '

/* Device Addresses */
.equ ADDR_JP1, 0xFF200060              /* Address GPIO is set to JP1 */
.equ ADDR_TIMER, 0xFF202000            /* Set up the timer device */
.equ DIRECTION_REGISTER, 0x07f557ff      /* Configure the Direction Register */

/* Configure timer */
.equ MOTOR_FWD,  10000000              /* Turn motor on for 1ms */
.equ MOTOR_BWD, 10000000             /* Keep motor off for 1ms */
.equ MOTOR_FWD2,  28000000              /* Turn motor on for 1ms */
.equ MOTOR_BWD2, 37000000             /* Keep motor off for 1ms */
.equ MOTOR_OFF, 75000000             /* Keep motor off for 1ms */

.text
.global main

main:
	/* Load JP1 address and direction register */
	movi32 r8, ADDR_JP1
	movi32 r9, DIRECTION_REGISTER

	#motor one index
	movi32 r10, 0x0
	#motor one state
	movi32 r11, 0x0
	#motor two index
	movi32 r12, 0x0
	#motor two state
	movi32 r13, 0x0
	#motor three index
	movi32 r14, 0x0
	#motor three state
	movi32 r15, 0x0
	
	#initial guider wheel
	stwio r9, 4(r8)         /* Initialize Direction Register at base address + 4*/
	movi32 r9, 0xfffffcff   /* Start the guider wheel */
	stwio r9, 0(r8)
	
	# Ask the user to choose a color for printing
	call color
	movia r17, 0(r2)
	# we have a string argument
	#call stringify
	call strinkify
	#we have pointer to string
	movia r16, 0(r2)
	#character at index
	movi r18, space
	
	#get color
	ldw r19, 0(r17)
	
	br startloopy

startloopy:
	# Load the first character of the returned morse code
	ldb r18, 0(r16)
	# Exit the program if we reached the end of the string
	beq r18, r0, exit
	beq r19, 1 , motorGreen
	beq r19, 0 , motorRed
	
endloopy:
  # Increment the character counter
  addi r16, r16, 1
  br startloopy

motorGreen:
	# Print out the correct morse form by comparing the char to dot,dash and space
	beq r18, dash, dashGreen
	beq r18, dot, dotGreen
	beq r18, space, spaceGreen


motorStop:     /* motor stop */
	movi r9, 0xfffffcff
	stwio r9, 0(r8)
	br endloopy

motorRed:

	beq r18, dash, dashRed
	beq r18, dot, dotRed
	beq r18, space, spaceRed

# Interrupts for Green motor
dotGreen:
	movi32 r9, 0xfffffcfc    
	stwio r9, 0(r8)                        /* Remain on for forward */
	movi32 r4, MOTOR_FWD
	call countdown

	
	movi32 r9, 0xfffffcfe                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD
	call countdown
	br motorStop

dashGreen:
	movi32 r9, 0xfffffcfc    
	stwio r9, 0(r8)                        /* Remain on for forward */
	movi32 r4, MOTOR_FWD2
	call countdown
	
	movi32 r9, 0xfffffcfe                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD2
	call countdown
	br motorStop
spaceGreen:
	movi32 r9, 0xfffffcff    
	stwio r9, 0(r8)                        /* Remain off */
	movi32 r4, MOTOR_FWD2
	call countdown
	
	movi32 r9, 0xfffffcfe                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD2
	call countdown
	br motorStop
    

# Interrupts for red motor
dotRed:
	movi32 r9, 0xfffffcf3    
	stwio r9, 0(r8)                        /* Remain on for forward */
	movi32 r4, MOTOR_FWD
	call countdown

	
	movi32 r9, 0xfffffcfb                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD
	call countdown
	br motorStop

dashRed:
	movi32 r9, 0xfffffcf3    
	stwio r9, 0(r8)                        /* Remain on for forward */
	movi32 r4, MOTOR_FWD2
	call countdown
	
	movi32 r9, 0xfffffcfb                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD2
	call countdown
	br motorStop
spaceRed:
	movi32 r9, 0xfffffcff    
	stwio r9, 0(r8)                        /* Remain off */
	movi32 r4, MOTOR_FWD2
	call countdown
	
	movi32 r9, 0xfffffcfb                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD2
	call countdown
	br motorStop

exit:
	movi r9, 0xfffffcff
	stwio r9, 0(r8)
ret

countdown:
movi32 r22, ADDR_TIMER
/* Clear Timer */
movi32 r23, 0x0                        
stwio r23, 0(r22)
/* Write lower half of period */
mov r23, r4                            
andi r23, r23, 0x0000ffff
stwio r23, 8(r22)
/* Write upper half of period */
mov r23, r4                            
srli r23, r23, 16
stwio r23, 12(r22)
/* Start Timer */
movi32 r23, 0x4                       
stwio r23, 4(r22)
/* Check if timer has timed out */
	
keep_waiting:
ldwio r23, 0(r22)                      
andi r23, r23, 0x1
beq r0, r23, keep_waiting

ret


