.orig x3000

;checking TriangleInequality
AND R0, R0, #0
ADD R0, R0, #0
AND R1, R1, #0
ADD R1, R1, #0
AND R2, R2, #0
ADD R2, R2, #0
JSR TriangleInequality
ADD R3, R3, #0

HALT

; ------------------------------------------
; 
R0_SAVE_TriangleInequality .fill #0
R1_SAVE_TriangleInequality .fill #0
R2_SAVE_TriangleInequality .fill #0
R4_SAVE_TriangleInequality .fill #0
R5_SAVE_TriangleInequality .fill #0
R6_SAVE_TriangleInequality .fill #0
R7_SAVE_TriangleInequality .fill #0

TriangleInequality:
	ST R0, R0_SAVE_TriangleInequality
	ST R1, R1_SAVE_TriangleInequality
	ST R2, R2_SAVE_TriangleInequality
	ST R4, R4_SAVE_TriangleInequality
	ST R5, R5_SAVE_TriangleInequality
	ST R6, R6_SAVE_TriangleInequality
	ST R7, R7_SAVE_TriangleInequality

	;Checking if R0/R1/R2 are negative. In this case R3=-1
	;Checking R0
	ADD R0, R0, #0
	BRzp CHECK_IF_R1_IS_NEGATIVE_Tri
	BR NOT_GOOD

	CHECK_IF_R1_IS_NEGATIVE_Tri:
		ADD R1, R1, #0
		BRzp CHECK_IF_R2_IS_NEGATIVE_Tri
		BR NOT_GOOD

	CHECK_IF_R2_IS_NEGATIVE_Tri:
		ADD R2, R2, #0
		BRzp FINISH_CHECK_NEGATIVITY_Tri
		BR NOT_GOOD

	FINISH_CHECK_NEGATIVITY_Tri:
		AND R4, R4, #0
		AND R5, R5, #0
		AND R6, R6, #0

		NOT R4, R0
		ADD R4, R4, #1 ;R4=-R0

		NOT R5, R1
		ADD R5, R5, #1 ;R5=-R1

		NOT R6, R2
		ADD R6, R6, #1 ;R6=-R2

		;Checking the Triangle Inequality
		AND R7, R7, #0
		
		;1. R0<=R1+R2 --> 0<=R1+R2-R0
		ADD R7, R1, R2 ;R7=R1+R2
		ADD R7, R7, R4 ;R7=R7-R0
		BRn NOT_GOOD

		;2. R1<=R0+R2 --> 0<=R0+R2-R1
		AND R7, R7, #0
		ADD R7, R0, R2 ;R7=R0+R2
		ADD R7, R7, R5 ;R7=R7-R1
		BRn NOT_GOOD

		;3. R2<=R0+R1-R2 --> 0<=R0+R1-R2
		AND R7, R7, #0
		ADD R7, R0, R1 ;R7=R0+R1
		ADD R7, R7, R6 ;R7=R7-R2
		BRn NOT_GOOD
		BR GOOD

	NOT_GOOD:
		AND R3, R3, #0
		BR DONE_TriangleInequality

	GOOD:
		ADD R3, R3, #1

	DONE_TriangleInequality:
		LD R0, R0_SAVE_TriangleInequality
		LD R1, R1_SAVE_TriangleInequality
		LD R2, R2_SAVE_TriangleInequality
		LD R4, R4_SAVE_TriangleInequality
		LD R5, R5_SAVE_TriangleInequality
		LD R6, R6_SAVE_TriangleInequality
		LD R7, R7_SAVE_TriangleInequality
RET

.end