; ID1: 314629205, 50.1%
; ID2: 313537250, 49.9%
; Convention: Haifa.

.ORIG x3000
	;
	LD R6, Stack_Address						; Initialize R6 as the stack pointer.
	;
	LEA R0, Enter_Number_Message				; Print the get input message.
	PUTS
	; - Calling GetNum ---
	JSR GetNum									; ~ No arguments.
	;
	; - Calling NQueenSolver ---
	AND R1, R1, #0
	LEA R2, Positions
	STR R1, R6, #-4								; First argument  - queen_number (initialized on the first call to 0).
	STR R2, R6, #-3								; Second argument - positions (array pointer).
	STR R1, R6, #-2								; Third argument  - solutions (initialized on the first call to 0).
	STR R0, R6, #-1								; Fourth argument - N (GetNum return value).
	ADD R6, R6, #-4								; Stack update - Push NQueenSolver arguments.
	JSR NQueenSolver
	ADD R6, R6, #4								; Stack update - Pop NQueenSolver arguments.
	;
	ADD R3, R0, #0								; Storing NQueenSolver return value (solutions for N queens).
	;
	LEA R0, Number_Of_Solutions_Message			; Print the possible solutions message.
	PUTS
	; - Calling PrintNum ---
	STR R3, R6, #-1								; First argument - num (NQueenSolver return value).
	ADD R6, R6, #-1								; Stack update   - Push PrintNum arguments.
	JSR PrintNum
	ADD R6, R6, #1								; Stack update - Pop PrintNum arguments.
	;
HALT


; -------------------------------------------------------------------------------------------------
; --- Main Code Labels ----------------------------------------------------------------------------

Stack_Address .FILL xBFFF						; Stack start address.
Positions .BLKW	#30 #0							; Queens positions array (max length 30).

; Output messages.
Enter_Number_Message .STRINGZ "Enter N, i.e., number between 1 to 30: "
Number_Of_Solutions_Message .STRINGZ "Number of possible solutions: "


; -------------------------------------------------------------------------------------------------
; --- GetNum Function -----------------------------------------------------------------------------
;
; int GetNum ();     =>     return the input number (N).

Minus_ASCII_Check .FILL #-45					; The subtraction sign (hyphen) ASCII negative value, for direct checkings.
Zero_ASCII_Check .FILL #-48						; The number zero character ('0') ASCII negative value, for direct checkings.

; Output messages.
Overflow_Error_Message .STRINGZ "Error! Number overflowed! Please enter again: "
Invalid_Error_Message .STRINGZ "Error! You didn't enter a number. Please enter again: "

