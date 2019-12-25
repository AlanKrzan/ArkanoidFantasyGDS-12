extends Area2D
#warning-ignore-all:unused_variable
#warning-ignore-all:return_value_discarded

export var speed=200
var velocity=Vector2(0,speed)
signal points(score,is_ball)

func die():
    queue_free()

func start(pos):
    position=pos

func _ready():
    self.connect("points",get_parent(),"_get_points")
    get_parent().connect("stop",self,"die")

func _process(delta):
    position+=velocity*delta



func _on_VisibilityNotifier2D_screen_exited():
    queue_free()
