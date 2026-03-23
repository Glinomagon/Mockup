extends CharacterBody2D

@onready var player_camera : Camera2D = $PlayerCamera
@onready var player_sprite : AnimatedSprite2D = $PlayerSprite
var is_moving : bool = false

var direction : Vector2 = Vector2.ZERO
@export var move_speed : int = 20
const MAX_ZOOM : Vector2 = Vector2(3.00, 3.00)
const MIN_ZOOM : Vector2 = Vector2(2.00, 2.00)

func _ready() -> void:
	player_camera.zoom = MIN_ZOOM

func set_camera_limit(left : int, right : int, top : int, bottom : int) -> void:
	player_camera.limit_left = left
	player_camera.limit_right = right
	player_camera.limit_top = top
	player_camera.limit_bottom = bottom

func handle_player_movement(delta: float) -> void:
	direction.y = int(Input.is_action_pressed("key_down")) - int(Input.is_action_pressed("key_up"))
	direction.x = int(Input.is_action_pressed("key_right")) - int(Input.is_action_pressed("key_left"))
	direction = direction.normalized() # to prevent player from moving too fast when moving diagonally
	velocity = direction * delta * move_speed * 200 # arbitrary const to speed up player

func handle_player_animation() -> void:
	if player_sprite.flip_h:
		player_sprite.flip_h = false
	# maybe delta not needed
	if Input.is_action_pressed("key_down"):
		is_moving = true
		player_sprite.play("walking_front")
	elif Input.is_action_pressed("key_up"):
		is_moving = true
		player_sprite.play("walking_back")
	elif Input.is_action_pressed("key_left"):
		is_moving = true
		player_sprite.play("walking_side")
	elif Input.is_action_pressed("key_right"):
		is_moving = true
		player_sprite.flip_h = true
		player_sprite.play("walking_side")
	else:
		is_moving = false
		player_sprite.play("idle")

func handle_zoom() -> void:
	if Input.is_action_just_pressed("zoom_in") && player_camera.zoom < MAX_ZOOM:
		player_camera.zoom = Vector2(snappedf(player_camera.zoom.x + 0.1, 0.1), snappedf(player_camera.zoom.y + 0.1, 0.1))
		print(player_camera.zoom)
	elif Input.is_action_just_pressed("zoom_out") && player_camera.zoom > MIN_ZOOM:
		player_camera.zoom = Vector2(snappedf(player_camera.zoom.x - 0.1, 0.1), snappedf(player_camera.zoom.y - 0.1, 0.1))
		print(player_camera.zoom)


func _physics_process(delta: float) -> void:
	handle_player_movement(delta)
	
	move_and_slide()

func _process(delta: float) -> void:
	handle_player_animation()
	handle_zoom()
