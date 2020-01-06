extends KinematicBody2D

export var speed=400
var velocity=Vector2(0,-speed)
var on=true
var living=true

func _stop_movement():
    on=false

func _restart_movement():
    on=true

func start(pos):
     $AnimatedSprite.play()
     position=pos

func _physics_process(delta):
    if on:
        var collision = move_and_collide(velocity * delta)
        if collision:
            if collision.collider.has_method("hit"):
                collision.collider.hit()
                _die()
            elif collision.collider.is_in_group("Top"):
                _die()
    
func _die():
    if living:
        living=false
        $DeathTimer.start()
        

func _on_DeathTimer_timeout():
    queue_free()
