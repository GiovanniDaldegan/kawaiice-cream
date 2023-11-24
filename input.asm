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

arrowUp:
.byte 97

arrowDown:
.byte 0x0

arrowRight:
.byte

arrowLeft:
.byte


.text

INPUT:
	li	t1, 0xff200000
	lb	a0, 4(t1)		# carrega a tecla pressionada (ASCII)
	
	la	t0, key
	sb	a0, 0(t0)		# salva a tecla pressionada em "key" (ASCII)
	
	ret
	
CLEAR_INPUT:
	li	t1, 0xff200000
	sb	a0, 4(t1)
	
	ret
