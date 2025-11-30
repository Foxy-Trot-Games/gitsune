@abstract
class_name IAEnemy extends CharacterBody2D

const ENEMY_ALERTED_SOUND = preload("uid://bkev8egj4eid2")
const ENEMY_DAMAGED_SOUND = preload("uid://b388ps60au5i2")

@abstract
func _on_pulse_stun(knockback_direction: Vector2, radius: float, duration: float, knockback_force: float) -> void

@abstract
func die() -> void

func _play_alerted_sound() -> void:
	Audio.play_sfx(ENEMY_ALERTED_SOUND, self, 4000, -20)

func _play_death_sound() -> void:
	Audio.play_sfx(ENEMY_DAMAGED_SOUND, self)
