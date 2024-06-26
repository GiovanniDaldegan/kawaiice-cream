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
#.include "sprites/Pausebmp.data"


escKey:		.byte 27
nKey:		.byte 110

enemysPos1: 	.byte 6, 1, 18, 2, 5, 12, 17, 13
enemysPos2: 	.byte 11, 1, 18, 6, 5, 7, 12, 13

levelPlayerPos:	.byte 11, 12, 14, 3


.text

SCENE_SETUP:
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


level_complete:
	la	t0, candyType
	sb	zero, 0(t0)

	jal	sfx_level_complete

next_scene:
	la	t0, sceneId
	lb	t1, 0(t0)

	addi	t1, t1, 1

	mv	a0, t1
	j	select_scene


select_scene:
	# a0 - id da cena
	la	t0, musicCounter
	sw	zero, 0(t0)

	la	t0, playerDirection
	li	t1, 2
	sb	t1, 0(t0)

	la	t0, sceneId
	lb	t1, 0(t0)			# t1: id da cena atual

	sb	a0, 0(t0)			# atualiza o sceneId


	# switch para decidir que cena iniciar
	beq	a0, zero, menu_setup

	li	t2, 1
	beq	a0, t2, level_1_setup

	li	t2, 2
	beq	a0, t2, level_2_setup

	li	t2, 3
	beq	a0, t2, the_end_setup

	li	t2, 4
	beq	a0, t2, game_over_setup

	li	t2, 5
	bge	a0, t2, menu_setup

	j	END_MAIN


scene_switch:
	la	t0, sceneId
	lb	t0, 0(t0)			# t0: id da cena atual

	# switch para decidir que cena executar
	beq	t0, zero, MENU

	li	t1, 1
	beq	t0, t1, LEVEL_1

	li	t1, 2
	beq	t0, t1, LEVEL_2

	li	t1, 3
	beq	t0, t1, THE_END			# cena final

	li	t1, 4
	beq	t0, t1, GAME_OVER		# cena de game over

	li	t1, 5
	bge	t0, t1, reset

	j	END_MAIN


menu_setup:
	la	t0, key
	sb	zero, 0(t0)


	la	t0, currentTime
	lw	t0, 0(t0)

	la	t1, musicTimer
	sw	t0, 0(t1)

	la	t0, candyType
	sb	zero, 0(t0)


	la	t0, sceneId
	sb	zero, 0(t0)

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

	j	THE_END

level_1_setup:
	la	t0, candyCount
	sb	zero, 0(t0)

	la	t0, levelTimer
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

	# copia a matriz de doces
	la	a0, fase1Doces1Copy
	la	a1, mapCandy
	jal	copy_matrix


	la	t0, mapCandy
	la	t1, matrix_candy
	sw	t0, 0(t1)			# define a matriz de doces

	la	t0, background
	la	t1, fundomapa1
	sw	t1, 0(t0)			# define o fundo da fase 1

	# setup jogador
	la	t0, levelPlayerPos
	lb	t1, 0(t0)
	lb	t2, 1(t0)

	la	t0, playerPos

	sb	t1, 0(t0)
	sb	t2, 1(t0)

	# setup inimigos
 	la	t0, enemysPos1
	la	t1, enemysPos
	la	t2, enemysDirections

	li	t3, 0				# t3: contador de inimigos
setup_enemys_loop_1:
	li	t4, 4
	bge	t3, t4, finish_enemys_setup_1

	lb	t4, 0(t0)
	sb	t4, 0(t1)			# copia as posições em enemysPos1 para enemysPos (t3)

	lb	t4, 1(t0)
	sb	t4, 1(t1)			# copia as posições em enemysPos1 para enemysPos (t3 + 1)

	li	t4, 2
	sb	t4, 0(t2)

	addi	t0, t0, 2
	addi	t1, t1, 2
	addi	t2, t2, 1

	addi	t3, t3, 1

	j	setup_enemys_loop_1

finish_enemys_setup_1:


	j	END_MAIN


level_2_setup:
	la	t0, candyCount
	sb	zero, 1(t0)

	la	t0, levelTimer
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
	sw	t0, 0(t1)			# define a matriz da fase 2

	# copia a matriz de doces
	la	a0, fase2Doces1Copy
	la	a1, mapCandy
	jal	copy_matrix

	la	t0, mapCandy
	la	t1, matrix_candy
	sw	t0, 0(t1)			# define a matriz de doces

	la	t0, background
	la	t1, fundomapa2
	sw	t1, 0(t0)			# define o fundo da fase 2

	# setup jogador
	la	t0, levelPlayerPos
	lb	t1, 2(t0)
	lb	t2, 3(t0)

	la	t0, playerPos
	sb	t1, 0(t0)			# define a posX
	sb	t2, 1(t0)			# define a posY


	# setup inimigos
	la	t0, enemysPos2
	la	t1, enemysPos
	la	t2, enemysDirections

	li	t3, 0				# t3: contador de inimigos
setup_enemys_loop_2:
	li	t4, 4
	bge	t3, t4, finish_enemys_setup_2

	lb	t4, 0(t0)
	sb	t4, 0(t1)			# copia as posições em enemysPos1 para enemysPos (t3)

	lb	t4, 1(t0)
	sb	t4, 1(t1)			# copia as posições em enemysPos1 para enemysPos (t3 + 1)

	li	t4, 2
	sb	t4, 0(t2)

	addi	t0, t0, 2
	addi	t1, t1, 2
	addi	t2, t2, 1

	addi	t3, t3, 1

	j	setup_enemys_loop_2

finish_enemys_setup_2:

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
