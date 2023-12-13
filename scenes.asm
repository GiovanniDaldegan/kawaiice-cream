########################################################
# level1 - KawaiIce Cream - Projeto ISC 2023-2
# 
# Descrição: código com funcionalidades úteis para as
# cenas do jogo.
########################################################


.data

candyTotal:	.byte 16, 20, 20
candyCount:	.byte 0, 0, 0			# a quantidade de doces pra coletar em cada mapa
points:		.word 0				# pontuação total


.text


# [ Cenas ]

# [[ MENU ]]
MENU:
	# TODO: seleção de fase

	j	END_MAIN

# [[ Nível 1 ]]
LEVEL_1:
	jal	PLAYER				# player.asm

	la	t0, frame
	lb	t0, 0(t0)
	mv	a1, t0

	jal	RENDER_MATRIX			# scenes.asm

	j	END_MAIN


# [[ Nível 2 ]]
LEVEL_2:
	jal	PLAYER				# player.asm

	la	t0, frame
	lb	t0, 0(t0)
	mv	a1, t0

	jal	RENDER_MATRIX			# scenes.asm

	j	END_MAIN


# [[ Nível 3 ]]
LEVEL_3:
	jal	PLAYER				# player.asm

	la	t0, frame
	lb	t0, 0(t0)
	mv	a1, t0

	jal	RENDER_MATRIX			# scenes.asm

	j	END_MAIN




RENDER_MATRIX:
	# s0: endereço na matriz
	# s1: altura
	# s2: largura
	# s3: contadorY
	# s4: contadorX

	la	t0, returnAddress0
	sw	ra, 0(t0)


	# s0: endereço da matriz
	la	t0, matrix
	lw	s0, 0(t0)			# s0: endereço inicial da matriz

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
	addi	s3, s3, 1

	lb	a0, 0(s0)			# valor do id na célula

	jal	GET_SPRITE			# executa o algoritmo de renderização


	addi	s4, s4, 1			# soma 1 ao contadorX
	addi	s0, s0, 1			# soma 1 ao enredeço da matriz

	bge	s4, s2, line_loop		# se o contadorX for igual ou maior à largura, inicia a próxima linha

	j	cell_loop			# senão, continua percorrendo a linha da matriz

end_matrix_render:
	la	t0, returnAddress0
	lw	ra, 0(t0)
	ret					# volta pro loop de jogo
