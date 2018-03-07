; The following lines embed configuration data into the PICmicro
	LIST P=16F84A			; PIC being used
	__CONFIG H'3FFA'      	; sets to HS (high speed) mode, allows operation at 20MHz and higher current.
	
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
; Declaration				
		#DEFINE	PAGE0	BCF	STATUS,5	; defining pages.
		#DEFINE	PAGE1	BSF	STATUS,5	; defining pages.
.
		STATUS	EQU		H'03'		; Assigns word STATUS to the value of H'03' which is the address of the STATUS REGISTER.	Special Function Registers (SFR), The SFRs control the operation of the device
		TRISA	EQU		H'85'		; Assigns word TRISA to the value of H'85' which is the address of the TRISA REGISTER.		Special Function Registers (SFR), The SFRs control the operation of the device
		PORTA	EQU		H'05'		; Assigns word PORTA to the value of H'05' which is the address of the PORTA REGISTER.		Special Function Registers (SFR), The SFRs control the operation of the device
		TRISB	EQU		H'86'		; Assigns word TRISB to the value of H'86' which is the address of the TRISB REGISTER.		Special Function Registers (SFR), The SFRs control the operation of the device
		PORTB	EQU		H'06'		; Assigns word PORTB to the value of H'06' which is the address of the PORTB REGISTER.		Special Function Registers (SFR), The SFRs control the operation of the device
		CRTL1	EQU		H'20'		; Assigns word CTRL1 to the value of H'20' which is an empty address we can use.			General Purpose Registers (GPR), the GPR is used for general operations of the device
		CRTL2	EQU		H'21'		; Assigns word CTRL2 to the value of H'20' which is an empty address we can use				General Purpose Registers (GPR), the GPR is used for general operations of the device
		CRTL3	EQU		H'22'		; Assigns word CTRL3 to the value of H'20' which is an empty address we can use.			General Purpose Registers (GPR), the GPR is used for general operations of the device
				
				
		ORG		0			; Reset vector
		GOTO	5			; Goto start of program
		ORG		4			; Interrupt vector
		GOTO	5			; Goto start of program
		ORG		5			; Start of program memory

; program initialisation		
		BSF	STATUS,5		; Switch to page 1, TRISTATES can be accessed in PAGE1
		CLRF	TRISB		; Sets PORTB as OUTPUTS
		MOVLW	B'00011111'	; Selecting RA0-RA4
		MOVWF	TRISA		; Sets RA0-RA4 as INPUTS
		BCF	STATUS,5		; Switch to page 0, PORTS can be accessed in PAGE0
		CLRF	PORTB		; Clear PORTB register (reset)
		PAGE0				; PAGE0

; program
FWD		
		MOVLW	B'01010000'	; Selecting B6 and B4 which drives the car forward
		MOVWF	PORTB		; Moving B5 and B7 to the working register of PORTB
		BTFSC	PORTA,0		; Bit check A0, if low skip
		GOTO	RIGHT_BACK	; If A0 is low this will be skipped, if it is high then it goes to address RIGHT_BACK
		BTFSC	PORTA,1		; Bit check A1, if low skip
		GOTO	LEFT_BACK	; If A1 is low this will be skipped, if it is high then it goes to address RIGHT_BACK
		GOTO	FWD			; Loops FWD again, car will continuously go forward unless A0 or A1 are high

		
RIGHT_BACK					; The car here will reverse for 15cm then turn right for 90 degrees
		CLRF	PORTB		; Clear working registry of portB, this will stop the car from moving forward
		MOVLW	B'10100110'	; Selecting B7 and B5 which drives the car backwards, B1 and B2 are LED's which indicates reversing
		MOVWF	PORTB		; Moving B7, B5, B1 and, B2 to the working register of PORTB
		MOVLW	D'50'		; Selcting a decimal value of 50
		MOVWF	CRTL1		; Moving Decimal 50 to working register of CRTL1
		MOVLW	D'100'		; Selcting a decimal value of 100
		MOVWF	CRTL2		; Moving Decimal 50 to working register of CRTL2
		MOVLW	D'15'		; Selcting a decimal value of 15
		MOVWF	CRTL3		; Moving Decimal 15 to working register of CRTL3
		CALL	BUZZER		; CALLS BUZZER loop which is a delay loop containing activation of the buzzer, BUZZER indicates sensors touching

		CLRF	PORTB		; Clear working registry of portB, this will stop the car from moving backwards
		MOVLW	B'01100100'	; Selecting B6 and B5 which drives the car right, B2 is an LED's which indicates turning right
		MOVWF	PORTB		; Moving B6, B5 and, B2 to the working register of PORTB
		MOVLW	D'50'		; Selcting a decimal value of 50
		MOVWF	CRTL1		; Moving Decimal 50 to working register of CRTL1
		MOVLW	D'100'		; Selcting a decimal value of 100
		MOVWF	CRTL2		; Moving Decimal 100 to working register of CRTL2
		MOVLW	D'10'		; Selcting a decimal value of 15
		MOVWF	CRTL3		; Moving Decimal 10 to working register of CRTL3
		CALL	DELAY		; CALLS DELAY loop which is a delay loop 

		GOTO	FWD			; Goes back to FWD Loop

