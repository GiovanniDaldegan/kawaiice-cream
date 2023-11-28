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

frame:		.byte 0				# em qual frame renderizar
sceneId:	.byte 0
matrix:		.word 0				# endereço da matriz atual (variável de acordo com o nível)
matrixSize:	.byte 20, 15
playerPos:	.word 0, 0			# posição do personagem na matriz
key:		.byte 0				# tecla pressionada
returnAddress:	.word 0

.include "maps/fase1.data"
.include "sprites/fundomapa1.data"


.text

j	MAIN

.include "input.asm"
.include "render.asm"


MAIN:
	li	t0, 0xFF200604
	lb	t1, 0(t0)
	
	# troca em qual frame renderizar
	la	t2, frame
	sb	t1, 0(t2)
	
	# troca o frame no bitmap
	xori	t1, t1, 1			# se o frame for 0, vira 1; se é 1, vira 0
	sb	t1, 0(t0)
	
	
# [ Seleção de cena ]
SCENE_SETUP:
	la	t0, fase1
	la	t1, matrix
	sw	t0, 0(t1)			# define em qual endereço a matriz se baseia (de qual nível é a matriz)
	
	
# [ Input ]
GAME_INPUT:
	jal	INPUT				# guarda a tecla pressionada em a0
	la	t0, key
	sb	a0, 0(t0)			# salva a tecla em "key" (ASCII)
	
	
# [ Lógica do jogo ]

	
	#jal	PLAYER_MOVEMENT
	
	
# [ Renderização ]
GAME_RENDER:
	la	t0, frame
	lb	a1, 0(t0)			# define em que frame renderizar
	
render_background:
	la	a0, fundomapa1
	li	a3, 0
	li	a4, 0
	
	jal	RENDER
	
matrix_render:
	# s0: endereço na matriz
	# s1: altura
	# s2: largura
	# s3: contadorY
	# s4: contadorX
		
	# s0: endereço da matriz
	la	t0, matrix
	lw	s0, 0(t0)
	
	# s2: largura, s1: altura
	lw	s2, 0(s0)
	lw	s1, 4(s0)
	
	addi	s0, s0, 8			# pula largura e altura e avança para a matriz
	
	# s3: contador Y
	li	s3, 0	
	
line_loop:
	addi	s3, s3, 1
	bgt	s3, s1, END_MAIN_RENDER		# se o contadorY for maior ou igual à altura, termina a renderização
	
	# s4: contadorX
	li	s4, 0
	
cell_loop:
	lb	a0, 0(s0)			# valor do id na célula
	
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
	# reseta a tecla salva
	jal	CLEAR_INPUT
	
	
TICK:
	li	a7, 32
	li	a0, 50
	ecall
	
	j	MAIN
	
	
EXIT:
	li a7, 10
	ecall





# Funções

getCellAddress:
########################################
# Dadas as coordenadas de uma célula na
# matriz, retorna o enredeço dela
# 
# Input:	a0: posX
# 		a1: posY
# 
# Output:	a0: endereço
########################################
	la	t0, matrix
	lb	t1, 0(t0)			# t1: tamanho horizontal da matriz
	
	mul	t2, a1, t1			# calcula a linha
	add	t2, t2, a0			# calcula a coluna na linha
	add	a0, a0, t2			# calcula o endereço da célula
	
	ret
	
	
checkCell:
########################################
# Dada uma posição na matriz, retorna
# o id da célula naquela posição
# 
# Input:	a0: posX
# 		a1: posY
# 
# Output:	a0: id da célula
########################################
	la	t0, matrix
	lb	t1, 0(t0)			# t1: tamanho horizontal da matriz
	
	mul	t2, a1, t1			# calcula a linha
	add	t2, t2, a0			# calcula a coluna na linha
	add	t0, t0, t2			# calcula o endereço da célula
	
	lb	a0, 0(t0)
	
	ret
	
return:	ret
	
	
	
	
	
