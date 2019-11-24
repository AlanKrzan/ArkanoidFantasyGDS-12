extends KinematicBody2D

#const BALL_SPEED = 600
export var speed = 400
var on=true
#onready var initial_pos = self.position

var velocity = Vector2()

#ustawienie początkowej pozycji oraz vector prędokości
func start(pos,vel=Vector2(speed, -speed)):
    position = pos
    velocity = vel

#funkcja obsługująca ruch oraz wywołująca efekt zderzenia jeśli taki występuje
func _physics_process(delta):
    if on:
        var collision = move_and_collide(velocity * delta)
        if collision:
            velocity = velocity.bounce(collision.normal)
            if collision.collider.has_method("hit"):
                collision.collider.hit()

func stop_movement():
    on=false

#funkcja do zabicia piłki    
func die():
    queue_free()
    
#coś co nie działa?
func _on_VisibilityNotifier2D_screen_exited():
    print("sayonara")
    queue_free()
    