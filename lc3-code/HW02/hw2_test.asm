; 
.ORIG x3000

Main:
	; R0: Used for 'GetNum' return value, and 'PrintNum' parameter value.
	; R1: ~
	; R2: ~
	; R3: ~
	; R4: Store the first input number (a).
	; R5: Store the seconed input number (b).
	; R6: ?
	; R7: ?

	JSR GetNum									; Getting the first input number (a).
	ADD R4, R0, #0								; Storing (a) in R4.
	JSR GetNum									; Getting the seconed input number (b).
	ADD R5, R0, #0								; Storing (b) in R5.

	; - Print Multiplication (a*b) ---
	ADD R0, R4, #0
	JSR PrintNum
	LD R0, Mul_Sign
	OUT
	ADD R0, R5, #0
	JSR PrintNum
	LD R0, Equ_Sign
	OUT
	ADD R0, R4, #0
	ADD R1, R5, #0
	JSR Mul
	ADD R0, R2, #0
	JSR PrintNum
	LD R0, New_Line
	OUT

	; - Print Division (a/b) ---
	ADD R0, R4, #0
	JSR PrintNum
	LD R0, Div_Sign
	OUT
	ADD R0, R5, #0
	JSR PrintNum
	LD R0, Equ_Sign
	OUT
	ADD R0, R4, #0
	ADD R1, R5, #0
	JSR Div
	ADD R0, R2, #0
	JSR PrintNum
	LD R0, New_Line
	OUT

	; - Print Exponent (a^b) ---
	ADD R0, R4, #0
	JSR PrintNum
	LD R0, Exp_Sign
	OUT
	ADD R0, R5, #0
	JSR PrintNum
	LD R0, Equ_Sign
	OUT
	ADD R0, R4, #0
	ADD R1, R5, #0
	JSR Exp
	ADD R0, R2, #0
	JSR PrintNum
	LD R0, New_Line
	OUT

	; - Print Addition (a+b) ---
	ADD R0, R4, #0
	JSR PrintNum
	LD R0, Add_Sign
	OUT
	ADD R0, R5, #0
	JSR PrintNum
	LD R0, Equ_Sign
	OUT
	ADD R0, R4, R5
	JSR PrintNum
	LD R0, New_Line
	OUT

	; - Print Subtraction (a-b) ---
	ADD R0, R4, #0
	JSR PrintNum
	LD R0, Sub_Sign
	OUT
	ADD R0, R5, #0
	JSR PrintNum
	LD R0, Equ_Sign
	OUT
	NOT R5, R5
	ADD R5, R5, #1
	ADD R0, R4, R5
	JSR PrintNum
	LD R0, New_Line
	OUT

HALT

; ---------------------------------------------------------------------------------------
; --- Main Code Labels ------------------------------------------------------------------

Mul_Sign .FILL #42								; Multiplication sign (asterisk) ASCII value.
Div_Sign .FILL #47								; Division sign (slash) ASCII value.
Exp_Sign .FILL #94								; Exponent sign (caret) ASCII value.
Add_Sign .FILL #43								; Addition sign (plus) ASCII value.
Sub_Sign .FILL #45								; Subtraction sign (hyphen) ASCII value.
Equ_Sign .FILL #61								; Equals sign ASCII value - #61.
New_Line .FILL #10								; New line ASCII value.


; ---------------------------------------------------------------------------------------
; --- GetNum Subroutine -----------------------------------------------------------------

GetNum_Save_R1 .FILL #0
GetNum_Save_R2 .FILL #0
GetNum_Save_R3 .FILL #0
GetNum_Save_R4 .FILL #0
GetNum_Save_R5 .FILL #0
GetNum_Save_R6 .FILL #0
GetNum_Save_R7 .FILL #0

Minus_ASCII_Check .FILL #-45					; The subtraction sign (hyphen) ASCII negative value, for direct checkings.
Zero_ASCII_Check .FILL #-48						; The number zero character ASCII negative value, for direct checkings.

Enter_Number_Message .STRINGZ "Enter an integer number: "
Overflow_Error_Message .STRINGZ "Error! Number overflowed! Please enter again: "
Invalid_Error_Message .STRINGZ "Error! You didn't enter a number. Please enter again: "

