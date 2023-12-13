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

.include "sprites/fundomapa1.data"
.include "sprites/fundomenu.data"


escKey:		.byte 27
nKey:		.byte 110
1Key:		.byte 49
2Key:		.byte 50
3Key:		.byte 51


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
	la	t0, sceneId
	lb	t1, 0(t0)			# id da cena atual

	add	t1, t1, a0
	sb	t1, 0(t0)			# atualiza o sceneId


	# switch para decidir que cena iniciar
	beq	t1, zero, menu_setup

	li	t2, 1
	beq	t1, t2, level_1_setup

	#li	t2, 2
	#beq	t1, t2, level_2_setup

	#li	t2, 3
	#beq	t1, t2, level_3_setup

	li	t2, 4
	bge	t1, t2, menu_setup

	j	END_MAIN


scene_switch:
	# switch para decidir que cena executar
	beq	t0, zero, MENU

	li	t2, 1
	beq	t1, t2, LEVEL_1

	#li	t2, 2
	#beq	t1, t2, level_2_loop

	#li	t2, 3
	#beq	t1, t2, level_3_loop

	li	t2, 4
	beq	t1, t2, END_MAIN		# cena final

	li	t2, 5
	beq	t1, t2, END_MAIN		# cena de game over

	li	t2, 5
	bge	t1, t2, reset

	j	END_MAIN


menu_setup:
	la	t0, background
	la	t1, fundomenu
	sw	t1, 0(t0)

	j	MENU


level_1_setup:
	la	t0, background
	la	t1, fundomapa1
	sw	t1, 0(t0)

	la	t0, playerPos
	li	t1, 12
	li	t2, 13

	sb	t1, 0(t0)
	sb	t2, 1(t0)

	j	LEVEL_1
	

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
