########################################################
# scenes - KawaiIce Cream - Projeto ISC 2023-2
# 
# Descrição: código com os algoritmos usados em todas as
# cenas do jogo.
########################################################


.data

key1:		.byte 49
key2:		.byte 50
key3:		.byte 51

candyTotal:	.byte 16, 14, 20
candyCount:	.byte 0, 0			# a quantidade de doces pra coletar em cada mapa
candyType:	.byte 0
points:		.word 0				# pontuação total

musicTimer:	.word 0				# tempo em ms de quando iniciou da última nota
musicCounter:	.word -1				# contador das notas da música

matrix_candy:	.word 0


.text


# [ Cenas ]

# [[ MENU ]]
MENU:
	la	t2, musicCounter
	lw	t1, 0(t2)

	la	t3, song_size
	lw	t3, 0(t3)

	bge	t1, t3, reset_song

play_music:
	li	a7, 30
	ecall
	la	t0, currentTime
	sw	a0, 0(t0)			# salva o instante atual em milissegundos

	mv	t0, a0

	la	t3, musicTimer
	lw	t4, 0(t3)

	srli	a0, a0, 1			# o tempo tá saindo negativo, então...
	srli	t4, t4, 1

	sub	t4, a0, t4			# t4: dif de tempo


	addi	t1, t1, 1

	la	t5, song_duration
	li	t6, 4
	mul	t6, t6, t1
	add	t5, t5, t6
	lw	t5, 0(t5)			# t5: duração da nota atual (endereço de song_duration + t1 * 4)

	bltu	t4, t5, skip_play_music		# se a dif de tempo for menor que a duração da nota, ingnora a nota

	la	t4, song_notes
	add	t4, t4, t1
	lb	a0, 0(t4)

	mv	a1, t5				#duração 
	li	a2, 10				#intrumento
	li	a3, 65				#volume

	jal	play_note

	sw	t0, 0(t3)			# atualiza o musicTimer
	sw	t1, 0(t2)			# salva o musicCounter

skip_play_music:
	la	t0, key
	lb	t0, 0(t0)

	la	t1, key1
	lb	t1, 0(t1)
	beq	t0, t1, select_level_1

	la	t1, key2
	lb	t1, 0(t1)
	beq	t0, t1, select_level_2

	la	t1, key3
	lb	t1, 0(t1)
	beq	t0, t1, EXIT

	j	END_MAIN


reset_song:
	# t2: endereço do musicCounter
	sb	zero, 0(t2)

	j	play_music

GAME_OVER:
	la	t0, key
	lb	t0, 0(t0)

	la	t1, key1
	lb	t1, 0(t1)
	beq	t0, t1, menu_setup

	la	t1, key2
	lb	t1, 0(t1)
	beq	t0, t1, EXIT


	j	END_MAIN


THE_END:
	la	t0, key
	lb	t0, 0(t0)

	la	t1, key1
	lb	t1, 0(t1)
	beq	t0, t1, menu_setup

	la	t1, key2
	lb	t1, 0(t1)
	beq	t0, t1, EXIT


	j	END_MAIN

# [[ Nível 1 ]]
LEVEL_1:
	# timer do nível
	li	a7, 30
	ecall
	la	t0, currentTime			# salva o intante atual em milissegundos
	sw	a0, 0(t0)

	la	t0, cycleTimer
	lw	t1, 0(t0)

	sub	a0, a0, t1			# calcula a diferença de tempo de um tick em milissegundos

	li	t2, 1000
	blt	a0, t2, skip_timer_1		# se a diferença menos de 1 seg, não atualiza o timer

	la	t0, timer
	lw	t1, 0(t0)
	addi	t1, t1, -1
	sw	t1, 0(t0)			# subtrái o tempo por 1 e atualiza o valor

	li	a7, 30
	ecall
	la	t0, cycleTimer
	sw	a0, 0(t0)

skip_timer_1:
	jal	PLAYER				# player.asm

	jal	ENEMY

	la	t0, frame
	lb	t0, 0(t0)
	mv	a1, t0

	la	s0, matrix_candy
	lw	s0, 0(s0)
	jal	render_candy


	jal	RENDER_MATRIX

	j	END_MAIN


# [[ Nível 2 ]]
LEVEL_2:
	# timer do nível
	li	a7, 30
	ecall
	la	t0, currentTime			# salva o intante atual em milissegundos
	sw	a0, 0(t0)


	la	t0, cycleTimer
	lw	t1, 0(t0)

	sub	a0, a0, t1			# calcula a diferença de tempo de um tick em milissegundos

	li	t2, 1000
	blt	a0, t2, skip_timer_2		# se a diferença menos de 1 seg, não atualiza o timer

	la	t0, timer
	lw	t1, 0(t0)


	addi	t1, t1, -1
	sw	t1, 0(t0)			# subtrái o tempo por 1 e atualiza o valor

	li	a7, 30
	ecall
	la	t0, cycleTimer
	sw	a0, 0(t0)

skip_timer_2:
	jal	PLAYER				# player.asm

	jal	ENEMY

	la	t0, frame
	lb	t0, 0(t0)
	mv	a1, t0

	la	s0, matrix_candy
	lw	s0, 0(s0)
	jal	render_candy


	jal	RENDER_MATRIX

	j	END_MAIN




RENDER_MATRIX:
	# s0: endereço na matriz
	# s1: altura
	# s2: largura
	# s3: contadorY
	# s4: contadorX

	# s0: endereço da matriz
	la	t0, matrix
	lw	s0, 0(t0)			# s0: endereço inicial da matriz


render_candy:
	la	t0, returnAddress0
	sw	ra, 0(t0)

	# s2: largura, s1: altura
	lw	s2, 0(s0)
	lw	s1, 4(s0)

	addi	s0, s0, 8			# pula largura e altura e avança para a matriz

	# s3: contador Y
	li	s3, 0

line_loop:
	addi	s3, s3, 1
	bge	s3, s1, end_matrix_render	# se o contadorY for maior ou igual à altura, termina a renderização

	# s4: contadorX
	li	s4, 0

cell_loop:
	li	s5, 16				# tamanho de cada célula

	mul	a3, s4, s5			# calcula a distância X da sprite (contadorX x 16)

	addi	s3, s3, -1
	mul	a4, s3, s5			# calcula a distância Y (contadorY x 16)

	lb	a0, 0(s0)			# valor do id na célula

	jal	GET_SPRITE			# executa o algoritmo de renderização (render.asm)
	addi	s3, s3, 1


	addi	s4, s4, 1			# soma 1 ao contadorX
	addi	s0, s0, 1			# soma 1 ao enredeço da matriz

	bge	s4, s2, line_loop		# se o contadorX for igual ou maior à largura, inicia a próxima linha

	j	cell_loop			# senão, continua percorrendo a linha da matriz

end_matrix_render:
	la	t0, returnAddress0
	lw	ra, 0(t0)
	ret					# volta pro loop de jogo


.include "player.asm"
.include "enemy.asm"
.include "audioInterface.asm"
