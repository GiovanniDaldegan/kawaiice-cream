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

timer:		.word 0
cycleTimer:	.word 0


.text

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


# [ Renderização do fundo ]
render_background:
	la	a0, background			# carrega o fundo
	lw	a0, 0(a0)
	lw	t0, 0(t0)
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

	beq	t2, zero, skipCandyCount

	li	t0, 3
	bgt	t2, t0, skipCandyCount

	la	t0, candyTotal
	la	t1, candyCount

	addi	t2, t2, -1

	add	t0, t0, t2
	add	t1, t1, t2

	lb	t0, 0(t0)
	lb	t1, 0(t1)

	bge	t1, t0, next_scene

	skipCandyCount:


	j	SCENE_SETUP


# [ Música ]



END_MAIN:
	# reseta a tecla salva
	jal	CLEAR_INPUT


	# game tick
	li	a7, 32
	li	a0, 50
	ecall

	j	MAIN_LOOP


GAME_OVER:
	j	reset


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
	# 
	# Output:	a0: endereço
	########################################
	la	t0, returnAddress1
	sw	ra, 0(t0)

	la	t0, matrix
	lw	t0, 0(t0)
	lw	t1, 0(t0)			# t1: tamanho horizontal da matriz

	addi	t0, t0, 8			# pula largura e altura

	addi	a0, a0, -1
	addi	a1, a1, -1

	mul	t2, a1, t1			# calcula a linha
	add	t2, t2, a0			# calcula a coluna na linha
	add	a0, t0, t2			# calcula o endereço da célula e guarda em a0


	la	t0, returnAddress1
	lw	ra, 0(t0)
	ret



.include "input.asm"
.include "render.asm"
.include "sceneManager.asm"
.include "scenes.asm"				# NOTE: ver se esse arquivo é necessário

.include "player.asm"
