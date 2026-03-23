extends CharacterBody2D

@onready var player_camera: Camera2D = $PlayerCamera
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

var direction : Vector2 = Vector2.ZERO
@export var move_speed : int = 20
const MAX_ZOOM : float = 3.00
const MIN_ZOOM : float = 1.00

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
		player_sprite.play("walking_front")
	elif Input.is_action_pressed("key_up"):
		player_sprite.play("walking_back")
	elif Input.is_action_pressed("key_left"):
		player_sprite.play("walking_side")
	elif Input.is_action_pressed("key_right"):
		player_sprite.flip_h = true
		player_sprite.play("walking_side")
	else:
		player_sprite.play("idle")

func _physics_process(delta: float) -> void:
	handle_player_movement(delta)
	handle_player_animation()
	
	move_and_slide()
