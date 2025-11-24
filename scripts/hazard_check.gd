extends Node

@onready var tile_map_layer: TileMapLayer = get_tree().get_first_node_in_group("InteractableTileMapLayer")

var _parent : CharacterBody2D

func _ready() -> void:
	_parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	check_tile_damage()

func check_tile_damage() -> void:
	# convert global position to local map coordinates
	var map_pos := tile_map_layer.local_to_map(_parent.global_position)
	
	# get the TileData for the cell at that position
	var tile_data := tile_map_layer.get_cell_tile_data(map_pos)
	
	# check if the tile exists and has the custom data
	if tile_data:
		var is_hazard : bool = tile_data.get_custom_data("is_hazard")
		if is_hazard:
			if _parent is Player:
				Events.player_died.emit()
			elif _parent is IAEnemy:
				(_parent as IAEnemy).die()
