##################################################
#	KawaiIce Cream - ISC 2023-2
# 
# Projeto de ISC do 2º semestre de 2023. Jogo de-
# senvolvido em Assembly na ISA RISC-V, inspirado
# em Bad Ice Cream (Nitrome).
# 
# Realizado por: Giovanni, Michele, Rute
##################################################

.data

playerPos:
.word 0, 0

key:
.word 0

frame:
.word 


.include "maps/map1.data"

.text

j	MAIN_LOOP

.include "input.asm"
.include "render.asm"

MAIN_LOOP:
	
# [ Input ]
jal	INPUT
	
	
# [ Lógica do jogo ]
GAME_LOOP:
	
	
# [ Renderização ]
GAME_RENDER:
	li	t0, 0xFF200604
	lb	t1, 0(t0)
	xori	t1, t1, 1	# se o frame for 0, vira 1; se é 1, vira 0
	sb	t1, 0(t0)
	
	
render_background:
	#la	a0, <background>
	#li	a1, 0
	#li	a3, 0
	#li	a4, 0
	
	#jal	RENDER
	
matrix_render:
# s0: endereço na matriz
# s1: altura
# s2: largura
# s3: contadorY
# s4: contadorX
	
	# s0: endereço da matriz
	la	s0, map1
	
	lw	s2, 0(s0)			# s2: largura
	lw	s1, 4(s0)			# s1: altura
	
	addi	s0, s0, 8			# pula largura e altura
	
	li	s3, 0				# inicia contadorY (s3)
	
line_loop:
	addi	s3, s3, 1
	bge	s3, s1, END_MAIN_RENDER		# se o contadorY for maior ou igual à altura, termina a renderização
	
	li	s4, 0				# inicia contadorX (s4)
	
cell_loop:
	lb	a0, 0(s0)			# valor do id na célula
	li	a1, 0				# frame			NOTE: implementar uma forma de trocar o frame
	
	li	t5, 16
	
	mul	a3, s4, t5			# calcula a distância X da sprite (contadorX x 16)	
	addi	s3, s3, -1
	mul	a4, s3, t5			# calcula a distância Y (contadorY x 16)
	addi	s3, s3, 1
	
	addi	s4, s4, 1			# soma 1 ao contadorX
	addi	s0, s0, 1			# soma 1 ao enredeço da matriz

	jal	GET_SPRITE			# executa o algoritmo de renderização
	
	bge	s4, s2, line_loop		# se o contadorX for igual ou maior à largura, inicia a próxima linha
	#li	t6, 1
	#bge	s3, t6, EXIT
	j	cell_loop			# senão, continua percorrendo a linha da matriz
	
END_MAIN_RENDER:

	
	jal	CLEAR_INPUT			# reseta "key"
	
TICK:
	li	a7, 32
	li	a0, 50
	ecall
	
	j	MAIN_LOOP
	
EXIT:
	li a7, 10
	ecall
	
	
	
	
	
	
	
