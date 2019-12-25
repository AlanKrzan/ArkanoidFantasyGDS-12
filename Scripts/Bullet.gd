extends KinematicBody2D

export var speed=200
var velocity=Vector2(0,-speed)
var on=true

func _stop_movement():
    on=false

func start(pos):
     position=pos

func _physics_process(delta):
    if on:
        var collision = move_and_collide(velocity * delta)
        if collision:
            if collision.collider.has_method("hit"):
                collision.collider.hit()
                queue_free()
            elif collision.collider.is_in_group("Top"):
                queue_free()
    
func _die():
    queue_free()
        