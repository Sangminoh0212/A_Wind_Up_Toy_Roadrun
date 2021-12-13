extends Node2D

onready var gameManager = find_parent("GameManager")
onready var monsters = preload("res://Monster/Monster.tscn")

var playerPos
var playerVelocity
var monster

var monsterDead = false
var killPlayer = false

func _on_GameManager_spawn_monster(_playerPos, _playerVelocity):
	monster = monsters.instance()
	monster.setting(_playerPos,_playerVelocity)
	add_child(monster)

func kill_player():
	gameManager.monsterTimer.stop()
	gameManager.game_over()

func monster_dead():
	gameManager.start_monster_timer()


	