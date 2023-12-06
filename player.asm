##################################################
# player.s - KawaiIce Cream - Projeto ISC 2023-2
#
# Descrição: script responsável pela movimentação
# e ações do jogador.
##################################################
#		s0: id da sprite
#		s1: posX antiga
#		s2: posY antiga
#		s3: posX nova
#		s4: posY nova
##################################################


.data

w: .byte 119
a: .byte 97
s: .byte 115
d: .byte 100


.text

PLAYER:
	la	t0, returnAddress
	sw	ra, 0(t0)			# salva o valor do ra pra depois voltar pro main.asm

	la	t0, playerPos
	lb	s1, 0(t0)			# s1: posX
	lb	s2, 1(t0)			# s2: posY

	mv	s3, s1
	mv	s4, s2

	la	t0, key				# s0: tecla pressionada
	lb	s0, 0(t0)


	# checagem de teclas
	la	t1, w
	lb	t1, 0(t1)
	beq	s0, t1, up

	la	t1, a
	lb	t1, 0(t1)
	beq	s0, t1, left

	la	t1, s
	lb	t1, 0(t1)
	beq	s0, t1, down

	la	t1, d
	lb	t1, 0(t1)
	beq	s0, t1, right

	# tecla de ataque
	# pause
	# pular fase

	ret

# Movimentação
left:
	addi	s3, s3, -1
	# animation

	j	checkMove

right:
	addi	s3, s3, 1
	# animation

	j	checkMove

up:
	addi	s4, s4, -1
	# animation

	j	checkMove

down:
	addi	s4, s4, 1
	# animation

	j	checkMove

# Ações
eat:

	#j	updatePlayer

die:

	#j	finishMovement


checkMove:
	mv	a0, s3
	mv	a1, s4

	jal	getCellAddress
	lb	a0, 0(a0)

	j	cellSwitch

updatePlayer:
	mv	a0, s3
	mv	a1, s4

	jal	getCellAddress

	# coloca o jogador na nova posição na matriz
	li	t0, 9
	sb	t0, 0(a0)


	# retira o jogador da antiga posição na matriz
	mv	a0, s1
	mv	a1, s2
	jal	getCellAddress

	sb	zero, 0(a0)

	la	t0, playerPos
	sb	s3, 0(t0)
	sb	s4, 1(t0)

	j	finishMovement


cellSwitch:
	# decide o que fazer com base no id da célula de destino (a0)
	beq	a0, zero, updatePlayer

	li	t0, 3	
	beq	a0, t0, updatePlayer		# come

	li	t0, 4
	ble	a0, t0, finishMovement		# se não for 3 e for menor ou igual a 4, não movimenta

	li	t0, 5
	beq	a0, t0, finishMovement		# morre

	ret


finishMovement:
	la	t0, returnAddress
	lw	ra, 0(t0)

	ret	
