########################################################
# sceneManager - KawaiIce Cream - Projeto ISC 2023-2
# 
# Descrição: realiza o setup do menu e das fases do
# jogo.
########################################################
#	t0: endereço da label sceneId
#	t1: id da cena
#	t2: tecla pressionada
#	t3: 
########################################################


.data

.include "maps/fase1.data"
.include "maps/fase2.data"

.include "sprites/fundomenu.data"
.include "sprites/fundomapa1.data"
.include "sprites/fundomapa2.data"

.include "sprites/capabmp.data"
.include "sprites/gameoverbmp.data"
.include "sprites/telafinal.data"
#.include "sprites/"

#Pausebmp.data

escKey:		.byte 27
nKey:		.byte 110
1Key:		.byte 49
2Key:		.byte 50
3Key:		.byte 51

enemysPos1: 	.byte 7, 2, 19, 3, 6, 13, 18, 14
enemysPos2: 	.byte 12, 2, 19, 3, 6, 13, 18, 14



.text

SCENE_SETUP:
	la	t0, sceneId
	lb	t1, 0(t0)			# id da cena atual

	la	t2, key
	lb	t2, 0(t2)			# t2: tecla pressionada

	la	t3, nKey
	lb	t3, 0(t3)
	beq	t2, t3, next_scene		# se a tecla for "ESC", o jogo vai pra próxima cena

	j	scene_switch


select_level_1:
	li	a0, 1
	j	select_scene

select_level_2:
	li	a0, 2
	j	select_scene

select_level_3:
	li	a0, 3
	j	select_scene

next_scene:
	li	a0, 1
	j	select_scene


select_scene:
	# Argumento:	a0 - número de cenas que o programa irá pular
	la	t0, playerDirection
	li	t1, 2
	sb	t1, 0(t0)

	la	t0, sceneId
	lb	t1, 0(t0)			# t1: id da cena atual

	add	t1, t1, a0
	sb	t1, 0(t0)			# atualiza o sceneId


	# switch para decidir que cena iniciar
	beq	t1, zero, menu_setup

	li	t2, 1
	beq	t1, t2, level_1_setup

	li	t2, 2
	beq	t1, t2, level_2_setup

	li	t2, 3
	beq	t1, t2, the_end_setup

	li	t2, 4
	beq	t1, t2, game_over_setup

	li	t2, 5
	bge	t1, t2, menu_setup

	j	END_MAIN


scene_switch:
	# switch para decidir que cena executar
	beq	t0, zero, MENU

	li	t2, 1
	beq	t1, t2, LEVEL_1

	li	t2, 2
	beq	t1, t2, LEVEL_2

	li	t2, 3
	beq	t1, t2, THE_END			# cena final

	li	t2, 4
	beq	t1, t2, GAME_OVER		# cena de game over

	li	t2, 5
	bge	t1, t2, reset

	j	END_MAIN


menu_setup:
	la	t0, background
	la	t1, capabmp
	sw	t1, 0(t0)

	j	MENU

game_over_setup:
	la	t0, background
	la	t1, gameoverbmp
	sw	t1, 0(t0)

	j	GAME_OVER

the_end_setup:
	la	t0, background
	la	t1, telafinal
	sw	t1, 0(t0)

	j	GAME_OVER

level_1_setup:
	la	t0, timer
	li	t1, 180
	sw	t1, 0(t0)			# define o tempo da fase

	la	a7, 30
	ecall
	la	t0, cycleTimer
	sw	a0, 0(t0)			# define o tempo do primeiro instante da fase


	la	t0, fase1
	la	t1, fase1Copy

	lw	t2, 0(t0)			# t2: largura
	lw	t3, 4(t0)			# t3: altura

	addi	t0, t0, 8			# pula largura e altura
	addi	t1, t1, 8

	li	t4, 0				# t4: contador Y
	li	t3, 17				# NOTE: isso não era pra ser necessário. por algum motivo o loop para na linha 11 ???
line_loop_1:
	beq	t4, t3, finish_loop_1
	addi	t4, t4, 1

	li	t5, 0				# t5: contador X
cell_loop_1:
	lb	t6, 0(t0)
	sb	t6, 0(t1)

	addi	t0, t0, 1			# soma 1 no endereço original da matriz
	addi	t1, t1, 1			# soma 1 na cópia
	addi	t5, t5, 1			# soma 1 no contador

	bge	t5, t3, line_loop_1

	j	cell_loop_1

