########################################################
# gameUI - KawaiIce Cream - Projeto ISC 2023-2
#
# Descrição: desenha na tela a pontuação e o tempo
# decorrido.
########################################################

.data

.include "sprites/0.data"
.include "sprites/1.data"
.include "sprites/2.data"
.include "sprites/3.data"
.include "sprites/4.data"
.include "sprites/5.data"
.include "sprites/6.data"
.include "sprites/7.data"
.include "sprites/8.data"
.include "sprites/9.data"

.include "sprites/doispontos.data"

.text

# 180
# levelTimer // 3 -> ## min	| t0
# levelTimer %  3 _> ## s	| t1
# t4: ponteiro do bmp

	la	t2, levelTimer
	lw	t2, 0(t2)

	li	t3, 60

	div	t0, t2, t3
	rem	t1, t2, t3


draw_time:
	# div



draw_0:
	la	t4, 0_bmp

draw_1:
	la	t4, 1_bmp

draw_2:
	la	t4, 2_bmp

draw_3:
	la	t4, 3_bmp

draw_4:
	la	t4, 4_bmp

draw_5:
	la	t4, 5_bmp

draw_6:
	la	t4, 6_bmp

draw_7:
	la	t4, 7_bmp

draw_8:
	la	t4, 8_bmp

draw_9:
	la	t4, 9_bmp

draw_double_dot:
	la	t4, doispontos


