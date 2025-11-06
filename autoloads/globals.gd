## Planning on using this to store Global Variables. 
extends Node

var active_gun_ammo_count:int 

func _ready() -> void:
	Events.current_gun_ammo_signal.connect(_on_current_gun_ammo_signal)

func _on_current_gun_ammo_signal(ammo_count:int)->void:
	active_gun_ammo_count = ammo_count
