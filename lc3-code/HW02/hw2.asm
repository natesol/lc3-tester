; id1: 313537250 , id2: 314629205 .
.ORIG x3000

Main:
	; R0: Used for 'GetNum' return value, and 'PrintNum' parameter value.
	; R1: Preserved for HW01 subroutines return values.
	; R2: Preserved for HW01 subroutines return values.
	; R3: Preserved for HW01 subroutines return values.
	; R4: Store the first input number (a).
	; R5: Store the seconed input number (b).
	; R6: Unused.
	; R7: Unused.
	;
	; - Start Of The Main Code Runner ---
	JSR GetNum									; Getting the first input number (a).
	ADD R4, R0, #0								; Storing (a) in R4.
	JSR GetNum									; Getting the seconed input number (b).
	ADD R5, R0, #0								; Storing (b) in R5.
	;
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
	;
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
	;
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
	;
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
	;
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
	;
HALT

; ---------------------------------------------------------------------------------------
; --- Main Code Labels ------------------------------------------------------------------

Mul_Sign .FILL #42								; Multiplication sign (asterisk) ASCII value.
Div_Sign .FILL #47								; Division sign (slash) ASCII value.
Exp_Sign .FILL #94								; Exponent sign (caret) ASCII value.
Add_Sign .FILL #43								; Addition sign (plus) ASCII value.
Sub_Sign .FILL #45								; Subtraction sign (hyphen) ASCII value.
Equ_Sign .FILL #61								; Equals sign ASCII value.
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
Zero_ASCII_Check .FILL #-48						; The number zero character ('0') ASCII negative value, for direct checkings.

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
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: Used for the character input/output (via 'GETC' and 'OUT').
	AND R1, R1, #0								; R1: Holds the current valid input (the real value of the currentley valid input).
	AND R2, R2, #0								; R2: Holds the last valid character value (the real value of the last character received).
	AND R3, R3, #0								; R3: Character counter (count the number of digits received for a valid input).
	AND R4, R4, #0								; R4: Flag the input sign: #0 = not signed yet | #1 = positive integer | #-1 = negative integer | #-2 = only minus (invalid input).
	AND R5, R5, #0								; R5: Flag an input error: #0 = valid input | #1 = overflow | #-1 = invalid input (not an integer).
	AND R6, R6, #0								; R6: General purpose (for calculations, load and store).
	AND R7, R7, #0								; R7: General purpose (for calculations, load and store).
	;
	; - Start Of The Subrutine ---
	LEA R0, Enter_Number_Message				; Print first input message.
	PUTS
	Get_Input_Loop:
		GETC
		OUT
		ADD R6, R0, #-10						; If the character input was NewLine (ASCII value #10), end the input loop.
		BRz End_GetNum
		ADD R3, R3, #0							; If this is the first character, check for '0' or '-', and handle accordingly.
		BRz First_Character_Handler
		Check_Character:						; Check if the last received character is a valid input (a digit).
			LD R7, Zero_ASCII_Check
			ADD R6, R0, R7						; If the ASCII value is smaller than #48, then the input is invalid (not an integer digit).
			BRn Invalid_Input_Handler
			ADD R7, R6, #-10					; If the ASCII value is greater than or equal to #58, then the input is invalid (not an integer digit).
			BRzp Invalid_Input_Handler
			ADD R5, R5, #0						; If there was already an error, jump back to the 'Error_Handler_Loop' (used as an invalid input safe check after an overflow error).
			BRnp Error_Handler_Loop
			ADD R7, R3, #-5						; If the input was valid, but this is the sixth character, then the input is overflowed.
			BRzp Input_Overflow_Handler
		;
		; If the total input was valid, and the last character is valid, shift the total input, and add to its value the new received character.
		ADD R2, R6, #0							; Store the current character input real value.
		ADD R4, R4, #0							; If the total input is negative, switch the real value of the last character to negative.
		BRzp Check_For_First
		NOT R2, R2
		ADD R2, R2, #1
		Check_For_First:						; If this is the first character, there is no need for shifting the current valid input.
			ADD R3, R3, #0
			BRz Add_Last_Character
		; Shifting the current valid input one digit to the left - multiply it by 10, while keep checking for overflow after every additon operation.
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
		Add_Last_Character:						; After shifting the current total valid input, adding the last valid character value (and check for overflow).
			ADD R4, R4, #0
			BRn Add_Negative
			ADD R1, R1, R2
			BRn Input_Overflow_Handler
			BR End_Add_Last_Character
			Add_Negative:
				ADD R1, R1, R2
				BRp Input_Overflow_Handler
			End_Add_Last_Character:
				ADD R3, R3, #1					; If adding the last character wasn't overflowed, increasing the character counter by 1, and start the next 'Get_Input_Loop' iteration.
	BR Get_Input_Loop
	;
	First_Character_Handler:
			ADD R7, R4, #2						; If the sign flag equal #-2, then this is the first character after a minus - resign the flag for #-1 (negative integer).
			BRnp Check_For_Zero
			ADD R4, R4, #1
		Check_For_Zero:
			LD R7, Zero_ASCII_Check
			ADD R6, R0, R7						; Check if the input character is '0' (ASCII value #48).
			BRnp Check_For_Minus
			ADD R4, R4, #0						; If the input character is '0', and the input was already flaged as negative, ignore this character.
			BRn Get_Input_Loop
			ADD R4, R6, #1						; If the input character is '0', and the input is'nt already negative, flag it as positive, and start the next iteration.
			BR Get_Input_Loop
		Check_For_Minus:
			LD R7, Minus_ASCII_Check
			ADD R6, R0, R7						; Check if the input character is '-' (ASCII value #45).
			BRnp Check_Character				; If the input character is not a '0' or '-', jump to the general character check (check if a valid digit).
			ADD R4, R4, #0
			BRnp Invalid_Input_Handler			; If the input sign is alredy flaged (as a positive/negative integer), the input is invalid (a number with a '-' in the middle).
			ADD R4, R4, #-2						; If all the checks passed successfully, this is really the first character and it's a minus sign - flag the input as negative, and start the next 'Get_Input_Loop' iteration.
	BR Get_Input_Loop
	;
	Invalid_Input_Handler:
		AND R5, R5, #0
		ADD R5, R5, #-1							; Flag R5 with an input error: #-1 = invalid input (not an integer).
	BR Error_Handler_Loop
	;
	Input_Overflow_Handler:
		AND R5, R5, #0
		ADD R5, R5, #1							; Flag R5 with an input error: #1 = input overflow.
	;
	Error_Handler_Loop:
		GETC
		OUT
		ADD R4, R0, #-10						; If the character input was NewLine (ASCII value #10), end the error loop.
		BRz End_Error_Handler_Loop
		ADD R5, R5, #0							; If the current error is overflow, check the last charecter for invalid input, else, start the next iteration.
		BRp Check_Character
		BRn Error_Handler_Loop
		End_Error_Handler_Loop:
			ADD R5, R5, #0						; Check whats the input error is, and load the correct error message acordingly.
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
		BRnp Store_Input_Value
		ADD R4, R4, #0
		BRz Load_Invalid_Message				; If the 'Get_Input_Loop' ended without any input character (Enter as the first input), the input is invalid.
		ADD R6, R4, #2
		BRz Load_Invalid_Message				; Safe check for cases when the only character received was '-'.
		Store_Input_Value:
			ADD R0, R1, #0						; Store the total valid input in R0 for the returned value.
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

PrintNum_String		.FILL #0					; Array (string) to store and print the digits ASCII value of the input number.
					.FILL #0
					.FILL #0
					.FILL #0
					.FILL #0
End_PrintNum_String	.FILL #0					; Last cell is preserved for ASCII NULL value (mark the end of string).

Minus_ASCII .FILL #45							; The minus sign (hyphen) '-' ASCII value.
Zero_ASCII .FILL #48							; The number zero character '0' ASCII value.

PrintNum:
	; - Store Registers For Backup ---
	ST R1, PrintNum_Save_R1
	ST R2, PrintNum_Save_R2
	ST R3, PrintNum_Save_R3
	ST R4, PrintNum_Save_R4
	ST R5, PrintNum_Save_R5
	ST R6, PrintNum_Save_R6
	ST R7, PrintNum_Save_R7
	;
	; - Registers Reset ---
												; R0: Holds the input parameter to print.
	AND R1, R1, #0								; R1: Holds the value #10, for division by 10 with the 'Div' subroutine.
	AND R2, R2, #0								; R2: Preserved for the 'Div' subroutine quotient output.
	AND R3, R3, #0								; R3: Preserved for the 'Div' subroutine remainder output.
	AND R4, R4, #0								; R4: Used as a pointer for looping through the PrintNum_String (starting from the last cell).
	AND R5, R5, #0								; R5: Holds the zero character ('0') ASCII value (#48).
	AND R6, R6, #0								; R6: General purpose (for calculations, load and store).
	AND R7, R7, #0								; R7: Unused.
	;
	; - PrintNum_String Reset ---
	LEA R4, PrintNum_String
	ADD R3, R3, #5
	Reset_PrintNum_String_Loop:					; Iterate over the string and initialize every cell with the value #0.
		STR R2, R4, #0
		ADD R4, R4, #1
		ADD R3, R3, #-1
	BRzp Reset_PrintNum_String_Loop
	;
	; - Registers Initialization ---
	ADD R1, R1, #10
	LEA R4, End_PrintNum_String
	LD R5, Zero_ASCII
	;
	; - Start Of The Subrutine ---
	ADD R0, R0, #0
	BRz Print_Zero_Handler						; If the input number to print is #0, there is no need for any calculations.
	BRp Extract_Digits_Loop						; If the input number to print is positive, jump over the printing of '-'.
	ADD R6, R0, #0								; If the input number to print is negative, print '-' first.
	LD R0, Minus_ASCII
	OUT
	ADD R0, R6, #0
	;
	Extract_Digits_Loop:
		ADD R4, R4, #-1							; Advancing the PrintNum_String pointer one cell Backwards (it points to the last cell at the begging).
		JSR Div									; Dividing the input number (R0) by 10 (R1).
		ADD R3, R3, R5							; Getting the remainder digit ASCII value.
		STR R3, R4, #0							; Storing the ASCII value of the digit at the correct cell in PrintNum_String.
		ADD R0, R2, #0							; Initializing R0 with the last division quotient (for the next iteration).
		BRnp Extract_Digits_Loop				; If the last division quotient is greater than 0, there are still digits to extract.
	BR End_PrintNum								; At the end of the loop, R4 is pointing to the left digit, and every digit is in its correct place.
	;
	Print_Zero_Handler:
		ADD R4, R4, #-1
		STR R5, R4, #0
	;
	End_PrintNum:
		ADD R0, R4, #0
		PUTS
	;
	; - Reload Registers Original Values ---
	LD R1, PrintNum_Save_R1
	LD R2, PrintNum_Save_R2
	LD R3, PrintNum_Save_R3
	LD R4, PrintNum_Save_R4
	LD R5, PrintNum_Save_R5
	LD R6, PrintNum_Save_R6
	LD R7, PrintNum_Save_R7
	;
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
	
	CHECK_R1_NEGATIVE: ;Check if R1 is negative
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

	;Checking if we divide by 0
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