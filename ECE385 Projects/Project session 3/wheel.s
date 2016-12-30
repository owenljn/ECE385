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
.equ MOTOR_FWD, 10000000              /* Turn motor on for 1ms */
.equ MOTOR_BWD, 10000000             /* Keep motor off for 1ms */
.equ MOTOR_FWD2, 35000000              /* Turn motor on for 3.5ms */
.equ MOTOR_BWD2, 45000000             /* Keep motor off for 4.5ms */
.equ MOTOR_FWD3, 50000000              /* Turn motor on for 5.0ms */
.equ MOTOR_BWD3, 70000000             /* Keep motor off for 7.0ms */
.equ MOTOR_OFF, 75000000             /* Keep motor off for 7.5ms */

.text
.global main

main:
	/* Load JP1 address and direction register */
	movi32 r8, ADDR_JP1
	movi32 r9, DIRECTION_REGISTER
	
	#initial guider wheel
	stwio r9, 4(r8)         /* Initialize Direction Register at base address + 4*/
	movi32 r9, 0xfffffcfa  /* Start the guider wheel */
	stwio r9, 0(r8)
	

	# Ask the user to choose a color for printing
	call color
	mov r17, r2

	
	#call stringify
	call strinkify
	#we have pointer to string
	mov r18, r2
	
	#movi32 r8, ADDR_JP1
	#movi32 r9, DIRECTION_REGISTER
	#movi32 r9, 0xfffffcf0  
	#stwio r9, 0(r8)
	
	br startloopy

startloopy:
	movi32 r10, 1
	movi32 r11, 0
	
	ldb r16, 0(r18)
	beq r16, r0, exit
	beq r17, r10, motorGreen
	beq r17, r11, motorRed
	
endloopy:
  # Increment the character counter
  movi32 r9, 0xfffffcfa  
  stwio r9, 0(r8)
  addi r18, r18, 1
  br startloopy

motorGreen:
	# Print out the correct morse form by comparing the char to dot,dash and space
	movi r10, dash
	movi r11, dot
	movi r12, space # Load dash, dot, and space into registers
	
	beq r16, r10, dashGreen
	beq r16, r11, dotGreen
	beq r16, r12, spaceGreen
	


motorStop:     /* motor stop */
	movi r9, 0xfffffcfa
	stwio r9, 0(r8)
	br endloopy

motorRed:

	movi r10, dash
	movi r11, dot
	movi r12, space # Load dash, dot, and space into registers
	beq r16, r10, dashRed
	beq r16, r11, dotRed
	beq r16, r12, spaceRed

# Interrupts for Green motor
dotGreen:

    movi32 r8, ADDR_JP1
	movi32 r9, DIRECTION_REGISTER
	movi32 r9, 0xfffffcf2   # 0010 green prints
	stwio r9, 0(r8)                        /* Remain on for forward */
	movi32 r4, MOTOR_FWD
	call countdown


	movi32 r9, 0xfffffcfa  # 1010 both on hold                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD
	call countdown
	br motorStop

dashGreen:
    movi32 r8, ADDR_JP1
	movi32 r9, DIRECTION_REGISTER
	movi32 r9, 0xfffffcf2    
	stwio r9, 0(r8)                        /* Remain on for forward */
	movi32 r4, MOTOR_FWD2
	call countdown
	
	movi32 r9, 0xfffffcfa                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD2
	call countdown
	br motorStop
spaceGreen:
    movi32 r8, ADDR_JP1
	movi32 r9, DIRECTION_REGISTER
	movi32 r9, 0xfffffcff    
	stwio r9, 0(r8)                        /* Remain off */
	movi32 r4, MOTOR_FWD3
	call countdown
	
	movi32 r9, 0xfffffcfa                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD3
	call countdown
	br motorStop
    

# Interrupts for red motor
dotRed:
    movi32 r8, ADDR_JP1
	movi32 r9, DIRECTION_REGISTER
	movi32 r9, 0xfffffcf8  
	stwio r9, 0(r8)
	
                     /* Remain on for forward */
	movi32 r4, MOTOR_FWD
	call countdown

	
	
	movi32 r9, 0xfffffcfa                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD
	call countdown
	br motorStop

dashRed:

    movi32 r8, ADDR_JP1
	movi32 r9, DIRECTION_REGISTER
	movi32 r9, 0xfffffcf8    
	stwio r9, 0(r8)                        /* Remain on for forward */
	movi32 r4, MOTOR_FWD2
	call countdown
	
	movi32 r9, 0xfffffcfa                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD2
	call countdown
	br motorStop
spaceRed:

    movi32 r8, ADDR_JP1
	movi32 r9, DIRECTION_REGISTER
	movi32 r9, 0xfffffcf8    
	stwio r9, 0(r8)                        /* Remain off */
	movi32 r4, MOTOR_FWD3
	call countdown
	
	movi32 r9, 0xfffffcfa                 /* Then remain on for backward */
	stwio r9, 0(r8)
	movi32 r4, MOTOR_BWD3
	call countdown
	br motorStop

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

# Exit the program when printer finishes printing
exit:
    movi32 r8, ADDR_JP1
	movi32 r9, DIRECTION_REGISTER
	movi r9, 0xffffffff
	stwio r9, 0(r8)
	br exit

