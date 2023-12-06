##################################################
# input.s - KawaiIce Cream - Projeto ISC 2023-2
# 
# Descrição: checa se alguma tecla foi pressiona-
# da, se a tecla interessa ao jogo e passsa essa
# informação para o script do jogador.
# 
# Output:	a0: id da tecla pressionada
##################################################


.data

enderecoInput:
.word 0xff200000


.text

INPUT:
	la	t1, enderecoInput
	lw	t1, 0(t1)
	lb	a0, 4(t1)		# carrega a tecla pressionada (ASCII)


	ret

CLEAR_INPUT:
	la	t1, enderecoInput
	lw	t1, 0(t1)
	sb	zero, 4(t1)		# limpa a tecla da memória

	ret
