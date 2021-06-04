; ID1: 314629205, 51%
; ID2: 313537250, 49%

.ORIG x3000
	;
	; - Getting the number of students for each course ---
	LEA R0, Enter_Number_Message
	PUTS
	LEA R2, First_Course_Students_List_Length
	JSR GetNumberOfStudents
	;
	; - Getting the students grades for the first course ---
	LEA R0, First_Course_Enter_Grades_Message
	PUTS
	LD R1, First_Course_Students_List
	LD R2, First_Course_Students_List_Length
	JSR GetStudentGrades
	JSR AverageCalculator						; Calculating and storing the average of each student in the first course.
	;
	; - Getting the students grades for the second course ---
	LEA R0, Second_Course_Enter_Grades_Message
	PUTS
	LD R1, Second_Course_Students_List
	LD R2, Second_Course_Students_List_Length
	JSR GetStudentGrades
	JSR AverageCalculator						; Calculating and storing the average of each student in the second course.
	;
	; - Getting the students grades for the third course ---
	LEA R0, Third_Course_Enter_Grades_Message
	PUTS
	LD R1, Third_Course_Students_List
	LD R2, Third_Course_Students_List_Length
	JSR GetStudentGrades
	JSR AverageCalculator						; Calculating and storing the average of each student in the third course.
	;
	JSR ConcatenateLists						; Concatenating the three lists into one list, wich start at the 'First_Course_Students_List' pointer, and the length is stored in 'First_Course_Students_List_Length'
	;
	; - Using The 'BestStudent' Subrutine To Fill The 'Best_Grades_Array' ---
	LEA R0, Best_Grades_Array
	LD R1, First_Course_Students_List
	LD R2, First_Course_Students_List_Length
	JSR BestStudent
	;
	; - Printing The Highest Six Average Grades ---
	LEA R0, Highest_Grades_Output_Message
	PUTS
	LEA R1, Best_Grades_Array
	AND R2, R2, #0
	ADD R2, R2, #6
	Print_Best_Grades_Loop:
		LDR R0, R1, #0
		JSR PrintNum
		LD R0, Space_ASCII
		OUT
		;
		ADD R1, R1, #1
		ADD R2, R2, #-1
	BRp Print_Best_Grades_Loop
	;
HALT

; -------------------------------------------------------------------------------------------------
; --- Main Code Labels ----------------------------------------------------------------------------

Enter_Number_Message .STRINGZ "Enter the number of students in each course: "
First_Course_Enter_Grades_Message .STRINGZ "Enter the student grades in course 1:\n"
Second_Course_Enter_Grades_Message .STRINGZ "Enter the student grades in course 2:\n"
Third_Course_Enter_Grades_Message .STRINGZ "Enter the student grades in course 3:\n"
Highest_Grades_Output_Message .STRINGZ "The six highest scores are: "

Space_ASCII .FILL #32							; The spacae character ASCII value.

Best_Grades_Array .BLKW 6
;

; -------------------------------------------------------------------------------------------------
; --- Students Linked Lists -----------------------------------------------------------------------

First_Course_Students_List .FILL First_List_1
Second_Course_Students_List .FILL Second_List_1
Third_Course_Students_List .FILL Third_List_1
;
First_Course_Students_List_Length .FILL #10
Second_Course_Students_List_Length .FILL #10
Third_Course_Students_List_Length .FILL #10
;
First_List_1	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL First_List_2
First_List_2	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL First_List_1
				.FILL First_List_3
First_List_3	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL First_List_2
				.FILL First_List_4
First_List_4	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL First_List_3
				.FILL First_List_5
First_List_5	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL First_List_4
				.FILL First_List_6
First_List_6	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL First_List_5
				.FILL First_List_7
First_List_7	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL First_List_6
				.FILL First_List_8
First_List_8	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL First_List_7
				.FILL First_List_9
First_List_9	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL First_List_8
				.FILL First_List_10
First_List_10	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL First_List_9
				.FILL #0
;
Second_List_1	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Second_List_2
Second_List_2	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Second_List_1
				.FILL Second_List_3
Second_List_3	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Second_List_2
				.FILL Second_List_4
