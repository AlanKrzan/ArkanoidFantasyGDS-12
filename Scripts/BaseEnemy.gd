extends KinematicBody2D

export var speed=100
var velocity=Vector2(0,50)
var on=true
export var score=50
signal points(score,is_ball)
signal release
var not_overide=false
# warning-ignore:unused_class_variable
var rotation_offset = deg2rad(41)

func start(pos,vel=Vector2(0,100)):
    position = pos
    velocity = vel
    rotate(deg2rad(180))

func stop_movement():
    on=false
    if not not_overide:
        $SpawnOverideTimer.stop()
    
func die():
    queue_free()
    
func restart_movement():
    on=true
    if not not_overide:
        $SpawnOverideTimer.start()

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
    if on and not_overide:
        var collision = move_and_collide(velocity * delta)
        if collision:
            if collision.collider.is_in_group("Paddle"):
                emit_signal("points",_get_score(),false)
                queue_free()
            var motion = collision.remainder.bounce(collision.normal)
            velocity = velocity.bounce(collision.normal)
            rotation = fmod(rotation, 2 * PI)
            rotate(-velocity.angle_to(Vector2(0,1))-rotation+rotation_offset +PI)
            collision=move_and_collide(motion)
    elif on:
        position+=velocity*delta

func _on_SpawnOverideTimer_timeout():
    not_overide=true
    velocity = Vector2(-speed,speed)
    rotate(-velocity.angle_to(Vector2(0,50)))
