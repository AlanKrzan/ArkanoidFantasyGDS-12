extends KinematicBody2D

export var left_margin=0
export var right_margin=0
var r_margin
export var paddle_speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
onready var initial_pos = self.position
var speed = paddle_speed

func start(pos):
    position = pos
    show()

func reset():
	position = initial_pos
	#speed = paddle_speed

func _ready():
    screen_size = get_viewport_rect().size
    r_margin =  screen_size.x -right_margin
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
    position.x = clamp(position.x, left_margin, r_margin)