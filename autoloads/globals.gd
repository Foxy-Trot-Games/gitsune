## Planning on using this to store Global Variables. 
extends Node

var ACTIVE_GUN_MAX_AMMO: int ## this will eaither be a resource or refrence to a gun. 
var active_gun_ammo_count:int 

func _ready() -> void:
	Events.current_gun_ammo_signal.connect(_on_current_gun_ammo_signal)
	Events.gun_equipped_signal.connect(_on_gun_equipped_signal)

func _on_current_gun_ammo_signal(ammo_count:int)->void:
	active_gun_ammo_count = ammo_count

func _on_gun_equipped_signal(MAX_AMMO: int) -> void:
	ACTIVE_GUN_MAX_AMMO = MAX_AMMO