finish_loop_1:
	la	t0, fase1Copy
	la	t1, matrix
	sw	t0, 0(t1)			# define a matriz da fase 1

	la	t0, background
	la	t1, fundomapa1
	sw	t1, 0(t0)			# define o fundo da fase 1

	# setup jogador
	la	t0, playerPos
	li	t1, 12
	li	t2, 13

	sb	t1, 0(t0)
	sb	t2, 1(t0)

	# setup inimigos
# 	la	t0, enemysPos1
# 	la	t1, enemysPos
# 	la	t2, enemysDirections

# 	li	t3, 0				# t5: contador de inimigos
# setup_enemys_loop_1:
# 	li	t4, 4
# 	bge	t3, t4, finish_enemys_setup_1

# 	lb	t4, 0(t0)
# 	sb	t4, 0(t1)			# copia as posições em enemysPos1 para enemysPos (t3)

# 	lb	t4, 1(t0)
# 	sb	t4, 1(t1)			# copia as posições em enemysPos1 para enemysPos (t3 + 1)

# 	li	t4, 2
# 	sb	t4, 0(t2)

# 	addi	t0, t0, 2
# 	addi	t1, t1, 2
# 	addi	t2, t2, 1

# 	addi	t3, t3, 1

# 	j	setup_enemys_loop_1

# finish_enemys_setup_1:


	j	END_MAIN


level_2_setup:
	la	t0, timer
	li	t1, 180
	sw	t1, 0(t0)			# define o tempo da fase

	la	a7, 30
	ecall
	la	t0, cycleTimer
	sw	a0, 0(t0)			# define o tempo do primeiro instante da fase


	la	t0, fase2
	la	t1, fase2Copy

	lw	t2, 0(t0)			# t2: largura
	lw	t3, 4(t0)			# t3: altura

	addi	t0, t0, 8			# pula largura e altura
	addi	t1, t1, 8

	li	t4, 0				# t4: contador Y
	li	t3, 17				# NOTE: isso não era pra ser necessário. por algum motivo o loop para na linha 11 ???
line_loop_2:
	beq	t4, t3, finish_loop_2
	addi	t4, t4, 1

	li	t5, 0				# t5: contador X
cell_loop_2:
	lb	t6, 0(t0)
	sb	t6, 0(t1)

	addi	t0, t0, 1			# soma 1 no endereço original da matriz
	addi	t1, t1, 1			# soma 1 na cópia
	addi	t5, t5, 1			# soma 1 no contador

	bge	t5, t3, line_loop_2

	j	cell_loop_2

finish_loop_2:
	la	t0, fase2Copy
	la	t1, matrix
	sw	t0, 0(t1)			# define o fundo da fase 1

	la	t0, background
	la	t1, fundomapa2
	sw	t1, 0(t0)			# define o fundo da fase 1

	# setup jogador
	la	t0, playerPos
	li	t1, 15
	li	t2, 4

	sb	t1, 0(t0)			# define a posX
	sb	t2, 1(t0)			# define a posY


	# setup inimigos
# 	la	t0, enemysPos2
# 	la	t1, enemysPos
# 	la	t2, enemysDirections

# 	li	t3, 0				# t5: contador de inimigos
# setup_enemys_loop_2:
# 	li	t4, 4
# 	bge	t3, t4, finish_enemys_setup_2

# 	lb	t4, 0(t0)
# 	sb	t4, 0(t1)			# copia as posições em enemysPos1 para enemysPos (t3)

# 	lb	t4, 1(t0)
# 	sb	t4, 1(t1)			# copia as posições em enemysPos1 para enemysPos (t3 + 1)

# 	li	t4, 2
# 	sb	t4, 0(t2)

# 	addi	t0, t0, 2
# 	addi	t1, t1, 2
# 	addi	t2, t2, 1

# 	addi	t3, t3, 1

# 	j	setup_enemys_loop_2

# finish_enemys_setup_2:

	j	END_MAIN


reset:
	# reseta os contadores de doce
	la	t0, candyCount
	sb	zero, 0(t0)

	addi	t0, t0, 1
	sb	zero, 0(t0)

	addi	t0, t0, 1
	sb	zero, 0(t0)

	# reseta o sceneId
	la	t0, sceneId
	sb	zero, 0(t0)

	# reseta a pontuação total
	la	t0, points
	sw	zero, 0(t0)

	j	menu_setup