LEFT_BACK					; The car here will reverse for 15cm then turn left for 90 degrees.
		CLRF	PORTB		; Clear working registry of portB, this will stop the car from moving forward
		MOVLW	B'10100110'	; Selecting B7 and B5 which drives the car backwards, B1 and B2 are LED's which indicates reversing
		MOVWF	PORTB		; Moving B7, B5, B1 and, B2 to the working register of PORTB
		MOVLW	D'50'		; Selcting a decimal value of 50
		MOVWF	CRTL1		; Moving Decimal 50 to working register of CRTL1
		MOVLW	D'100'		; Selcting a decimal value of 100
		MOVWF	CRTL2		; Moving Decimal 50 to working register of CRTL2
		MOVLW	D'15'		; Selcting a decimal value of 15
		MOVWF	CRTL3		; Moving Decimal 15 to working register of CRTL3
		CALL	BUZZER		; CALLS BUZZER loop which is a delay loop containing activation of the buzzer, BUZZER indicates sensors touching

		CLRF	PORTB		; Clear working registry of portB, this will stop the car from moving backwards
		MOVLW	B'10010010'	; Selecting B7 and B4 which drives the car left, B1 is an LED's which indicates turning left
		MOVWF	PORTB		; Moving B7, B4, and, B1 to the working register of PORTB
		MOVLW	D'50'		; Selcting a decimal value of 50
		MOVWF	CRTL1		; Moving Decimal 50 to working register of CRTL1
		MOVLW	D'100'		; Selcting a decimal value of 100
		MOVWF	CRTL2		; Moving Decimal 50 to working register of CRTL2
		MOVLW	D'10'		; Selcting a decimal value of 10
		MOVWF	CRTL3		; Moving Decimal 10 to working register of CRTL3
		CALL	DELAY		; CALLS DELAY loop which is a delay loop 

		GOTO	FWD			; Goes back to FWD Loop

;DELAYS			
BUZZER						; DELAY with buzzer activated, the Buzzer is required to oscillate. Therefore turning it off and on again will result in it ringing.
		BSF		PORTB,0		; Bit setting B0 as high
		DECFSZ	CRTL1,1		; Decrementing CTRL1 by 1 from the set values above, skips when it hits 0
		GOTO	BUZZER		; Goes back to buzzer to loop around until CTRL1 has decremented to 0
		BCF		PORTB,0		; Bit setting B0 as low
		DECFSZ	CRTL2,1		; Decrementing CTRL2 by 1 from the set values above, skips when it hits 0
		GOTO	BUZZER		; Goes back to buzzer to loop around until CTRL2 has decremented to 0
		BCF		PORTB,0		; Bit setting B0 as low
		DECFSZ	CRTL3,1		; Decrementing CTRL3 by 1 from the set values above, skips when it hits 0
		GOTO	BUZZER		; Goes back to buzzer to loop around until CTRL3 has decremented to 0
		BCF		PORTB,0		; Bit setting B0 as low
		RETURN				; RETURNS to where the CALL was activated
			
DELAY						; DELAY with no buzzer
		DECFSZ	CRTL1,1		; Decrementing CTRL1 by 1 from the set values above, skips when it hits 0
		GOTO	DELAY		; Goes back to DELAY to loop around until CTRL1 has decremented to 0
		DECFSZ	CRTL2,1		; Decrementing CTRL2 by 1 from the set values above, skips when it hits 0
		GOTO	DELAY		; Goes back to DELAY to loop around until CTRL2 has decremented to 0
		DECFSZ	CRTL3,1		; Decrementing CTRL3 by 1 from the set values above, skips when it hits 0
		GOTO	DELAY		; Goes back to DELAY to loop around until CTRL3 has decremented to 0
			
		RETURN				; RETURNS to where the CALL was activated
			
		END					; Ends the program
			