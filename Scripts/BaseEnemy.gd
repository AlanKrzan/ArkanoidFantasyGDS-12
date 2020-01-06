extends KinematicBody2D

export var speed=100
var velocity=Vector2(0,50)
var on=true
export var score=50
signal points(score,is_ball)
signal release
var rotation_offset = deg2rad(90)

func start(pos,vel=Vector2(0,50)):
    position = pos
    velocity = vel
    rotate(deg2rad(180))

func stop_movement():
    on=false
    
func die():
    queue_free()
    
func restart_movement():
    on=true

func hit():
    emit_signal("points",_get_score(),false)
    emit_signal("release")
    queue_free()
    
func _ready():
    $AnimatedSprite.play()

func _get_score():
    return score
    
func _on_VisibilityNotifier2D_screen_exited():
    emit_signal("release")
    queue_free()
    
func _physics_process(delta):
    if on:
        var collision = move_and_collide(velocity * delta)
        if collision:
            if collision.collider.is_in_group("Paddle"):
                emit_signal("points",_get_score(),false)
                queue_free()
            var motion = collision.remainder.bounce(collision.normal)
            var oldvelocity=velocity
            velocity = velocity.bounce(collision.normal)
            rotate(-velocity.angle_to(oldvelocity))
            collision=move_and_collide(motion)

func _on_SpawnOverideTimer_timeout():
    velocity = Vector2(-speed,speed)
    rotate(-velocity.angle_to(Vector2(0,50)))
