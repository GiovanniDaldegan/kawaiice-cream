########################################################
# audioInterface - KawaiIce Cream - Projeto ISC 2023-2
# 
# Descrição: algoritmo para tocar notas MIDI para a in-
# terface de áudio do jogo
########################################################

.data

.include "music/song.data"


.text

sfx_collectible:
	li a0, 69				#tom da nota
	li a1, 300				#duração 
	li a2, 10				#intrumento
	li a3, 80				#volume

	j	play_note

sfx_break_block:
	li a0, 64
	li a1, 500
	li a2, 47
	li a3, 80
	
	j	play_note 

sfx_create_block:
	li a0, 64
	li a1, 500 
	li a2, 97
	li a3, 80

	j	play_note

sfx_player_death:
	li a0, 62
	li a1, 1000
	li a2, 31
	li a3, 80

	j	play_note

sfx_level_complete:
	li a0, 67
	li a1, 1000
	li a2, 55
	li a3, 80

	j	play_note


play_note:
	li	a7, 31
	ecall

	ret
