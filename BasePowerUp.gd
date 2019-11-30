extends Area2D

export var speed=200
var velocity=Vector2(0,speed)

func die():
    queue_free()

func start(pos):
    position=pos

func _ready():
    get_parent().connect("stop",self,"die")

func _process(delta):
    position+=velocity*delta

func _on_BasePowerUp_body_entered(body):
    if body.has_method("power_up"):
        body.power_up(1)
        queue_free()


func _on_VisibilityNotifier2D_screen_exited():
    queue_free()
