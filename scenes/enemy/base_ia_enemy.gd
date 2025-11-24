@abstract
class_name IAEnemy extends CharacterBody2D

@abstract
func _on_pulse_stun(knockback_direction: Vector2, radius: float, duration: float, knockback_force: float) -> void

@abstract
func die() -> void
