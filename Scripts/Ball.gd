extends KinematicBody2D


export var speed = 200
var on=true
var velocity = Vector2()
var oldVelocity
var host
var l_margin
var r_margin

#ustawienie początkowej pozycji oraz vector prędokości
func start(pos,vel=Vector2(speed, -speed)):
    position = pos
    velocity = vel

func accelerate(a):
    velocity*=1+a

func stop_movement():
    on=false

#funkcja do zabicia piłki    
func die():
    queue_free()
    
#funkcja obsługująca ruch oraz wywołująca efekt zderzenia jeśli taki występuje
func _physics_process(delta):
    if on:
        var collision = move_and_collide(velocity * delta)
        if collision:
            if collision.collider.has_method("hit"):
                collision.collider.hit()
            var motion = collision.remainder.bounce(collision.normal)
            if collision.collider.has_method("power_up"):
                if collision.collider.has_method("angles"):
                    var movements = collision.collider.angles(position.x,velocity,collision)
                    if collision.collider.upgrade==3:
                        collision.collider.connect("follow",self,"_move")
                        collision.collider.connect("disconnect",self,"_disconnect")
                        host=collision.collider
                        l_margin=host.edge_size+host.paddle_width-(host.position.x-position.x)
                        r_margin=get_viewport_rect().size.x-host.edge_size-(host.position.x+host.paddle_width-position.x)
                        on=false
                        oldVelocity = movements[1]
                    else:
                        move_and_collide(movements[0]*delta)
                        velocity = movements[1]
                else:
                    velocity = velocity.bounce(collision.normal)
                    collision=move_and_collide(motion)
            else:
                velocity = velocity.bounce(collision.normal)
                collision=move_and_collide(motion)

func _on_VisibilityNotifier2D_screen_exited():
    queue_free()

func _move(how_much):
    position.x = clamp(position.x+how_much, l_margin, r_margin)

func _disconnect():
    on=true
    velocity=oldVelocity
    host.disconnect("follow",self,"_move")
    host.disconnect("disconnect",self,"_disconnect")
    host=null
    
func _half():
    velocity*=0.5