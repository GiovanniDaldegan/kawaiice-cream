########################################################
# player.s - KawaiIce Cream - Projeto ISC 2023-2
#
# Descrição: script responsável pela movimentação e
# ações do jogador.
########################################################
#		Movimentação:
#		s0: tecla pressionada
#		s1: posX antiga
#		s2: posY antiga
#		s3: posX nova
#		s4: posY nova
#		
#		Ataque:
#		s0: tecla pressionada
#		s1: posX dos blocos na fileira do ataque
#		s2: posY dos blocos na fileira do ataque
#		s3: valor para adicionar à posX para obter a célula à frente
#		s4: valor para adicionar à posY para obter a célula à frente
#		s5: binário indicando se cria (1) ou quebra (0) blocos
########################################################


.data

playerPos:	.byte 0, 0			# posição (x, y) do personagem na matriz
playerDirection:.byte 2				# 0: up, 1: left, 2: down, 3: right
playerState:	.byte 0				# 0: idle, 1: atacando

wKey:		.byte 119
aKey:		.byte 97
sKey:		.byte 115
dKey:		.byte 100
spaceKey:	.byte 32

candyValue:	.byte 100

.text

PLAYER:
	la	t0, returnAddress0
	sw	ra, 0(t0)			# salva o valor do ra pra depois voltar pro main.asm

	la	t0, playerState
	sb	zero, 0(t0)			# reseta o estado do jogador

	la	t0, playerPos
	lb	s1, 0(t0)			# s1: posX
	lb	s2, 1(t0)			# s2: posY

	mv	s3, s1
	mv	s4, s2

	la	t0, key				# s0: tecla pressionada
	lb	s0, 0(t0)


	# checagem de teclas
	
	## Movimentação
	la	t0, wKey
	lb	t0, 0(t0)
	beq	s0, t0, up

	la	t0, aKey
	lb	t0, 0(t0)
	beq	s0, t0, left

	la	t0, sKey
	lb	t0, 0(t0)
	beq	s0, t0, down

	la	t0, dKey
	lb	t0, 0(t0)
	beq	s0, t0, right

	## Ataque
	la	t0, spaceKey
	lb	t0, 0(t0)
	beq	s0, t0, attack

	ret


# [ Movimentação ]
up:
	addi	s4, s4, -1

	la	t0, playerDirection
	li	t1, 0
	sb	t1, 0(t0)

	j	check_move

left:
	addi	s3, s3, -1

	la	t0, playerDirection
	li	t1, 1
	sb	t1, 0(t0)

	j	check_move

down:
	addi	s4, s4, 1

	la	t0, playerDirection
	li	t1, 2
	sb	t1, 0(t0)

	j	check_move

right:
	addi	s3, s3, 1

	la	t0, playerDirection
	li	t1, 3
	sb	t1, 0(t0)

	j	check_move


# [ Ações ]
attack:

	la	t0, playerState
	li	t1, 1
	sb	t1, 0(t0)			# define o estado do jogador como "atacando"

	la	t0, playerDirection
	lb	t0, 0(t0)			# define a direção para qual o player está virado

	beq	t0, zero, attack_up

	li	t1, 1
	beq	t0, t1, attack_left

	li	t1, 2
	beq	t0, t1, attack_down

	li	t1, 3
	beq	t0, t1, attack_right

	attack_up:
	li	s3, 0
	li	s4, -1

	j	attack_first_block

	attack_left:
	li	s3, -1
	li	s4, 0

	j	attack_first_block

	attack_down:
	li	s3, 0
	li	s4, 1

	j	attack_first_block

	attack_right:
	li	s3, 1
	li	s4, 0

	j	attack_first_block

