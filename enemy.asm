########################################################
# enemy1 - KawaiIce Cream - Projeto ISC 2023-2
# 
# Descrição: algoritmo do comportamento dos primeiros
# inimigos do jogo (oso), presentes na primeira fase
########################################################
#	s0: contador de inimigos
#	s1: posX antiga
#	s2: posY antiga
#	s3: posX nova
#	s4: posY nova
########################################################


.data

enemysPos: 	.byte 0, 0, 0, 0, 0, 0, 0, 0
enemysDirections:.byte 2, 2, 2, 2

enemyCycleTimer:.word 0


.text

ENEMY:
	la	t0, returnAddress0
	sw	ra, 0(t0)

	li	s0, 0				# s0: contador de inimigos

	la	t0, currentTime
	lw	t0, 0(t0)

	srli	t0, t0, 1

	la	t1, enemyCycleTimer
	lw	t2, 0(t1)

	sub	t2, t0, t2
	li	t3, 100
	blt	t2, t3, enemy_return		# se o inimigo já tiver andando nos últimos 500 ms, volta para o código da fase


	sw	t0, 0(t1)			# salva o tempo da última atualização dos inimigos

enemy_loop:
	li	t0, 4
	bge	s0, t0, enemy_return		# se o contador de inimigos chegar a quatro, sai do loop

	la	t0, enemysPos
	li	t1, 2
	mul	t1, s0, t1
	add	t0, t0, t1			# calcula que inimigo selecionar no loop

	lb	s1, 0(t0)			# s1: posX do inimigo #t3
	lb	s2, 1(t0)			# s2: posY do inimigo #t3

	mv	a0, s1
	mv	a1, s2
	la	a2, matrix
	jal	get_cell_address

	sb	zero, 0(a0)			# limpa o espaço que o inimigo está ocupando na matriz


	# Movimentação

	la	t0, sceneId
	lb	t0, 0(t0)
	li	t1, 1
	beq	t0, t1, enemy_move		# se estiver no nível 1, não roda o código de teletransporte


	# Teletransporte
	li	a7, 42
	li	a0, 0
	li	a1, 99
	ecall

	beq	a0, zero, enemy_move		# 1% de chance do inimigo teletransportar

	j	enemy_move

	li	a7, 42
	li	a0, 6
	li	a1, 19
	ecall
	mv	s3, a0				# s3: inteiro pseudo-aleatório no intervalo [6, 19]
	
	li	a7, 42
	li	a0, 2
	li	a1, 14
	ecall
	mv	s4, a0				# s4: inteiro pseudo-aleatório no intervalo [2, 14]

	mv	a0, s3
	mv	a1, s4
	la	a2, matrix
	jal	get_cell_address

	lb	t0, 0(a0)
	beq	t0, zero, set_enemy_pos

	j	enemy_move


# Movimentação padrão
enemy_move:
	# t2: contador de tentativas de movimento
	li	t2, 0

	mv	s3, s1
	mv	s4, s2

	la	t0, enemysDirections

	add	t0, t0, s0
	lb	t0, 0(t0)			# t0: direção para a qual o inimigo está voltado


	beq	t0, zero, enemy_move_up		# 0: cima

	li	t1, 1
	beq	t0, t1, enemy_move_left		# 1: esquerda

	li	t1, 2
	beq	t0, t1, enemy_move_down		# 2: baixo

	li	t1, 3
	beq	t0, t1, enemy_move_right	# 3: direita


enemy_move_up:
	jal	check_move_attempts

	mv	s3, s1
	mv	s4, s2
	addi	s4, s4, -1

	mv	a0, s3
	mv	a1, s4
	la	a2, matrix
	jal	get_cell_address
	lb	t0, 0(a0)


	la	t1, enemysDirections
	add	t1, t1, s0
	li	t2, 0
	sb	t2, 0(t1)			# atualiza a direção (0)


	beq	t0, zero, set_enemy_pos

	addi	t2, t2, 1
	j	enemy_move_right

enemy_move_down:
	jal	check_move_attempts

	mv	s3, s1
	mv	s4, s2
	addi	s4, s4, 1

	mv	a0, s3
	mv	a1, s4
	la	a2, matrix
	jal	get_cell_address
	lb	t0, 0(a0)


	la	t1, enemysDirections
	add	t1, t1, s0
	li	t2, 2
	sb	t2, 0(t1)			# atualiza a direção (2)


	beq	t0, zero, set_enemy_pos

	addi	t2, t2, 1
	j	enemy_move_left

enemy_move_left:
	jal	check_move_attempts

	mv	s3, s1
	addi	s3, s3, -1
	mv	s4, s2

	mv	a0, s3
	mv	a1, s4
	la	a2, matrix
	jal	get_cell_address
	lb	t0, 0(a0)


	la	t1, enemysDirections
	add	t1, t1, s0
	li	t2, 1
	sb	t2, 0(t1)			# atualiza a direção (1)


	beq	t0, zero, set_enemy_pos

	addi	t2, t2, 1
	j	enemy_move_up

enemy_move_right:
	jal	check_move_attempts

	mv	s3, s1
	addi	s3, s3, 1
	mv	s4, s2

	mv	a0, s3
	mv	a1, s4
	la	a2, matrix
	jal	get_cell_address
	lb	t0, 0(a0)


	la	t1, enemysDirections
	add	t1, t1, s0
	li	t2, 3
	sb	t2, 0(t1)			# atualiza a direção (3)


	beq	t0, zero, set_enemy_pos

	addi	t2, t2, 1
	j	enemy_move_down


check_move_attempts:
	li	t3, 4
	bge	t2, t3, enemy_give_up

	ret

enemy_give_up:
	mv	s3, s1
	mv	s4, s2

	j	set_enemy_pos


set_enemy_pos:
	mv	a0, s3
	mv	a1, s4
	la	a2, matrix
	jal	get_cell_address		# calcula o endereço a partir de s3 e s4

	li	t0, 5
	sb	t0, 0(a0)			# posiciona o inimigo na nova célula

	addi	s0, s0, 1

	la	t0, enemysPos
	li	t1, 2
	mul	t1, s0, t1
	add	t0, t0, t1

	sb	s3, 0(t0)
	sb	s4, 1(t0)

	j	enemy_loop


enemy_return:
	la	t0, returnAddress0
	lw	ra, 0(t0)
	ret
