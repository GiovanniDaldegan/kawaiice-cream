########################################################
# render - KawaiIce Cream - Projeto ISC 2023-2
#
# Descrição: escreve os bytes de um bmp na memória do
# bitmap display para renderização.
#
# Input:	a0: id do sprite
#		a1: frame (0, 1)
#		a2: endereço da matriz ???
#		a3: distância x do pivot
#		a4: distância y do pivot
########################################################
#	t0: endereço bitmap display
#	t1: endereço do bmp
#	t2: altura
#	t3: largura
#	t4: contadorY
#	t5: contadorX
#	t6: valores dos 4 pixels
########################################################

.data


# Fase 1
.include "sprites/blococogu.data"
.include "sprites/blococoguitem.data"
.include "sprites/blococoguquebra.data"

.include "sprites/bala.data"
.include "sprites/cupcake.data"
.include "sprites/pirulito.data"
.include "sprites/pudim.data"
.include "sprites/bolo.data"
.include "sprites/donut.data"

.include "sprites/inimigo1.data"

.include "sprites/player.data"

.include "sprites/playerassoprandoesquerda1.data"
.include "sprites/playercostasassoprando.data"
.include "sprites/playerassoprandofrente.data"
.include "sprites/playerassoprandodireita.data"


# Fase 2
.include "sprites/blocoflor.data"
.include "sprites/blocofloritem.data"
.include "sprites/blocoflorquebra.data"

.include "sprites/inimigo2.data"


.text

GET_SPRITE:
	# se a0 é 0, é uma célula vazia; se é 1, é um bloco inquebrável
	li	t0, 1
	beq	a0, t0, END_RENDER

	la	t0, sceneId
	lb	t0, 0(t0)
	li	t1, 2
	beq	t0, t1, get_sprite_level_2

get_sprite_level_1:
	# bloco quebrável
	li	t0, 2
	beq	a0, t0, block_collectible_1

	# coletável
	li	t0, 3
	beq	a0, t0, sprite_02_1

	# inimigo
	li	t0, 5
	beq	a0, t0, sprite_04_1

	# jogador
	li	t0, 9
	beq	a0, t0, sprite_05

	ret						# se o id não for reconhecido, não renderiza nada

# Sprites fase 1
sprite_01_1:
	la	a0, blococogu
	j	RENDER

sprite_02_1:
	la	t0, candyType
	lb	t0, 0(t0)

	li	t2, 1

	beq	t0, t2, sprite_candy_1_2

sprite_candy_1_1:
	la	a0, bala

	j	RENDER

sprite_candy_1_2:
	la	a0, cupcake

	j	RENDER

block_collectible_1:
	la	t0, returnAddress1
	sw	ra, 0(t0)

	mv	t6, a0
	mv	t5, a1

	mv	a0, s4
	mv	a1, s3
	la	a2, matrix_candy
	jal	get_cell_address
	lb	t0, 0(a0)


	mv	a0, t6
	mv	a1, t5

	la	t1, returnAddress1
	lw	ra, 0(t1)

	li	t1, 3
	beq	t0, t1, sprite_03_1

	j	sprite_01_1

sprite_03_1:

	la	a0, blococoguitem
	
	j	RENDER

sprite_04_1:
	la	a0, inimigo1
	j	RENDER


get_sprite_level_2:
	# bloco quebrável
	li	t0, 2
	beq	a0, t0, block_collectible_2

	# coletável
	li	t0, 3
	beq	a0, t0, sprite_02_2

	# bloco com objeto coletável
	li	t0, 4
	beq	a0, t0, sprite_03_2

	# inimigo
	li	t0, 5
	beq	a0, t0, sprite_04_2

	# jogador
	li	t0, 9
	beq	a0, t0, sprite_05

	ret						# se o id não for reconhecido, não renderiza nada


# Sprites fase 2
sprite_01_2:
	la	a0, blocoflor
	j	RENDER
sprite_02_2:
	la	t0, candyType
	lb	t0, 0(t0)

	li	t2, 1

	beq	t0, t2, sprite_candy_2_2

sprite_candy_2_1:
	la	a0, pirulito

	j	RENDER

sprite_candy_2_2:
	la	a0, donut

	j	RENDER


block_collectible_2:
	la	t0, returnAddress1
	sw	ra, 0(t0)

	mv	t6, a0
	mv	t5, a1

	mv	a0, s4
	mv	a1, s3
	la	a2, matrix_candy
	jal	get_cell_address
	lb	t0, 0(a0)

	mv	a0, t6
	mv	a1, t5

	la	t1, returnAddress1
	lw	ra, 0(t1)

	li	t1, 3
	beq	t0, t1, sprite_03_2

	j	sprite_01_2


sprite_03_2:
	la	a0, blocofloritem
	j	RENDER

sprite_04_2:
	la	a0, inimigo2
	j	RENDER


sprite_05:
	la	t0, playerDirection
	lb	t0, 0(t0)

	beq	t0, zero, playerUp
	
	li	t1, 1
	beq	t0, t1, playerLeft

	li	t1, 2
	beq	t0, t1, playerDown

	li	t1, 3
	beq	t0, t1, playerRight

	playerUp:
	la	a0, playercostas

	la	t0, playerState
	lb	t0, 0(t0)
	beq	t0, zero, RENDER

	la	a0, playercostasassoprando

	j	RENDER

	playerLeft:
	la	a0, playeresquerda

	la	t0, playerState
	lb	t0, 0(t0)
	beq	t0, zero, RENDER

	la	a0, playerassoprandoesquerda1

	j	RENDER

	playerDown:
	la	a0, playerbaixo

	la	t0, playerState
	lb	t0, 0(t0)
	beq	t0, zero, RENDER

	la	a0, playerassoprandofrente

	j	RENDER

	playerRight:
	la	a0, playerdireita

	la	t0, playerState
	lb	t0, 0(t0)
	beq	t0, zero, RENDER

	la	a0, playerassoprandodireita

	j	RENDER


RENDER:
	# endereço do bitmap display
	li	t0, 0xFF0
	add	t0, t0, a1
	slli	t0, t0, 20


	# calcula o offset x e y
	li	t2, 320
	mul	t2, t2, a4			# pula as linhas ignoradas (320 x n de linhas)
	add	t2, t2, a3			# pula as colunas ignoradas
	add	t0, t0, t2			# ajusta o endereço no bitmap para iniciar o algoritmo com a posição desejada


	lw	t3, 0(a0)			# t3: largura
	lw	t2, 4(a0)			# t2: altura

	addi	a0, a0, 8			# pula largura e altura

	# início da renderização
	li	t4, 0				# inicia a linha
	
start_line:
	bge	t4, t2, END_RENDER		# se o contadorY chegar na última linha, termina a renderização
	addi	t4, t4, 1

	li	t5, 0				# reseta o contadorX

render_pixel:
	lb	t6, 0(a0)			# carrega o pixel no .data
	sb	t6, 0(t0)			# escreve no bitmap display

	addi	t5, t5, 1			# avança no contadorX
	addi	a0, a0, 1			# avança no arquivo
	addi	t0, t0, 1			# avança no display

	bge	t5, t3, next_line		# se o contadorX chegar no último pixel, vai pra próxima linha

	j	render_pixel

next_line:
	addi	t0, t0, 320
	sub	t0, t0, t3

	j	start_line

END_RENDER:
	ret
