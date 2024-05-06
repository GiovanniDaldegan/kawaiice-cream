########################################################
#		KawaiIce Cream - ISC 2023-2
# 
# Projeto de ISC do 2º semestre de 2023. Jogo desenvol-
# vido em Assembly na ISA RISC-V, inspirado em Bad Ice
# Cream (Nitrome).
# 
# Realizado por:	Giovanni Daldegan
#			Michele Nakagomi Lebarbenchon
#			Rute Alves Fernandes
########################################################


.data

returnAddress0:	.word 0				# word para salvar o ra quando forem necessários 2 "jals"
returnAddress1:	.word 0				# word para salvar o ra quando forem necessários 3 "jals"

frame:		.byte 0				# em qual frame renderizar
key:		.byte 0				# tecla pressionada
sceneId:	.byte 0				# id da cena atual
matrix:		.word 0				# word com o endereço da matriz atual (variável de acordo com o nível)
background:	.word 0				# word com o endereço do fundo atual

currentTime:	.word 0				# último instante medido
gameTickTimer:	.word 0				# temporizador de tick do jogo
levelTimer:	.word 0				# temporizador das fases (segundos)
cycleTimer:	.word 0				# 


.text
	li	a7, 30
	ecall
	la	t0, gameTickTimer
	sw	a0, 0(t0)			# instante inicial do jogo


	jal	menu_setup			# prepara o menu


# Loop principal do jogo
MAIN_LOOP:
	li	t0, 0xFF200604
	lb	t1, 0(t0)			# carrega o frame

	# troca em qual frame renderizar
	la	t2, frame
	sb	t1, 0(t2)

	# troca o frame no bitmap
	xori	t1, t1, 1			# se o frame for 0, vira 1; se é 1, vira 0
	sb	t1, 0(t0)

# [ Input ]
GAME_INPUT:
	jal	INPUT				# guarda a tecla pressionada em a0
	la	t0, key
	sb	a0, 0(t0)			# salva a tecla em "key" (ASCII)

GAME_TICK:
	# li	a7, 30
	# ecall

	# la	t0, gameTickTimer
	# lw	t0, 0(t0)

	# sub	a0, a0, t0
	# li	t1, 120
	# ble	a0, t1, MAIN_LOOP


# [ Renderização do fundo ]
render_background:
	la	a0, background			# carrega o fundo
	lw	a0, 0(a0)
	lw	t0, 0(a0)
	beq	t0, zero, SCENE			# se o endereço do fundo for 0, pula a renderização dele

	la	t0, frame
	lb	a1, 0(t0)			# define em que frame renderizar
	li	a3, 0
	li	a4, 0

	jal	RENDER				# renderiza o fundo


# [ Lógica do jogo ]
SCENE:
	la	t2, sceneId
	lb	t2, 0(t2)

	beq	t2, zero, skip_candy_count

	li	t0, 3
	bge	t2, t0, skip_candy_count

	la	t0, candyTotal
	la	t1, candyCount

	addi	t2, t2, -1

	add	t0, t0, t2
	add	t1, t1, t2

	lb	t0, 0(t0)			# carrega o candyTotal de acordo com a fase (sceneId - 1)
	lb	t1, 0(t1)			# carrega o candyCount de acordo com a fase (sceneId - 1)


	la	t3, candyType
	lb	t4, 0(t3)

	beq	t4, zero, check_next_candy	# checa em qual doce do nível tá

	j	check_level

	check_next_candy:

	beq	t1, t0, next_candy		# candyCount == candyTotal

	j	check_level

	next_candy:
	li	t4, 1
	sb	t4, 0(t3)

	la	t0, candyCount
	sb	zero, 0(t0)
	sb	zero, 1(t0)

	bne	t2, zero, next_candy_2		# se sceneId - 1 =/= 0

	next_candy_1:
	la	t0, matrix_candy
	la	t1, fase1Doces2Copy
	sw	t1, 0(t0)

	j	skip_candy_count

	next_candy_2:
	la	t0, matrix_candy
	la	t1, fase2Doces2Copy
	sw	t1, 0(t0)

	j	skip_candy_count

	# puxa a segunda matriz

	check_level:
	bge	t1, t0, level_complete

	skip_candy_count:


	j	SCENE_SETUP


# [ Música ]
MUSIC:


# Fim do ciclo do loop principal
END_MAIN:
	# reseta a tecla salva
	jal	CLEAR_INPUT


	# game tick
	li	a7, 32
	li	a0, 45
	ecall

	j	MAIN_LOOP

# Sair
EXIT:
	li a7, 10
	ecall




# Funções genéricas

get_cell_address:
	########################################
	# Dadas as coordenadas de uma célula na
	# matriz, retorna o enredeço dela
	# 
	# Input:	a0: posX
	# 		a1: posY
	# 		a2: matriz
	# 
	# Output:	a0: endereço
	########################################

	lw	a2, 0(a2)
	lw	t1, 0(a2)			# t1: tamanho horizontal da matriz

	addi	a2, a2, 8			# pula largura e altura

	mul	t2, a1, t1			# calcula a linha
	add	t2, t2, a0			# calcula a coluna na linha
	add	a0, a2, t2			# calcula o endereço da célula e guarda em a0

	ret


copy_matrix:
	########################################
	# Dadas duas matrizes, copia a primeira
	# na segunda, byte por byte.
	# 
	# Input:	a0: matriz 1
	# 		a1: matriz 2
	########################################

	lw	t0, 0(a0)			# t0: largura
	lw	t1, 4(a0)			# t1: altura

	mul	t0, t0, t1
	addi	t0, t0, -1			# t0: índice da última célula

	addi	a0, a0, 8
	addi	a1, a1, 8

	li	t1, 0
	copy_matrix_loop:
	bge	t1, t0, finish_copy

	lb	t2, 0(a0)
	sb	t2, 0(a1)

	addi	a0, a0, 1
	addi	a1, a1, 1
	addi	t1, t1, 1

	j	copy_matrix_loop

	finish_copy:
	ret


.include "input.asm"
.include "render.asm"
.include "sceneManager.asm"
.include "scenes.asm"				# NOTE: ver se esse arquivo é necessário
