extends KinematicBody2D


export var speed = 200
var on=true
var velocity = Vector2()

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
                print(collision.get_normal())
            velocity = velocity.bounce(collision.normal)
            collision=move_and_collide(motion)

func _on_VisibilityNotifier2D_screen_exited():
    queue_free()
