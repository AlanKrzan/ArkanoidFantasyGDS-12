extends KinematicBody2D

export var margin=20
export var edge_size=45
var l_margin
var r_margin
export var paddle_speed = 500  # How fast the player will move (pixels/sec).
export var paddle_width = 60
var screen_size # Size of the game window.
onready var initial_pos = self.position
var speed = paddle_speed
var upgrade = 0
export var power_up_width_scale=2
var on=false
var angles=[-40,-25,-10,10,25,40]

#ustawienie kijka na pozycji początkowej, i wyświetlenie go
func start(pos):
    position = pos
    show()
#powrót na pozycję początkową i reset ulepszeń do zera
func reset():
    position = initial_pos
    _reset_power()
    
#funckaj przyznająca ulepszenia, TODO: dodać więcej
func power_up(value):
    if upgrade != 0:
        _reset_power()
    print("power up:"+str(value))
    if value==1:
        upgrade=1
        var shape = $CollisionShape2D.get_shape()
        var oldScale = shape.get_extents()
        shape.set_extents(Vector2(paddle_width*power_up_width_scale,oldScale.y))
        $Sprite.scale=Vector2(power_up_width_scale,1)
        l_margin=margin*power_up_width_scale+edge_size
        r_margin=screen_size.x-l_margin

#funkcja obsługi ruchu?, powstała bo coś kombinowałem i nie chciałem powtarzać ten sam kod
func __motion(velocity,collision,normal):
    var motion = collision.remainder.bounce(normal)
    velocity = velocity.bounce(normal)
    return [motion,velocity]

#funckja obliczająca alternatywny vector normalny odbicia, w zależności od pozycji, daje dziwne efekty dla kąta >45 od północy
func angle(ball_position_x,velocity,collision):
    var width
    if upgrade==1:
        width=paddle_width*2
    else:
        width=paddle_width
    var distance
    if position.x > ball_position_x:
        distance = position.x - ball_position_x
        if distance > width/3:
             if distance > width*2/3:
                collision=__motion(velocity,collision,angles[0])
             else:
                collision=__motion(velocity,collision,angles[1])
        else:
            collision=__motion(velocity,collision,angles[2])
    elif position.x < ball_position_x:
        distance = ball_position_x - position.x
        if distance > width/3:
             if distance > width*2/3:
                collision=__motion(velocity,collision,angles[5])
             else:
                collision=__motion(velocity,collision,angles[4])
        else:
            collision=__motion(velocity,collision,angles[3])
    else:
        collision=__motion(velocity,collision,collision.normal)
    return collision

#funkcja resetująca ulepszenia TODO: cofnąć inne ulepszenia jeśli coś zmieniają, jak powstaną
func _reset_power():
    upgrade=0
    var shape = $CollisionShape2D.get_shape()
    var oldScale = shape.get_extents()
    shape.set_extents(Vector2(paddle_width,oldScale.y))
    $Sprite.scale=Vector2(1,1)
    l_margin=margin+edge_size
    screen_size = get_viewport_rect().size
    r_margin=screen_size.x-l_margin
    
#funkcja przygotująca kijek do rozgrywki
func _ready():
    _reset_power()
    var north = Vector2(0,-1)
    for i in range(angles.size()):
        angles[i]=north.rotated(deg2rad(angles[i]))
    print(angles)
    screen_size = get_viewport_rect().size
    l_margin = margin +edge_size
    r_margin =  screen_size.x - l_margin
    hide()
    
# funkcja dla sygnału rozpoczynającego grę
func _start_movement():
    on=true
    
# funkcja dla sygnału zatrzymującego grę
func _stop_movement():
    on=false

# obsluga poruszania się
func _process(delta):
    if on:
        var velocity = Vector2()  # The player's movement vector.
        if Input.is_action_pressed("ui_right"):
            velocity.x += 1
        if Input.is_action_pressed("ui_left"):
            velocity.x -= 1
        if velocity.length() > 0:
            velocity = velocity.normalized() * speed
        position += velocity * delta
        position.x = clamp(position.x, l_margin, r_margin)
