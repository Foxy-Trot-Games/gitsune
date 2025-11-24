class_name Ammo extends Node2D

@onready var player_detection: Area2D = %PlayerDetection

@export var respawn_time := 5.0

func _ready() -> void:
	player_detection.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D)->void:
	if body is Player:
		Events.ammo_picked_up.emit()
		if respawn_time:
			hide()
			await Globals.create_timer(respawn_time)
			show()
		else:
			queue_free()