GetNum:
	; - Store Registers For Backup ---
	ST R1, GetNum_Save_R1
	ST R2, GetNum_Save_R2
	ST R3, GetNum_Save_R3
	ST R4, GetNum_Save_R4
	ST R5, GetNum_Save_R5
	ST R6, GetNum_Save_R6
	ST R7, GetNum_Save_R7

	; - Registers Reset ---
	AND R0, R0, #0								; R0: Used for the character input/output (via 'GETC' and 'OUT').
	AND R1, R1, #0								; R1: Holds the current valid input (the real value of the currentley valid input).
	AND R2, R2, #0								; R2: Holds the last valid character value (the real value of the last character received).
	AND R3, R3, #0								; R3: Character counter (count the number of digits received for a valid input).
	AND R4, R4, #0								; R4: Flag for valid input sign: #0 = not signed yet | #1 = positive integer | #-1 = negative integer.
	AND R5, R5, #0								; R5: Flag an input error: #0 = valid input | #1 = overflow | #-1 = invalid input (not an integer).
	AND R6, R6, #0								; R6: ~~~
	AND R7, R7, #0								; R7: ~~~
	
	; - Start Of The Subrutine ---
	LEA R0, Enter_Number_Message
	PUTS
	Get_Input_Loop:
		GETC
		OUT
		ADD R6, R0, #-10						; If the character input was NewLine (ASCII value 10 - Enter), end the input loop.
		BRz End_GetNum
		ADD R3, R3, #0							; If this is the first character, check for "0" or "-", and handle accordingly.
		BRz First_Character_Handler
		
		Check_Character:
			LD R7, Zero_ASCII_Check
			ADD R6, R0, R7
			BRn Invalid_Input_Handler
			ADD R7, R6, #-10
			BRzp Invalid_Input_Handler
			ADD R5, R5, #0							; If there was already an error, jump back to the error loop.
			BRnp Error_Loop
			ADD R7, R3, #-5							; If this is the sixth character, than the input is overflowed.
			BRzp Input_Overflow_Handler
		;
		; - The total input is currently valid, and the last character that received is valid ---
		ADD R2, R6, #0							; Store the current character input real value.
		ADD R4, R4, #0							; If the input is negative, switch the real value of the last character to negative.
		BRzp Shift_To_The_Left
		NOT R2, R2
		ADD R2, R2, #1
		ADD R3, R3, #0							; If this is the first character, there is no need for shifting the current valid input.
		BRz Valid_Character_Handler
		Shift_To_The_Left:						; Shifting the current valid input one digit to the left (multiply it by 10).
			AND R6, R6, #0
			ADD R6, R6, #9
			ADD R7, R1, #0
			Multiply_By_10:
				ADD R4, R4, #0
				BRn Check_Overflow_For_Negative
				ADD R1, R1, R7
				BRn Input_Overflow_Handler
				BR Continue_Multiplication
				Check_Overflow_For_Negative:
					ADD R1, R1, R7
					BRp Input_Overflow_Handler
				Continue_Multiplication:
					ADD R6, R6, #-1
					BRp Multiply_By_10
		;
		Valid_Character_Handler:				; After shifting the current valid input, the new valid character value is added to it.
			ADD R4, R4, #0
			BRn Add_Negative
			ADD R1, R1, R2
			BRn Input_Overflow_Handler
			BR End_Valid_Character_Handler
			Add_Negative:
				ADD R1, R1, R2
				BRp Input_Overflow_Handler
			End_Valid_Character_Handler:
				ADD R3, R3, #1
				BR Get_Input_Loop
		;
		First_Character_Handler:
			LD R7, Zero_ASCII_Check
			ADD R6, R0, R7						; Check if the input character is '0' (ASCII value #48).
			; BRnp First_Character_Handler_Continue
			; ADD R4, R6, #1
			; !!!!!!!!!!!! ******** !!!!!!!!!!!!
			First_Character_Handler_Continue:
				LD R7, Minus_ASCII_Check
				ADD R6, R0, R7					; Check if the input character is '-' (ASCII value #45).
				BRnp Check_Character
				ADD R4, R4, #0
				BRnp Invalid_Input_Handler
				ADD R4, R4, #-1
				BR Get_Input_Loop
	;
	Invalid_Input_Handler:
		AND R5, R5, #0
		ADD R5, R5, #-1
		BR Error_Loop
	;
	Input_Overflow_Handler:
		AND R5, R5, #0
		ADD R5, R5, #1
		BR Error_Loop
	;
	Error_Loop:
		GETC
		OUT
		ADD R4, R0, #-10						; Enter -> Stop input
		BRz End_Error_Loop
		BRnp Check_Character
		End_Error_Loop:
			ADD R5, R5, #0
			BRp Load_Overflow_Message
			BRn Load_Invalid_Message
			Load_Overflow_Message:
				LEA R0, Overflow_Error_Message
				BR Reset_And_Print_Message
			Load_Invalid_Message:
				LEA R0, Invalid_Error_Message
			
			Reset_And_Print_Message:
				PUTS
				AND R1, R1, #0
				AND R3, R3, #0
				AND R4, R4, #0
				AND R5, R5, #0
				BR Get_Input_Loop
	;
	End_GetNum:
		ADD R3, R3, #0
		BRz Load_Invalid_Message
		AND R0, R0, #0
		ADD R0, R1, #0
	;
	; - Reload Registers Original Values ---
	LD R1, GetNum_Save_R1
	LD R2, GetNum_Save_R2
	LD R3, GetNum_Save_R3
	LD R4, GetNum_Save_R4
	LD R5, GetNum_Save_R5
	LD R6, GetNum_Save_R6
	LD R7, GetNum_Save_R7

RET												; Close GetNum Subroutine.


; ---------------------------------------------------------------------------------------
; --- PrintNum Subroutine ---------------------------------------------------------------

PrintNum_Save_R1 .FILL #0
PrintNum_Save_R2 .FILL #0
PrintNum_Save_R3 .FILL #0
PrintNum_Save_R4 .FILL #0
PrintNum_Save_R5 .FILL #0
PrintNum_Save_R6 .FILL #0
PrintNum_Save_R7 .FILL #0

PrintNum_String		.FILL #0					; Array to store and print the digits ASCII value of the input number.
					.FILL #0
					.FILL #0
					.FILL #0
					.FILL #0
End_PrintNum_String	.FILL #0

Minus_ASCII .FILL #45							; The subtraction sign (hyphen) ASCII value.
Zero_ASCII .FILL #48							; The number zero character ASCII value.

PrintNum:
	; - Store Registers For Backup ---
	ST R1, PrintNum_Save_R1
	ST R2, PrintNum_Save_R2
	ST R3, PrintNum_Save_R3
	ST R4, PrintNum_Save_R4
	ST R5, PrintNum_Save_R5
	ST R6, PrintNum_Save_R6
	ST R7, PrintNum_Save_R7

	; - Registers Reset ---
												; R0: Holds the input parameter to print.
	AND R1, R1, #0								; R1: Holds the value 10, for division by 10 with the Div subroutine.
	AND R2, R2, #0								; R2: Preserved for the Div subroutine quotient output.
	AND R3, R3, #0								; R3: Preserved for the Div subroutine remainder output.
	AND R4, R4, #0								; R4: Used as a pointer for looping through the PrintNum_String.
	AND R5, R5, #0								; R5: Holds the zero character ('0') ASCII value (48).
	AND R6, R6, #0								; R6: ~~~
	AND R7, R7, #0								; R7: ~~~

	; - PrintNum_String Reset ---
	LEA R4, PrintNum_String
	ADD R3, R3, #5
	Reset_PrintNum_String_Loop:
		STR R2, R4, #0
		ADD R4, R4, #1
		ADD R3, R3, #-1
		BRzp Reset_PrintNum_String_Loop

	; - Registers Initialization ---
	ADD R1, R1, #10
	LEA R4, End_PrintNum_String
	LD R5, Zero_ASCII

	; - Start Of The Subrutine ---
	ADD R0, R0, #0
	BRz Print_Zero_Handler
	BRp Extract_Digits_Loop
	ADD R6, R0, #0
	LD R0, Minus_ASCII
	OUT
	ADD R0, R6, #0

	Extract_Digits_Loop:
		ADD R4, R4, #-1							; Advancing the PrintNum_String one cell Backwards (it points to the last cell at the begging).
		JSR Div									; Dividing the input number (R0) by 10 (R1).
		ADD R3, R3, R5							; Getting the remainder digit ASCII value.
		STR R3, R4, #0							; Storing the ASCII value of the digit at the correct cell in PrintNum_String.
		ADD R0, R2, #0							; Initializing R0 with the last division quotient (for the next iteration).
		BRp Extract_Digits_Loop					; If the last division quotient is greater than 0, there are still digits to extract.

	LEA R0, PrintNum_String
	Shift_Array_Pointer_Loop:
		LDR R1, R0, #0
		BRnp Print_Array
		ADD R0, R0, #1
		BR Shift_Array_Pointer_Loop

	Print_Array:
		PUTS
		BR End_PrintNum

	Print_Zero_Handler:
		ADD R0, R5, #0
		OUT
	
	End_PrintNum:

	; - Reload Registers Original Values ---
	LD R1, PrintNum_Save_R1
	LD R2, PrintNum_Save_R2
	LD R3, PrintNum_Save_R3
	LD R4, PrintNum_Save_R4
	LD R5, PrintNum_Save_R5
	LD R6, PrintNum_Save_R6
	LD R7, PrintNum_Save_R7

RET												; Close PrintNum Subroutine.


; ---------------------------------------------------------------------------------------
; --- Mul Subroutine --------------------------------------------------------------------

Mul_Save_R0 .fill #0
Mul_Save_R1 .fill #0
Mul_Save_R3 .fill #0
Mul_Save_R7 .fill #0

Mul:
	ST R0, Mul_Save_R0
	ST R1, Mul_Save_R1
	ST R3, Mul_Save_R3
	ST R7, Mul_Save_R7
	
	AND R2, R2, #0 ;initialisation R2
	AND R3, R3, #0 ;R3 is a flag for R1 negativity

	;Checking if R0 or R1 are 0
	ADD R1, R1, #0
	BRnp CHECK_R0_IS_ZERO
	AND R2, R2, #0
	BR DONE_Mul

	CHECK_R0_IS_ZERO:
		ADD R0, R0, #0
		BRnp CHECK_R1_NEGATIVE
		AND R2, R2, #0
		BR DONE_Mul
		
	;Check if R1 is negative
	CHECK_R1_NEGATIVE:
		ADD R1, R1, #0
		BRp LOOP_Mul ;R1 cant be in this point 0 because we already checked it
		ADD R3, R3, #1 ;R3=1. R1 is negative
		NOT R1, R1
		ADD R1, R1, #1 ;R1=-R1 now R1 is his positive version

	LOOP_Mul:
		ADD R1, R1, #0
		BRnz END_LOOP_Mul
		ADD R2, R2, R0
		ADD R1, R1, #-1
		BR LOOP_Mul

	END_LOOP_Mul:
		ADD R3, R3, #0 ;flag check
		BRnz DONE_Mul
		NOT R2, R2
		ADD R2, R2, #1 ;R2=-R2 (because R1 was negative)

	DONE_Mul:
		LD R0, Mul_Save_R0
		LD R1, Mul_Save_R1 
		LD R3, Mul_Save_R3
		LD R7, Mul_Save_R7

RET												; Close Mul Subrutine.


; ---------------------------------------------------------------------------------------
; --- Div Subroutine --------------------------------------------------------------------

Div_Save_R0 .fill #0
Div_Save_R1 .fill #0
Div_Save_R4 .fill #0
Div_Save_R5 .fill #0
Div_Save_R6 .fill #0
Div_Save_R7 .fill #0

Div:
	ST R0, Div_Save_R0
	ST R1, Div_Save_R1
	ST R4, Div_Save_R4
	ST R5, Div_Save_R5
	ST R6, Div_Save_R6
	ST R7, Div_Save_R7

	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0 ;R4 is a flag for R1 negativity
	AND R5, R5, #0 ;R5 is a flag for R0 negativity
	AND R6, R6, #0

	;Checking if we divide in 0
	ADD R1, R1, #0
	BRnp NOT_DIVIDE_IN_ZERO
	ADD R2, R2, #-1
	ADD R3, R3, #-1
	BR DONE_Div

	NOT_DIVIDE_IN_ZERO:
		;Checking the sign of R1
		ADD R1, R1, #0
		BRn R1_NEGATIVE_Div
		NOT R1, R1
		ADD R1, R1, #1 ;R1=-R1
		BR CHECK_R0_Div
	
	R1_NEGATIVE_Div:
		ADD R4, R4, #1 ;R4=1 Because R1 is negative

	CHECK_R0_Div:
		ADD R0, R0, #0
		BRzp LOOP_Div ;If R0>=0 go to loop_div
		NOT R0, R0
		ADD R0, R0, #1 ;R0=-R0
		ADD R5, R5, #1 ;R5=1 Because R0 is negative

	LOOP_Div:
		ADD R6, R0, R1 ;R6=R0+R1
		BRn MODULO ;If R0<R1 go to modulo
		ADD R0, R0, R1
		ADD R2, R2, #1
		BR LOOP_Div

	MODULO:
		ADD R0, R0, #0
		BRnz CHECK_IF_R1_WAS_NEGATIVE_Div
		ADD R3, R3, #1
		ADD R0, R0, #-1
		BR MODULO
	
	CHECK_IF_R1_WAS_NEGATIVE_Div:
		ADD R4, R4, #0
		BRnz CHECK_IF_R0_WAS_NEGATIVE_Div
		NOT R2, R2
		ADD R2, R2, #1

	CHECK_IF_R0_WAS_NEGATIVE_Div:
		ADD R5, R5, #0
		BRnz DONE_Div
		NOT R2, R2
		ADD R2, R2, #1

	DONE_Div:
		LD R0, Div_Save_R0
		LD R1, Div_Save_R1
		LD R4, Div_Save_R4
		LD R5, Div_Save_R5
		LD R6, Div_Save_R6
		LD R7, Div_Save_R7
	
RET												; Close Dive Subrutine.


; ---------------------------------------------------------------------------------------
; --- Exp Subroutine --------------------------------------------------------------------

Exp_Save_R0 .fill #0
Exp_Save_R1 .fill #0
Exp_Save_R4 .fill #0
Exp_Save_R7 .fill #0

Exp:
	ST R0, Exp_Save_R0
	ST R1, Exp_Save_R1
	ST R4, Exp_Save_R4
	ST R7, Exp_Save_R7

	AND R2, R2, #0
	AND R4, R4, #0 
	ADD R4, R1, #-1 ;Save R1-1

	CONDITION_1:
		ADD R0, R0, #0
		BRnp CONDITION_2
		ADD R1, R1, #0
		BRp CONDITION_2
		ADD R2, R2, #-1
		BR DONE_Exp

	CONDITION_2:
		ADD R0, R0, #0
		BRzp OR
		ADD R2, R2, #-1
		BR DONE_Exp

	OR:
		ADD R1, R1, #0
		BRzp CHECK_IF_R0_IS_1
		ADD R2, R2, #-1
		BR DONE_Exp

	CHECK_IF_R0_IS_1:
		ADD R0, R0, #-1
		BRnp CHECK_IF_R1_IS_1
		ADD R0, R0, #1
		ADD R2, R2, #1
		BR DONE_Exp
	
	CHECK_IF_R1_IS_1:
		ADD R0, R0, #1
		ADD R1, R1, #-1
		BRnp LOOP_Exp
		ADD R1, R1, #1
		ADD R2, R0, #0
		BR DONE_Exp

	LOOP_Exp:
		ADD R1, R1, #1
		AND R1, R1, #0
		ADD R1, R0, #0
		START_LOOP_Exp:
			ADD R4, R4, #0
			BRnz DONE_Exp
			JSR Mul
			ADD R4, R4, #-1
			AND R1, R1, #0
			ADD R1, R2, #0
			BR START_LOOP_Exp

	DONE_Exp:
		LD R0, Exp_Save_R0
		LD R1, Exp_Save_R1
		LD R4, Exp_Save_R4
		LD R7, Exp_Save_R7

RET												; Close Exp Subrutine.

.END