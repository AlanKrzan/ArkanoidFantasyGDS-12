extends "res://Scripts/BasePowerUp.gd"

func _on_BasePowerUp_body_entered(body):
    if body.has_method("power_up"):
        body.power_up(6)
        queue_free()