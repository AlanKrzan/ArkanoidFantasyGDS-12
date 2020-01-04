extends Area2D
#warning-ignore-all:unused_variable
#warning-ignore-all:return_value_discarded

export var speed=200
var velocity=Vector2(0,speed)
signal points(score,is_ball)
var on=true

func die():
    queue_free()

func start(pos):
    position=pos

func _ready():
    self.connect("points",get_parent(),"_get_points")
    get_parent().connect("die",self,"die")
    get_parent().connect("purge",self,"die")
    get_parent().connect("leaving_stop",self,"stop_movement")
    get_parent().connect("move",self,"restart_movement")
    get_parent().connect("stop",self,"stop_movement")

func restart_movement():
    on=true
    
func stop_movement():
    on=false

func _process(delta):
    if on:
        position+=velocity*delta

func _on_VisibilityNotifier2D_screen_exited():
    queue_free()
