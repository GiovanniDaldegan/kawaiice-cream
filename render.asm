##################################################
# render.s - KawaiIce Cream - Projeto ISC 2023-2
#
# Descrição: escreve os bytes de um bmp na
# memória do bitmap display para renderização.
#
# Input:	a0: id do sprite
#		a1: frame (0, 1)
#		a3: distância x do pivot
#		a4: distância y do pivot
##################################################
#
#		t0: endereço bitmap display
#		t1: altura
#		t2: largura
#		t3: contadorY
#		t4: contadorX
#		t5: valores dos 4 pixels


.data

.include "sprites/bala.data"
.include "sprites/pirulito.data"
.include "sprites/pudim.data"
.include "sprites/bolo.data"
.include "sprites/cupcake.data"
.include "sprites/player.data"


.text

GET_SPRITE:
	# t0 de suporte para descobrir que sprite renderizar na celula em questão
	# se a0 é 0, é uma célula vazia
	beq	a0, zero, END_RENDER
	
	# a0 vale 1, então é um bloco inquebrável
	li	t0, 1
	beq	a0, t0, END_RENDER

	# bloco quebrável
	li	t0, 2
	beq	a0, t0, sprite01
	
	# coletável
	li	t0, 3
	beq	a0, t0, sprite02
	
	# bloco com objeto coletável
	li	t0, 4
	beq	a0, t0, sprite03
	
	# inimigo 1
	li	t0, 5
	beq	a0, t0, sprite04
	
	# inimigo 2
	li	t0, 6
	beq	a0, t0, sprite05
	
	# jogador
	li	t0, 9
	beq	a0, t0, sprite08
	
	ret						# se o id não for reconhecido, não renderiza nada
	
sprite01:
	la	a0, pudim
	j	RENDER

sprite02:
	la	a0, pirulito
	j	RENDER

sprite03:
	la	a0, bala
	j	RENDER

sprite04:
	la	a0, bala
	j	RENDER

sprite05:
	la	a0, bala
	j	RENDER

sprite08:
	la	a0, player
	j	RENDER

RENDER:

	# endereço do bitmap display
	li	t0, 0xFF0
	add	t0, t0, a1
	slli	t0, t0, 20
	
	# calcula o offset x e y
	li	t6, 320
	mul	t6, t6, a4
	add	t6, t6, a3
	add	t0, t0, t6
	
	lw	t2, 0(a0) 			# largura
	lw	t1, 4(a0)			# altura
	
	addi	a0, a0, 8			# pula largura e altura

	# início da renderização
	li	t3, 0				# inicia a linha
	
start_line:
	bge	t3, t1, END_RENDER		# se o contadorY chegar na última linha, termina a renderização
	addi	t3, t3, 1
	
	li	t4, 0				# reseta o contadorX
	
render_pixels:
	lw	t5, 0(a0)
	sw	t5, 0(t0)			# colore
	
	addi	t4, t4, 4			# acança no contadorX
	addi	a0, a0, 4			# avança no arquivo
	addi	t0, t0, 4			# avança no display

	bge	t4, t2, next_line		# se o contadorX chegar no último pixel, vai pra próxima linha

	j	render_pixels
	
next_line:
	addi	t0, t0, 320
	sub	t0, t0, t2
		
	j	start_line

END_RENDER:
	ret
