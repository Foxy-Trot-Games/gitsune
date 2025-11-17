## Planning on using this to store Global Variables. 
extends Node

func get_level() -> Level:
	return get_tree().get_first_node_in_group("Level")

func add_child_to_level(node: Node) -> void:
	get_level().add_child(node)
