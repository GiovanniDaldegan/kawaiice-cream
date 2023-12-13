########################################################
# render.s - KawaiIce Cream - Projeto ISC 2023-2
#
# Descrição: escreve os bytes de um bmp na memória do
# bitmap display para renderização.
#
# Input:	a0: id do sprite
#		a1: frame (0, 1)
#		a3: distância x do pivot
#		a4: distância y do pivot
########################################################
#		t0: endereço bitmap display
#		t1: endereço do bmp
#		t2: altura
#		t3: largura
#		t4: contadorY
#		t5: contadorX
#		t6: valores dos 4 pixels
########################################################

.data


.include "sprites/blococogu.data"
.include "sprites/blococoraçao.data"

.include "sprites/bala.data"
.include "sprites/pirulito.data"
.include "sprites/pudim.data"
.include "sprites/bolo.data"
.include "sprites/cupcake.data"

.include "sprites/inimigo1.data"

.include "sprites/player.data"


.text

GET_SPRITE:
	# se a0 é 0, é uma célula vazia; se é 1, é um bloco inquebrável
	li	t0, 1
	ble	a0, t0, END_RENDER

	# bloco quebrável
	li	t0, 2
	beq	a0, t0, sprite02

	# coletável
	li	t0, 3
	beq	a0, t0, sprite03

	# bloco com objeto coletável
	li	t0, 4
	beq	a0, t0, sprite04

	# inimigo 1
	li	t0, 5
	beq	a0, t0, sprite05

	# jogador
	li	t0, 9
	beq	a0, t0, sprite06

	ret						# se o id não for reconhecido, não renderiza nada

sprite01:
	la	a0, blococoracao
	j	RENDER

sprite02:
	la	a0, blococogu
	j	RENDER
sprite03:
	la	a0, bolo
	j	RENDER

sprite04:
	la	a0, blococogu
	j	RENDER

sprite05:
	la	a0, inimigo1
	j	RENDER

		
sprite06:
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
	j	RENDER

	playerLeft:
	la	a0, playeresquerda
	j	RENDER

	playerDown:
	la	a0, playerbaixo
	j	RENDER

	playerRight:
	la	a0, playerdireita
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
