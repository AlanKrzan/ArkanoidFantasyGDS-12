extends KinematicBody2D

export var speed=100
var velocity=Vector2(0,50)
var on=true
export var score=50
signal points(score,is_ball)

func start(pos,vel=Vector2(0,50)):
    position = pos
    velocity = vel

func stop_movement():
    on=false
    
func die():
    queue_free()
    
func restart_movement():
    on=true
    
func _get_score():
    return score
    
func _on_VisibilityNotifier2D_screen_exited():
    print("escape?")
    queue_free()
    
func _physics_process(delta):
    if on:
        var collision = move_and_collide(velocity * delta)
        if collision:
            if collision.collider.is_in_group("Paddle"):
                emit_signal("points",_get_score(),false)
                queue_free()
            var motion = collision.remainder.bounce(collision.normal)
            velocity = velocity.bounce(collision.normal)
            collision=move_and_collide(motion)

func _on_SpawnOverideTimer_timeout():
    velocity = Vector2(-speed,speed)