attack_first_block:
	mv	a0, s1
	mv	a1, s2

	add	a0, a0, s3
	add	a1, a1, s4

	jal	get_cell_address

	lb	t0, 0(a0)
	
	beq	t0, zero, attack_create_sfx	# se o id da célula for 0, ele vai criar blocos

	li	t1, 3
	beq	t0, t1, attack_create_sfx	# se o id da célula for 3, ele vai criar blocos

	li	t1, 2
	beq	t0, t1, attack_destroy_sfx	# se o id da célula for 2, ele vai quebrar blocos

	li	t1, 4
	beq	t0, t1, attack_destroy_sfx	# se o id da célula for 4, ele vai quebrar blocos


	j	FINISH_PLAYER			# se nenhum desses for o caso, retorna ao algoritmo do nível

attack_create_sfx:
	jal	sfx_create_block

attack_create_loop:
	add	s1, s1, s3
	add	s2, s2, s4

	mv	a0, s1
	mv	a1, s2

	jal	get_cell_address
	lb	t0, 0(a0)

	beq	t0, zero, create_block

	li	t1, 3
	beq	t0, t1, create_block_collectible

	j	FINISH_PLAYER

	create_block:
	li	t0, 2
	sb	t0, 0(a0)

	j	attack_create_loop

	create_block_collectible:
	li	t0, 4
	sb	t0, 0(a0)

	j	attack_create_loop


attack_destroy_sfx:
	jal	sfx_break_block

attack_destroy_loop:
	add	s1, s1, s3
	add	s2, s2, s4

	mv	a0, s1
	mv	a1, s2

	jal	get_cell_address
	lb	t0, 0(a0)

	li	t1, 2
	beq	t0, t1, destroy_block

	li	t1, 4
	beq	t0, t1, destroy_block_collectible

	j	FINISH_PLAYER

	destroy_block:
	li	t0, 0
	sb	t0, 0(a0)

	j	attack_destroy_loop

	destroy_block_collectible:
	li	t0, 3
	sb	t0, 0(a0)

	j	attack_destroy_loop


eat:
	jal	sfx_collectible

	# incrementar o contador de doces
	la	t0, sceneId
	lb	t0, 0(t0)
	addi	t0, t0, -1

	la	t1, candyCount
	add	t1, t1, t0
	lb	t2, 0(t1)

	addi	t2, t2, 1

	sb	t2, 0(t1)


	# incrementa a pontuação total
	li	t3, 100				# pontuação por doce comido

	la	t0, points
	lw	t1, 0(t0)
	add	t1, t1, t3
	sw	t1, 0(t0)

	mv	a0, s3
	mv	a1, s4
	la	a2, matrix_candy
	lw	a2, 0(a2)
	jal	get_cell_address_candy
	sb	zero, 0(a0)


	j	update_player

die:
	jal	sfx_player_death

	la	a0, 4
	j	select_scene


check_move:
	mv	a0, s3
	mv	a1, s4

	jal	get_cell_address
	lb	a0, 0(a0)

	j	cell_switch

update_player:
	mv	a0, s3
	mv	a1, s4

	jal	get_cell_address

	# coloca o jogador na nova posição na matriz
	li	t0, 9
	sb	t0, 0(a0)


	# retira o jogador da antiga posição na matriz
	mv	a0, s1
	mv	a1, s2
	jal	get_cell_address

	sb	zero, 0(a0)

	la	t0, playerPos
	sb	s3, 0(t0)
	sb	s4, 1(t0)

	j	FINISH_PLAYER


cell_switch:
	# decide o que fazer com base no id da célula de destino (a0)
	beq	a0, zero, check_candy

	li	t0, 4
	ble	a0, t0, FINISH_PLAYER		# se não for 3 e for menor ou igual a 4, não movimenta

	li	t0, 5
	beq	a0, t0, die		# morre

	check_candy:
	mv	a0, s3
	mv	a1, s4

	la	a2, matrix_candy
	lw	a2, 0(a2)
	jal	get_cell_address_candy

	lb	t0, 0(a0)
	li	t1, 3
	beq	t0, t1, eat

	j	update_player

	ret


FINISH_PLAYER:
	la	t0, returnAddress0
	lw	ra, 0(t0)

	ret	
