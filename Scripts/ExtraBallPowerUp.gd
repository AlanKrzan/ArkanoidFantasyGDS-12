extends "res://Scripts/BasePowerUp.gd"

func _on_BasePowerUp_body_entered(body):
    if body.has_method("power_up"):
        emit_signal("points",1000,false)
        body.power_up(4)
        queue_free()