GetNum:
	; - Store Registers Original Values ---
	ADD R6, R6, #-8								; Stack update - Push (save registers + local variables).
	STR R1, R6, #2
	STR R2, R6, #3
	STR R3, R6, #4
	STR R4, R6, #5
	STR R5, R6, #6
	STR R7, R6, #7
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: Used for the character input/output (via 'GETC' and 'OUT').
	AND R1, R1, #0								; R1: Holds the current valid input (the real value of the currentley valid input).
	AND R2, R2, #0								; R2: Holds the last valid character value (the real value of the last character received).
	AND R3, R3, #0								; R3: Character counter (count the number of digits received for a valid input).
	AND R4, R4, #0								; R4: General purpose (for calculations, load and store).
	AND R5, R5, #0								; R5: General purpose (for calculations, load and store).
	;											; R6: Stack Pointer.
	AND R7, R7, #0								; R7: LDR / STR (local variables access).
	;
	; - Local Variables Initialization ---
	STR R0, R6, #0								; Flag the input sign: #0 = not signed yet | #1 = positive integer | #-1 = negative integer | #-2 = only minus (invalid input).
	STR R0, R6, #1								; Flag an input error: #0 = valid input | #1 = overflow | #-1 = invalid input (not an integer).
	;
	; - Start Of The Function ---
	Get_Input_Loop:
		GETC
		OUT
		ADD R4, R0, #-10						; If the character input was NewLine (ASCII value #10), end the input loop.
		BRz End_GetNum
		ADD R3, R3, #0							; If this is the first character, check for '0' or '-', and handle accordingly.
		BRz First_Character_Handler
		Check_Character:						; Check if the last received character is a valid input (a digit).
			LD R5, Zero_ASCII_Check
			ADD R4, R0, R5						; If the ASCII value is smaller than #48, then the input is invalid (not an integer digit).
			BRn Invalid_Input_Handler
			ADD R5, R4, #-10					; If the ASCII value is greater than or equal to #58, then the input is invalid (not an integer digit).
			BRzp Invalid_Input_Handler
			LDR R7, R6, #1						; If there was already an error, jump back to the 'Error_Handler_Loop' (used as an invalid input safe check after an overflow error).
			BRnp Error_Handler_Loop
			ADD R5, R3, #-5						; If the input was valid, but this is the sixth character - the input is overflowed.
			BRzp Input_Overflow_Handler
		;
		; If the total input was valid, and the last character is valid, shift the total input, and add to its value the new received character.
		ADD R2, R4, #0							; Store the current character input real value.
		LDR R7, R6, #0							; If the total input is negative, switch the real value of the last character to negative.
		BRzp Check_For_First
		NOT R2, R2
		ADD R2, R2, #1
		Check_For_First:						; If this is the first character, there is no need for shifting the current valid input.
			ADD R3, R3, #0
			BRz Add_Last_Character
		; Shifting the current valid input one digit to the left - multiply it by 10, while keep checking for overflow after every additon operation.
		AND R4, R4, #0
		ADD R4, R4, #9
		ADD R5, R1, #0
		Multiply_By_10:
			LDR R7, R6, #0
			BRn Check_Overflow_For_Negative
			ADD R1, R1, R5
			BRn Input_Overflow_Handler
			BR Continue_Multiplication
			Check_Overflow_For_Negative:
				ADD R1, R1, R5
				BRp Input_Overflow_Handler
			Continue_Multiplication:
				ADD R4, R4, #-1
		BRp Multiply_By_10
		;
		Add_Last_Character:						; After shifting the current total valid input, adding the last valid character value (and check for overflow).
			LDR R7, R6, #0
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
			LDR R7, R6, #0
			ADD R4, R7, #2						; If the sign flag equal #-2, then this is the first character after a minus - resign the flag for #-1 (negative integer).
			BRnp Check_For_Zero
			ADD R7, R7, #1
			STR R7, R6, #0
		Check_For_Zero:
			LD R5, Zero_ASCII_Check
			ADD R4, R0, R5						; Check if the input character is '0' (ASCII value #48).
			BRnp Check_For_Minus
			LDR R7, R6, #0						; If the input character is '0', and the input was already flaged as negative, ignore this character.
			BRn Get_Input_Loop
			ADD R7, R7, #1						; If the input character is '0', and the input is'nt already negative, flag it as positive, and start the next iteration.
			STR R7, R6, #0
			BR Get_Input_Loop
		Check_For_Minus:
			LD R5, Minus_ASCII_Check
			ADD R4, R0, R5						; Check if the input character is '-' (ASCII value #45).
			BRnp Check_Character				; If the input character is not a '0' or '-', jump to the general character checker (check if a valid digit).
			LDR R7, R6, #0
			BRnp Invalid_Input_Handler			; If the input sign is alredy flaged (as a positive/negative integer), the input is invalid (a number with a '-' in the middle).
			ADD R7, R7, #-2						; If all the checks passed successfully, this is really the first character and it's a minus sign - flag the input as negative, and start the next 'Get_Input_Loop' iteration.
			STR R7, R6, #0
	BR Get_Input_Loop
	;
	Invalid_Input_Handler:
		AND R7, R7, #0
		ADD R7, R7, #-1							; Flag with an input error: #-1 = invalid input (not an integer).
		STR R7, R6, #1
	BR Error_Handler_Loop
	;
	Input_Overflow_Handler:
		AND R7, R7, #0
		ADD R7, R7, #1							; Flag with an input error: #1 = input overflow.
		STR R7, R6, #1
	;
	Error_Handler_Loop:
		GETC
		OUT
		ADD R4, R0, #-10						; If the character input was NewLine (ASCII value #10), end the error loop.
		BRz End_Error_Handler_Loop
		LDR R7, R6, #1							; If the current error is overflow, check the last charecter for invalid input, else, start the next iteration.
		BRp Check_Character
		BRn Error_Handler_Loop
		End_Error_Handler_Loop:
			LDR R7, R6, #1						; Check whats the input error is, and load the correct error message acordingly.
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
				STR R1, R6, #0
				STR R1, R6, #1
	BR Get_Input_Loop
	;
	End_GetNum:
		ADD R3, R3, #0
		BRnp Store_Input_Value
		LDR R7, R6, #0
		BRz Load_Invalid_Message				; If the 'Get_Input_Loop' ended without any input character (Enter as the first input), the input is invalid.
		ADD R4, R7, #2
		BRz Load_Invalid_Message				; Safe check for cases when the only character received was '-'.
		Store_Input_Value:
			ADD R0, R1, #0						; Store the total valid input in R0 for the returned value.
	;
	; - Reload Registers Original Values ---
	LDR R1, R6, #2
	LDR R2, R6, #3
	LDR R3, R6, #4
	LDR R4, R6, #5
	LDR R5, R6, #6
	LDR R7, R6, #7
	ADD R6, R6, #8								; Stack update - Pop (clear registers save + local variables).
	;
RET												; Close GetNum Function.


; -------------------------------------------------------------------------------------------------
; --- PrintNum Function ---------------------------------------------------------------------------
;
; void PrintNum (int num);     =>     no return value.

PrintNum_String		.BLKW #5 #0					; Array (string) to store and print the digits ASCII value of the input number.
End_PrintNum_String	.FILL #0					; Last cell is preserved for ASCII NULL value (mark the end of string).

Minus_ASCII .FILL #45							; The minus sign (hyphen) '-' ASCII value.
Zero_ASCII .FILL #48							; The number zero character '0' ASCII value.

PrintNum:
	; - Store Registers Original Values ---
	ADD R6, R6, #-5								; Stack update - Push (save registers).
	STR R1, R6, #0
	STR R2, R6, #1
	STR R3, R6, #2
	STR R4, R6, #3
	STR R7, R6, #4
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: Holds the input parameter to print.
	AND R1, R1, #0								; R1: Preserved for the division quotient.
	AND R2, R2, #0								; R2: Holds the zero character ('0') ASCII value (#48).
	AND R3, R3, #0								; R3: Used as an iterator for PrintNum_String (starting from the last cell).
	AND R4, R4, #0								; R4: General purpose (for calculations, load and store).
	;											; R5: Unused.
	;											; R6: Stack Pointer.
	;											; R7: Unused.
	;
	; - Registers Initialization ---
	LDR R0, R6, #5
	LD  R2, Zero_ASCII
	LEA R3, End_PrintNum_String
	;
	; - Start Of The Function ---
	ADD R0, R0, #0
	BRzp Extract_Digits_Loop					; If the number to print is positive, jump over the printing of '-'.
	ADD R4, R0, #0								; Else (if the number to print is negative), print '-' first, and make the number to positive.
	LD R0, Minus_ASCII
	OUT
	NOT R0, R4
	ADD R0, R0, #1
	;
	Extract_Digits_Loop:
		ADD R3, R3, #-1							; Advancing the PrintNum_String pointer one cell Backwards (it points to the last cell at the begging).
		;
		AND R1, R1, #0
		Divide_By_10:
			ADD R4, R0, #-10
			BRn Continue_Extract_Digits
			ADD R1, R1, #1
			ADD R0, R0, #-10
		BR Divide_By_10
		;
		Continue_Extract_Digits:
			ADD R0, R0, R2						; Getting the remainder digit ASCII value.
			STR R0, R3, #0						; Storing the ASCII value of the digit at the correct cell in PrintNum_String.
			ADD R0, R1, #0						; Initializing R0 with the last division quotient (for the next iteration).
	BRp Extract_Digits_Loop						; If the last division quotient is greater than 0, there are still digits to extract.
	;
	ADD R0, R3, #0								; At the end of the loop, R3 (string iterator) points to the left digit, and every digit is at its correct position.
	PUTS
	;
	; - Reload Registers Original Values ---
	LDR R1, R6, #0
	LDR R2, R6, #1
	LDR R3, R6, #2
	LDR R4, R6, #3
	LDR R7, R6, #4
	ADD R6, R6, #5								; Stack update - Pop (clear registers save).
	;
RET												; Close PrintNum Function.


; -------------------------------------------------------------------------------------------------
; --- printQueensPositions Function ---------------------------------------------------------------
;
; void printQueensPositions (int* positions, int N);     =>     no return value.

Space_ASCII .FILL #32							; The spacae character ASCII value.

printQueensPositions:
	; - Store Registers Original Values ---
	ADD R6, R6, #-5								; Stack update - Push (save registers).
	STR R1, R6, #0
	STR R2, R6, #1
	STR R3, R6, #2
	STR R4, R6, #3
	STR R7, R6, #4
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: Preserved for the 'OUT' trap (print values).
	AND R1, R1, #0								; R1: Holds the first argument - positions array pointer (used as array iterator).
	AND R2, R2, #0								; R2: Holds the second argument - N (array length).
	AND R3, R3, #0								; R3: Holds the space character (' ') ASCII value (#32).
	AND R4, R4, #0								; R4: Holds the new line character ('\n') ASCII value (#10).
	;											; R5: Unused.
	;											; R6: Stack Pointer.
	;											; R7: Unused.
	;
	; - Registers Initialization ---
	LDR R1, R6, #5
	LDR R2, R6, #6
	LD R3, Space_ASCII
	ADD R4, R4, #10
	;
	; - Start Of The Function ---
	Print_Positions_Loop:
		; - Calling PrintNum ---
		LDR R0, R1, #0							; Load the current position value to print.
		STR R0, R6, #-1							; First argument - num.
		ADD R6, R6, #-1							; Stack update - Push PrintNum arguments.
		JSR PrintNum
		ADD R6, R6, #1							; Stack update - Pop PrintNum arguments.
		;
		ADD R0, R3, #0							; Print space.
		OUT
		;
		ADD R1, R1, #1
		ADD R2, R2, #-1
	BRp Print_Positions_Loop
	;
	ADD R0, R4, #0								; Print new line.
	OUT
	;
	; - Reload Registers Original Values ---
	LDR R1, R6, #0
	LDR R2, R6, #1
	LDR R3, R6, #2
	LDR R4, R6, #3
	LDR R7, R6, #4
	ADD R6, R6, #5								; Stack update - Pop (clear registers save).
	;
RET												; Close printQueensPositions Function.


; -------------------------------------------------------------------------------------------------
; --- isLegal Function ----------------------------------------------------------------------------
;
; bool isLegal (int queen_number, int* positions, int col_position);     =>     return #1 (true) if the position is legal, and #0 (false) if not.

isLegal:
	; - Store Registers Original Values ---
	ADD R6, R6, #-6								; Stack update - Push (save registers).
	STR R1, R6, #0
	STR R2, R6, #1
	STR R3, R6, #2
	STR R4, R6, #3
	STR R5, R6, #4
	STR R7, R6, #5
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: Holds the return value (#1 or #0).
	AND R1, R1, #0								; R1: Holds the first argument - queen_number.
	AND R2, R2, #0								; R2: Holds the second argument - positions array pointer.
	AND R3, R3, #0								; R3: Holds the third argument - col_position.
	AND R4, R4, #0								; R4: Used as array index iterator (i).
	AND R5, R5, #0								; R5: Holds the position value for each iteration.
	;											; R6: Stack Pointer.
	AND R7, R7, #0								; R7: General purpose (for calculations, load and store).
	;
	; - Registers Initialization ---
	LDR R1, R6, #6
	BRz Return_True								; If this is the first queen, every position is legal.
	LDR R2, R6, #7
	LDR R3, R6, #8
	ADD R4, R1, #-1
	;
	; - Start Of The Function ---
	ADD R2, R2, R4
	isLegal_Loop:
		LDR R5, R2, #0
		;
		; if ( positions[i] - col_position == 0 ) : return 0.
		NOT R7, R3
		ADD R7, R7, #1
		ADD R7, R7, R5
		BRz End_isLegal
		;
		; if ( positions[i] - (col_position - (queen_number - i)) == 0 ) : return 0.
		NOT R7, R4
		ADD R7, R7, #1
		ADD R7, R7, R1
		NOT R7, R7
		ADD R7, R7, #1
		ADD R7, R7, R3
		NOT R7, R7
		ADD R7, R7, #1
		ADD R7, R7, R5
		BRz End_isLegal
		;
		; if ( positions[i] - (col_position + (queen_number - i)) == 0 ) : return 0.
		NOT R7, R4
		ADD R7, R7, #1
		ADD R7, R7, R1
		ADD R7, R7, R3
		NOT R7, R7
		ADD R7, R7, #1
		ADD R7, R7, R5
		BRz End_isLegal
		;
		ADD R2, R2, #-1
		ADD R4, R4, #-1
	BRzp isLegal_Loop
	;
	Return_True:								; If the previous queens do not threaten the current position (or this is the first queen) - return 1.
		ADD R0, R0, #1
	;
	End_isLegal:
		; - Reload Registers Original Values ---
		LDR R1, R6, #0
		LDR R2, R6, #1
		LDR R3, R6, #2
		LDR R4, R6, #3
		LDR R5, R6, #4
		LDR R7, R6, #5
		ADD R6, R6, #6							; Stack update - Pop (clear registers save).
	;
RET												; Close isLegal Function.


; -------------------------------------------------------------------------------------------------
; --- NQueenSolver Function -----------------------------------------------------------------------
;
; int NQueenSolver (int queen_number, int* positions, int solutions, int N);      =>     return the number of possible solutions.

; Output message.
Solution_Message .STRINGZ "Solution: "

NQueenSolver:
	; - Store Registers Original Values ---
	ADD R6, R6, #-6								; Stack update - Push (save registers).
	STR R1, R6, #0
	STR R2, R6, #1
	STR R3, R6, #2
	STR R4, R6, #3
	STR R5, R6, #4
	STR R7, R6, #5
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: Holds the third argument - solutions, and the return value (solutions + number of new solutions).
	AND R1, R1, #0								; R1: Holds the first argument - queen_number.
	AND R2, R2, #0								; R2: Holds the second argument - positions array pointer.
	AND R3, R3, #0								; R3: Holds the fourth argument - N (array length).
	AND R4, R4, #0								; R4: Used as array index iterator (i / col_position).
	AND R5, R5, #0								; R5: General purpose (for calculations, load and store).
	;											; R6: Stack Pointer.
	AND R7, R7, #0								; R7: General purpose (for calculations, load and store).
	;
	; - Registers Initialization ---
	LDR R1, R6, #6
	LDR R2, R6, #7
	LDR R3, R6, #9
	;
	; - Start Of The Function ---
	NOT R5, R3
	ADD R5, R5, #1
	ADD R5, R5, R1								; if ( queen_number - N == 0 ) : The current positions array is a valid solution.
	BRz Solution_Found
	;
	Find_Solutions_Loop:
		; - Calling isLegal ---
		STR R1, R6, #-3							; First argument  - queen_number.
		STR R2, R6, #-2							; Second argument - positions (array pointer).
		STR R4, R6, #-1							; Third argument  - col_position
		ADD R6, R6, #-3							; Stack update - Push isLegal arguments.
		JSR isLegal
		ADD R6, R6, #3							; Stack update - Pop isLegal arguments.
		;
		ADD R0, R0, #0							; If the current position is not legal - jump to the next iteration (try the next position).
		BRz Increment_Iterator
		;
		ADD R7, R2, R1
		STR R4, R7, #0							; Updating the current queen position (positions[queen_number] = i).
		;
		; - Calling NQueenSolver (recursively) ---
		LDR R0, R6, #8
		ADD R5, R1, #1
		STR R5, R6, #-4							; First argument  - queen_number + 1.
		STR R2, R6, #-3							; Second argument - positions (array pointer).
		STR R0, R6, #-2							; Third argument  - solutions.
		STR R3, R6, #-1							; Fourth argument - N.
		ADD R6, R6, #-4							; Stack update - Push NQueenSolver arguments.
		JSR NQueenSolver
		ADD R6, R6, #4							; Stack update - Pop NQueenSolver arguments.
		;
		STR R0, R6, #8							; Update the solutions variable with the new number of solutions (recursion return value).
		;
		Increment_Iterator:						; i++ , and check if : i == N (end of the loop).
			ADD R4, R4, #1
			NOT R5, R3
			ADD R5, R5, #1
			ADD R5, R5, R4
	BRnp Find_Solutions_Loop
	;
	LDR R0, R6, #8								; Updating R0 with the return value.
	BR End_NQueenSolver
	;
	Solution_Found:
		LEA R0, Solution_Message				; Print solution message.
		PUTS
		;
		; - Calling printQueensPositions ---
		STR R2, R6, #-2							; First argument  - positions (array pointer).
		STR R3, R6, #-1							; Second argument - N (array length).
		ADD R6, R6, #-2							; Stack update - Push printQueensPositions arguments.
		JSR printQueensPositions
		ADD R6, R6, #2							; Stack update - Pop printQueensPositions arguments.
		;
		LDR R0, R6, #8
		ADD R0, R0, #1							; Updating the return value to: solutions + 1.
	;
	End_NQueenSolver:
		; - Reload Registers Original Values ---
		LDR R1, R6, #0
		LDR R2, R6, #1
		LDR R3, R6, #2
		LDR R4, R6, #3
		LDR R5, R6, #4
		LDR R7, R6, #5
		ADD R6, R6, #6							; Stack update - Pop (clear registers save).
	;
RET												; Close NQueenSolver Function.


; -------------------------------------------------------------------------------------------------
; -------------------------------------------------------------------------------------------------

.END