##################################################
# player.s - KawaiIce Cream - Projeto ISC 2023-2
#
# Descrição: script responsável pela movimentação
# e ações do jogador.
##################################################
#		s0: tecla pressionada
#		s1: posX
#		s2: posY
##################################################


.data

w: .byte 119
a: .byte 97
s: .byte 115
d: .byte 100


.text

PLAYER_MOVEMENT:
	la	t0, returnAddress
	sw	ra, 0(t0)			# salva o valor do ra pra depois

	la	t0, playerPos
	lw	s1, 0(t0)			# s1: posX
	lw	s2, 4(t0)			# s2: posY

	la	s0, key				# s0: tecla pressionada
	
	# checagem de teclas
	la	t3, w
	beq	s0, t3, up
		
	la	t3, a
	beq	t0, t3, left
	
	la	t3, s
	beq	t0, t3, down
	
	la	t3, d
	beq	t0, t3, right
	
	# tecla de ataque
	# tecla de pular fase
	
	ret
	
left:
	# checar posição
	addi	s1, -1
	
	mv	a0, s1
	mv	a1, s2
	
	jal	checkCell
	jal	cellSwitch
	
	j	updateMatrix
	
right:
	addi	s1, 1
	
	mv	a0, s1
	mv	a1, s2
	
	jal	checkCell
	jal	cellSwitch
	
	j	updateMatrix
	
up:
	addi	s2, -1
	
	mv	a0, s1
	mv	a1, s2
		
	jal	checkCell
	jal	cellSwitch
	
	j	updateMatrix
	
down:
	addi	s2, 1
	
	mv	a0, s1
	mv	a1, s2
	
	jal	checkCell
	jal	cellSwitch
	
	j	updateMatrix
	
	
cellSwitch:
	beq	a0, zero, return
	
	li	t0, 2
	ble	a0, t0, finishMovement

	li	t0, 4
	ble	a0, t0, finishMovement
	
	#li	t0, 3
	#beq	a0, t0, eat
	
	#li	t0, 5
	#beq	a0, t0, die
	
	
	j	finishMovement
	
eat:
	
	
	
die:
	
	
	
updateMatrix:
	
	
	ret

finishMovement:
	la	t0, returnAddress
	lw	ra, 0(t0)
	
	ret	
	
	