Second_List_4	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Second_List_3
				.FILL Second_List_5
Second_List_5	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Second_List_4
				.FILL Second_List_6
Second_List_6	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Second_List_5
				.FILL Second_List_7
Second_List_7	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Second_List_6
				.FILL Second_List_8
Second_List_8	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Second_List_7
				.FILL Second_List_9
Second_List_9	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Second_List_8
				.FILL Second_List_10
Second_List_10	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Second_List_9
				.FILL #0
;
Third_List_1	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Third_List_2
Third_List_2	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Third_List_1
				.FILL Third_List_3
Third_List_3	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Third_List_2
				.FILL Third_List_4
Third_List_4	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Third_List_3
				.FILL Third_List_5
Third_List_5	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Third_List_4
				.FILL Third_List_6
Third_List_6	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Third_List_5
				.FILL Third_List_7
Third_List_7	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Third_List_6
				.FILL Third_List_8
Third_List_8	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Third_List_7
				.FILL Third_List_9
Third_List_9	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Third_List_8
				.FILL Third_List_10
Third_List_10	.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL #0
				.FILL Third_List_9
				.FILL #0
;

; -------------------------------------------------------------------------------------------------
; --- ConcatenateLists Subroutine -----------------------------------------------------------------

ConcatenateLists_Save_R0 .FILL #0
ConcatenateLists_Save_R1 .FILL #0
ConcatenateLists_Save_R2 .FILL #0
ConcatenateLists_Save_R3 .FILL #0
ConcatenateLists_Save_R4 .FILL #0
ConcatenateLists_Save_R7 .FILL #0

ConcatenateLists:
	; - Store Registers For Backup ---
	ST R0, ConcatenateLists_Save_R0
	ST R1, ConcatenateLists_Save_R1
	ST R2, ConcatenateLists_Save_R2
	ST R3, ConcatenateLists_Save_R3
	ST R4, ConcatenateLists_Save_R4
	ST R7, ConcatenateLists_Save_R7
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: Used for the character input/output (via 'GETC' and 'OUT').
	AND R1, R1, #0								; R1: course counter
	AND R2, R2, #0								; R2: List length label
	AND R3, R3, #0								; R3: Used for storing the current valid number input.
	AND R4, R4, #0								; R4: General purpose (for calculations, load and store).
	;											; R5: Unused.
	;											; R6: Unused.
	;											; R7: Unused.
	;
	; - Registers Initialization ---
	LD R0, First_Course_Students_List
	LD R1, First_Course_Students_List_Length
	LD R2, Second_Course_Students_List
	LD R3, Second_Course_Students_List_Length
	LD R4, Third_Course_Students_List
	;
	First_List_Loop:
		ADD R1, R1, #-1
		BRz Concat_First_To_Second
		LDR R0, R0, #6
	BR First_List_Loop
	;
	Concat_First_To_Second:
		STR R2, R0, #6
		STR R0, R2, #5
	;
	Second_List_Loop:
		ADD R3, R3, #-1
		BRz Concat_Second_To_Third
		LDR R2, R2, #6
	BR Second_List_Loop
	;
	Concat_Second_To_Third:
		STR R4, R2, #6
		STR R2, R4, #5
	;
	LD R1, First_Course_Students_List_Length
	LD R2, Second_Course_Students_List_Length
	LD R3, Third_Course_Students_List_Length
	ADD R1, R1, R2
	ADD R1, R1, R3
	ST R1, First_Course_Students_List_Length
	;
	; - Reload Registers Original Values ---
	LD R0, ConcatenateLists_Save_R0
	LD R1, ConcatenateLists_Save_R1
	LD R2, ConcatenateLists_Save_R2
	LD R3, ConcatenateLists_Save_R3
	LD R4, ConcatenateLists_Save_R4
	LD R7, ConcatenateLists_Save_R7
	;
RET												; Close ConcatenateLists Subroutine.


; -------------------------------------------------------------------------------------------------
; --- GetNumberOfStudents Subroutine --------------------------------------------------------------

