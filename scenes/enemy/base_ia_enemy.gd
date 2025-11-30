@abstract
class_name IAEnemy extends CharacterBody2D

const ENEMY_ALERTED_SOUND = preload("uid://bkev8egj4eid2")

@abstract
func _on_pulse_stun(knockback_direction: Vector2, radius: float, duration: float, knockback_force: float) -> void

@abstract
func die() -> void

func _play_alerted_sound() -> void:
	Audio.play_sfx(ENEMY_ALERTED_SOUND, self, 4000, -20)
