extends KinematicBody2D

export var margin=10
var l_margin
var r_margin
export var paddle_speed = 500  # How fast the player will move (pixels/sec).
export var paddle_width = 35
var screen_size # Size of the game window.
onready var initial_pos = self.position
var speed = paddle_speed
var upgrade = 0

func start(pos):
    position = pos
    show()

func reset():
    position = initial_pos
    _reset_power()

func power_up(value):
    if upgrade != 0:
        _reset_power()
    print("power up:"+str(value))
    if value==1:
        upgrade=1
        var shape = $CollisionShape2D.get_shape()
        var oldScale = shape.get_extents()
        shape.set_extents(Vector2(paddle_width*2,oldScale.y))
        $Sprite.scale=Vector2(2,0.17)
        l_margin=margin*2
        r_margin=screen_size.x-l_margin

func _reset_power():
    print("reseting")
    upgrade=0
    var shape = $CollisionShape2D.get_shape()
    var oldScale = shape.get_extents()
    shape.set_extents(Vector2(paddle_width,oldScale.y))
    $Sprite.scale=Vector2(1,0.17)
    l_margin=margin
    screen_size = get_viewport_rect().size
    r_margin=screen_size.x-margin
    
func _ready():
    _reset_power()
    screen_size = get_viewport_rect().size
    l_margin = margin
    r_margin =  screen_size.x - margin
    hide()

func _process(delta):
    var velocity = Vector2()  # The player's movement vector.
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
    position += velocity * delta
    position.x = clamp(position.x, l_margin, r_margin)