GetNumberOfStudents_Save_R0 .FILL #0
GetNumberOfStudents_Save_R1 .FILL #0
GetNumberOfStudents_Save_R3 .FILL #0
GetNumberOfStudents_Save_R4 .FILL #0
GetNumberOfStudents_Save_R5 .FILL #0
GetNumberOfStudents_Save_R6 .FILL #0
GetNumberOfStudents_Save_R7 .FILL #0

Space_ASCII_Check .FILL #-32					; The spacae character ASCII negative value, for direct checkings.
Zero_ASCII_Check .FILL #-48						; The number zero character ('0') ASCII negative value, for direct checkings.

GetNumberOfStudents:
	; - Store Registers For Backup ---
	ST R0, GetNumberOfStudents_Save_R0
	ST R1, GetNumberOfStudents_Save_R1
	ST R3, GetNumberOfStudents_Save_R3
	ST R4, GetNumberOfStudents_Save_R4
	ST R5, GetNumberOfStudents_Save_R5
	ST R6, GetNumberOfStudents_Save_R6
	ST R7, GetNumberOfStudents_Save_R7
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: Used for the character input/output (via 'GETC' and 'OUT').
	AND R1, R1, #0								; R1: course counter
	;											; R2: List length label
	AND R3, R3, #0								; R3: Used for storing the current valid number input.
	AND R4, R4, #0								; R4: Flag - 0
	AND R5, R5, #0								; R5: General purpose (for calculations, load and store). !?!?!?
	AND R6, R6, #0								; R6: General purpose (for calculations, load and store). !?!!?!
	AND R7, R7, #0								; R7: General purpose (for calculations, load and store). !?!?!!
	;
	; - Registers Initialization ---
	ADD R1, R1, #3
	;
	; - Start Of The Subrutine ---
	GetNumberOfStudents_Loop:
		AND R3, R3, #0
		AND R4, R4, #0
		;
		Input_Students_Number_Loop:
			GETC
			OUT
			LD R5, Space_ASCII_Check
			ADD R5, R5, R0						; If the character input was Space character (ASCII value #32), -=================!!!!!!.
			BRz Store_Current_Number
			ADD R5, R0, #-10					; If the character input was NewLine (ASCII value #10), end the input loop.
			BRz Store_Current_Number
			;
			LD R5, Zero_ASCII_Check
			ADD R7, R5, R0						; !!!!!!!!!!!!!!!! If the ASCII value is smaller than #48, then the input is invalid (not an integer digit).
			;
			ADD R4, R4, #0
			BRz End_Students_Number_Loop
			; Shifting the current valid input one digit to the left - multiply it by 10.
			ADD R5, R3, #0
			AND R6, R6, #0
			ADD R6, R6, #9
			Multiply_By_10:
				ADD R3, R3, R5
				ADD R6, R6, #-1
			BRp Multiply_By_10
			;
			End_Students_Number_Loop:
				ADD R4, R4, #1
				ADD R3, R3, R7
		BR Input_Students_Number_Loop
		;
		Store_Current_Number:
			ADD R4, R4, #0
			BRz Input_Students_Number_Loop
			STR R3, R2, #0
			ADD R2, R2, #1
			;
		ADD R1, R1, #-1
	BRp GetNumberOfStudents_Loop
	;
	; - Reload Registers Original Values ---
	LD R0, GetNumberOfStudents_Save_R0
	LD R1, GetNumberOfStudents_Save_R1
	LD R3, GetNumberOfStudents_Save_R3
	LD R4, GetNumberOfStudents_Save_R4
	LD R5, GetNumberOfStudents_Save_R5
	LD R6, GetNumberOfStudents_Save_R6
	LD R7, GetNumberOfStudents_Save_R7
	;
RET												; Close GetNumberOfStudents Subroutine.


; -------------------------------------------------------------------------------------------------
; --- GetStudentGrades Subroutine -----------------------------------------------------------------

GetStudentGrades_Save_R0 .FILL #0
GetStudentGrades_Save_R1 .FILL #0
GetStudentGrades_Save_R2 .FILL #0
GetStudentGrades_Save_R3 .FILL #0
GetStudentGrades_Save_R4 .FILL #0
GetStudentGrades_Save_R5 .FILL #0
GetStudentGrades_Save_R6 .FILL #0
GetStudentGrades_Save_R7 .FILL #0

GetStudentGrades:
	; - Store Registers For Backup ---
	ST R0, GetStudentGrades_Save_R0
	ST R1, GetStudentGrades_Save_R1
	ST R2, GetStudentGrades_Save_R2
	ST R3, GetStudentGrades_Save_R3
	ST R4, GetStudentGrades_Save_R4
	ST R5, GetStudentGrades_Save_R5
	ST R6, GetStudentGrades_Save_R6
	ST R7, GetStudentGrades_Save_R7
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: Used for the character input/output (via 'GETC' and 'OUT').
	;											; R1: Holds the relevant linked list 'head' pointer (used for navigate through the list).
	;											; R2: Holds the relevant linked list length (used as a students counter).
	AND R3, R3, #0								; R3: Used for storing the current valid grade input number.
	AND R4, R4, #0								; R4: Flag - 0
	AND R5, R5, #0								; R5: General purpose (for calculations, load and store).
	AND R6, R6, #0								; R6: General purpose (for calculations, load and store).
	AND R7, R7, #0								; R7: General purpose (for calculations, load and store).
	;
	; - Start Of The Subrutine ---
	GetStudentGrades_Loop:
		ADD R2, R2, #-1
		;
		Input_Student_Grades_Loop:
			AND R4, R4, #0
			;
			Input_One_Grade_Loop:
				GETC
				OUT
				LD R5, Space_ASCII_Check
				ADD R5, R5, R0					; If the character input was Space character (ASCII value #32), -=================!!!!!!.
				BRz Store_Current_Grade
				ADD R5, R0, #-10				; If the character input was NewLine (ASCII value #10), end the input loop.
				BRz Store_Current_Grade
				;
				LD R5, Zero_ASCII_Check
				ADD R7, R5, R0					; If the ASCII value is smaller than #48, then the input is invalid (not an integer digit).
				;
				ADD R4, R4, #0
				BRz End_One_Grade_Loop
				; Shifting the current valid input one digit to the left - multiply it by 10.
				ADD R5, R3, #0
				AND R6, R6, #0
				ADD R6, R6, #9
				Multiply_10:
					ADD R3, R3, R5
					ADD R6, R6, #-1
				BRp Multiply_10
				;
				End_One_Grade_Loop:
					ADD R4, R4, #1
					ADD R3, R3, R7
			BR Input_One_Grade_Loop
			;
			Store_Current_Grade:
				ADD R4, R4, #0
				BRz Input_One_Grade_Loop
				STR R3, R1, #0
				ADD R1, R1, #1
				AND R3, R3, #0
				;
				ADD R5, R0, #-10				; If the character input was NewLine (ASCII value #10), end the input loop.
			BRnp Input_Student_Grades_Loop
		;
		ADD R7, R1, #-4
		LDR R1, R1, #2
		ADD R2, R2, #0
	BRp GetStudentGrades_Loop
	;
	AND R6, R6, #0
	STR R6, R7, #6
	;
	; - Reload Registers Original Values ---
	LD R0, GetStudentGrades_Save_R0
	LD R1, GetStudentGrades_Save_R1
	LD R2, GetStudentGrades_Save_R2
	LD R3, GetStudentGrades_Save_R3
	LD R4, GetStudentGrades_Save_R4
	LD R5, GetStudentGrades_Save_R5
	LD R6, GetStudentGrades_Save_R6
	LD R7, GetStudentGrades_Save_R7
	;
RET												; Close GetStudentGrades Subroutine.


; -------------------------------------------------------------------------------------------------
; --- AverageCalculator Subroutine ----------------------------------------------------------------

AverageCalculator_Save_R0 .FILL #0
AverageCalculator_Save_R1 .FILL #0
AverageCalculator_Save_R2 .FILL #0
AverageCalculator_Save_R3 .FILL #0
AverageCalculator_Save_R4 .FILL #0
AverageCalculator_Save_R5 .FILL #0
AverageCalculator_Save_R7 .FILL #0

AverageCalculator:
	; - Store Registers For Backup ---
	ST R0, AverageCalculator_Save_R0
	ST R1, AverageCalculator_Save_R1
	ST R2, AverageCalculator_Save_R2
	ST R3, AverageCalculator_Save_R3
	ST R4, AverageCalculator_Save_R4
	ST R5, AverageCalculator_Save_R5
	ST R7, AverageCalculator_Save_R7
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: sum & avg
	;											; R1: counter &&
	;											; R2: Div output
	AND R3, R3, #0								; R3: Div output
	AND R4, R4, #0								; R4: Linked list pointer
	AND R5, R5, #0								; R5: Linked list length
	;											; R6: Unused
	AND R7, R7, #0								; R7: Unused
	;
	; - Registers Initialization ---
	ADD R4, R1, #0
	ADD R5, R2, #0
	;
	; - Start Of The Subrutine ---
	AverageCalculator_Loop:
		AND R0, R0, #0
		AND R1, R1, #0
		;
		Sum_Student_Grades_Loop:
			LDR R3, R4, #0
			ADD R0, R0, R3
			;
			ADD R1, R1, #1
			ADD R4, R4, #1
			;
			ADD R3, R1, #-4
		BRnp Sum_Student_Grades_Loop
		;
		JSR Div
		STR R2, R4, #0
		;
		LDR R4, R4, #2
		ADD R5, R5, #-1
	BRp AverageCalculator_Loop
	;
	; - Reload Registers Original Values ---
	LD R0, AverageCalculator_Save_R0
	LD R1, AverageCalculator_Save_R1
	LD R2, AverageCalculator_Save_R2
	LD R3, AverageCalculator_Save_R3
	LD R4, AverageCalculator_Save_R4
	LD R5, AverageCalculator_Save_R5
	LD R7, AverageCalculator_Save_R7
	;
RET												; Close AverageCalculator Subroutine.


; -------------------------------------------------------------------------------------------------
; --- BubbleSort Subroutine -----------------------------------------------------------------------

BubbleSort_Save_R0 .FILL #0
BubbleSort_Save_R1 .FILL #0
BubbleSort_Save_R2 .FILL #0
BubbleSort_Save_R3 .FILL #0
BubbleSort_Save_R4 .FILL #0
BubbleSort_Save_R5 .FILL #0
BubbleSort_Save_R6 .FILL #0
BubbleSort_Save_R7 .FILL #0

BubbleSort:
	; - Store Registers For Backup ---
	ST R0, BubbleSort_Save_R0
	ST R2, BubbleSort_Save_R2
	ST R3, BubbleSort_Save_R3
	ST R4, BubbleSort_Save_R4
	ST R5, BubbleSort_Save_R5
	ST R6, BubbleSort_Save_R6
	ST R7, BubbleSort_Save_R7
	;
	; - Registers Reset ---
	AND R0, R0, #0								; R0: Linked list !! head !! pointer
	;											; R1: Linked list pointer - left
	;											; R2: Linked list pointer - right
	AND R3, R3, #0								; R3: Linked list length - index i
	AND R4, R4, #0								; R4: Linked list length - index j
	AND R5, R5, #0								; R5: General purpose (for calculations, load and store).
	AND R6, R6, #0								; R6: General purpose (for calculations, load and store).
	AND R7, R7, #0								; R7: General purpose (for calculations, load and store).
	;
	; - Registers Initialization ---
	ADD R0, R1, #0
	ADD R3, R2, #0
	;
	; - Start Of The Subrutine ---
	BubbleSort_Loop:
		ADD R4, R3, #-1
		;
		Bubble_Min_To_The_End:
			LDR R2, R1, #6						; Initializing R2 as the right element for comparison (R1.next).
			;
			LDR R6, R1, #4
			LDR R7, R2, #4
			NOT R7, R7
			ADD R7, R7, #1
			ADD R6, R6, R7
			BRzp Continue_BubbleSort			; Comparison between the left average to the right average - if left is smaller, swap.
			;
			LDR R6, R1, #5						; Check if the head of the list is the left swap, if it is - right is the new head.
			BRnp Swap
			ADD R0, R2, #0
			;
			Swap:
				LDR R6, R1, #5					; R6 = R1.prev
				STR R6, R2, #5					; R2.prev = R6 = R1.prev
				LDR R6, R2, #6					; R6 = R2.next
				STR R6, R1, #6					; R1.next = R6 = R2.next
				STR R2, R1, #5					; R1.prev = R2
				STR R1, R2, #6					; R2.next = R1
				;
				ADD R6, R6, #0
				BRz Skip_NextPrev_Swap
				STR R1, R6, #5					; (R1.next).prev = R1
				Skip_NextPrev_Swap:
					LDR R6, R2, #5				; R6 = R2.prev
				;
				ADD R6, R6, #0
				BRz Skip_PrevNext_Swap
				STR R2, R6, #6					; (R2.prev).next = R2
				Skip_PrevNext_Swap:
					ADD R1, R2, #0				; Keep R1 as the left node pointer.
			;
			Continue_BubbleSort:
				LDR R1, R1, #6
				ADD R4, R4, #-1
		BRp Bubble_Min_To_The_End
		;
		ADD R1, R0, #0
		ADD R3, R3, #-1
	BRp BubbleSort_Loop
	;
	ADD R1, R0, #0
	ADD R2, R3, #0
	;
	; - Reload Registers Original Values ---
	LD R0, BubbleSort_Save_R0
	LD R2, BubbleSort_Save_R2
	LD R3, BubbleSort_Save_R3
	LD R4, BubbleSort_Save_R4
	LD R5, BubbleSort_Save_R5
	LD R6, BubbleSort_Save_R6
	LD R7, BubbleSort_Save_R7
	;
RET												; Close BubbleSort Subroutine.


; -------------------------------------------------------------------------------------------------
; --- BestStudent Subroutine -----------------------------------------------------------------------

BestStudent_Save_R3 .FILL #0
BestStudent_Save_R4 .FILL #0
BestStudent_Save_R5 .FILL #0
BestStudent_Save_R6 .FILL #0
BestStudent_Save_R7 .FILL #0

Space_ASCII_TMPTMPTPMT .FILL #32							; The spacae character ASCII value.

BestStudent:
	; - Store Registers For Backup ---
	ST R3, BestStudent_Save_R3
	ST R4, BestStudent_Save_R4
	ST R5, BestStudent_Save_R5
	ST R6, BestStudent_Save_R6
	ST R7, BestStudent_Save_R7
	;
	; - Registers Reset ---
	;											; R0: Grades Array pointer (length of 6)
	;											; R1: Linked list pointer
	;											; R2: Linked list length
	AND R3, R3, #0								; R3: ???
	AND R4, R4, #0								; R4: ???
	AND R5, R5, #0								; R5: ???
	AND R6, R6, #0								; R6: ???
	AND R7, R7, #0								; R7: ???
	;
	; - Best_Grades_Array Reset ---
	ADD R3, R0, #0
	ADD R4, R4, #6
	Reset_Best_Grades_Array_Loop:				; Iterate over the array and initialize every cell with the value #0.
		STR R5, R3, #0
		ADD R3, R3, #1
		ADD R4, R4, #-1
	BRp Reset_Best_Grades_Array_Loop
	;
		; !!!!!!!!!!!!!!!!!!!!
	ADD R3, R1, #0
	ADD R4, R2, #0
	TMP_Loop1:
		LDR R0, R3, #4
		JSR PrintNum
		LD R0, Space_ASCII_TMPTMPTPMT
		OUT
		LDR R3, R3, #6
		ADD R4, R4, #-1
	BRp TMP_Loop1
	AND R0, R0, #0
	ADD R0, R0, #10
	OUT
	AND R3, R3, #0								; R3: ???
	AND R4, R4, #0								; R4: ???
	AND R5, R5, #0								; R5: ???
	AND R6, R6, #0								; R6: ???
	AND R7, R7, #0								; R7: ???
	; !!!!!!!!!!!!!!!!!!!!
	; - Start Of The Subrutine ---
	JSR BubbleSort
	;
		; !!!!!!!!!!!!!!!!!!!!
	ADD R3, R1, #0
	ADD R4, R2, #0
	TMP_Loop:
		LDR R0, R3, #4
		JSR PrintNum
		LD R0, Space_ASCII_TMPTMPTPMT
		OUT
		LDR R3, R3, #6
		ADD R4, R4, #-1
	BRp TMP_Loop
	AND R0, R0, #0
	ADD R0, R0, #10
	OUT
	AND R3, R3, #0								; R3: ???
	AND R4, R4, #0								; R4: ???
	AND R5, R5, #0								; R5: ???
	AND R6, R6, #0								; R6: ???
	AND R7, R7, #0								; R7: ???
	; !!!!!!!!!!!!!!!!!!!!
	;
	ADD R6, R6, #6
	;
	LDR R3, R1, #4
	STR R3, R0, #0
	LDR R1, R1, #6
	BestStudent_Loop:
		ADD R2, R2, #-1
		BRnz End_BestStudent
		;
		LDR R3, R1, #4
		LDR R4, R0, #0
		NOT R4, R4
		ADD R4, R4, #1
		ADD R4, R4, R3
		BRnz End_BestStudent_Loop
		ADD R0, R0, #1
		STR R3, R0, #0
		ADD R6, R6, #-1
		End_BestStudent_Loop:
			LDR R1, R1, #6
		ADD R6, R6, #0
	BRp BestStudent_Loop
	;
	End_BestStudent:
	; - Reload Registers Original Values ---
	LD R3, BestStudent_Save_R3
	LD R4, BestStudent_Save_R4
	LD R5, BestStudent_Save_R5
	LD R6, BestStudent_Save_R6
	LD R7, BestStudent_Save_R7
	;
RET												; Close BestStudent Subroutine.


; -------------------------------------------------------------------------------------------------
; --- PrintNum Subroutine -------------------------------------------------------------------------

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
End_PrintNum_String	.FILL #0					; Last cell is preserved for ASCII NULL value (mark the end of a string).

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
	BRnp Extract_Digits_Loop					; If the last division quotient is greater than 0, there are still digits to extract.
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


; -------------------------------------------------------------------------------------------------
; --- Div Subroutine ------------------------------------------------------------------------------

Div_Save_R0 .FILL #0
Div_Save_R1 .FILL #0
Div_Save_R4 .FILL #0
Div_Save_R5 .FILL #0
Div_Save_R6 .FILL #0
Div_Save_R7 .FILL #0

Div:
	ST R0, Div_Save_R0
	ST R1, Div_Save_R1
	ST R4, Div_Save_R4
	ST R5, Div_Save_R5
	ST R6, Div_Save_R6
	ST R7, Div_Save_R7

	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0								; R4 is a flag for R1 negativity
	AND R5, R5, #0								; R5 is a flag for R0 negativity
	AND R6, R6, #0

	; Checking if we divide by 0
	ADD R1, R1, #0
	BRnp NOT_DIVIDE_IN_ZERO
	ADD R2, R2, #-1
	ADD R3, R3, #-1
	BR DONE_Div

	NOT_DIVIDE_IN_ZERO:
		ADD R1, R1, #0							; Checking the sign of R1
		BRn R1_NEGATIVE_Div
		NOT R1, R1
		ADD R1, R1, #1							; R1 = -R1
	BR CHECK_R0_Div
	R1_NEGATIVE_Div:
		ADD R4, R4, #1							; R4 = 1 Because R1 is negative

	CHECK_R0_Div:
		ADD R0, R0, #0
		BRzp LOOP_Div							; If R0 >= 0 , go to loop_div
		NOT R0, R0
		ADD R0, R0, #1							; R0 = -R0
		ADD R5, R5, #1							; R5 = 1 , Because R0 is negative

	LOOP_Div:
		ADD R6, R0, R1							; R6=R0+R1
		BRn MODULO								; If R0<R1 go to modulo
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
	
RET												; Close Div Subrutine.


; -------------------------------------------------------------------------------------------------
; -------------------------------------------------------------------------------------------------

.END