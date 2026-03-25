extends CharacterBody2D

@onready var player_camera : Camera2D = $PlayerCamera
@onready var player_sprite : AnimatedSprite2D = $PlayerSprite
var is_moving : bool = false

var direction : Vector2 = Vector2.ZERO
@export var move_speed : int = 20
const MAX_ZOOM : Vector2 = Vector2(3.00, 3.00)
const MIN_ZOOM : Vector2 = Vector2(2.00, 2.00)

# find a better way to store and handle these
var grass_walk : Array[String] = [
	"res://Assets/SFX/Footsteps_Walk_Grass_Mono_50.wav",
	"res://Assets/SFX/Footsteps_Walk_Grass_Mono_49.wav",
	"res://Assets/SFX/Footsteps_Walk_Grass_Mono_48.wav",
	"res://Assets/SFX/Footsteps_Walk_Grass_Mono_47.wav",
	"res://Assets/SFX/Footsteps_Walk_Grass_Mono_46.wav"
	]

var dirt_walk : Array[String] = [
	"res://Assets/SFX/Footsteps_DirtyGround_Walk_01.wav",
	"res://Assets/SFX/Footsteps_DirtyGround_Walk_04.wav",
	"res://Assets/SFX/Footsteps_DirtyGround_Walk_05.wav",
	"res://Assets/SFX/Footsteps_DirtyGround_Walk_06.wav",
	"res://Assets/SFX/Footsteps_DirtyGround_Walk_09.wav"
]

func _ready() -> void:
	player_camera.zoom = MIN_ZOOM
	# create sfx streams
	AudioManager.create_new_entity_stream("Player", "GrassWalk", "random", grass_walk)
	AudioManager.create_new_entity_stream("Player", "DirtWalk", "random", dirt_walk)

func set_camera_limit(left : int, right : int, top : int, bottom : int) -> void:
	player_camera.limit_left = left
	player_camera.limit_right = right
	player_camera.limit_top = top
	player_camera.limit_bottom = bottom

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

func handle_camera_zoom() -> void:
	if Input.is_action_just_pressed("zoom_in") && player_camera.zoom < MAX_ZOOM:
		player_camera.zoom = Vector2(snappedf(player_camera.zoom.x + 0.1, 0.1), snappedf(player_camera.zoom.y + 0.1, 0.1))
		print(player_camera.zoom)
	elif Input.is_action_just_pressed("zoom_out") && player_camera.zoom > MIN_ZOOM:
		player_camera.zoom = Vector2(snappedf(player_camera.zoom.x - 0.1, 0.1), snappedf(player_camera.zoom.y - 0.1, 0.1))
		print(player_camera.zoom)

func handle_player_movement(delta : float) -> void:
	direction = Input.get_vector("key_left", "key_right", "key_up", "key_down")
	velocity = direction * delta * move_speed * 200 # arbitrary const to speed up player

	handle_player_animation()

	# handle player sound
	var current_terrain: String = GameWorldManager.get_player_terrain()
	if is_moving && current_terrain:
		var stream_name: String = current_terrain + "Walk"
		AudioManager.play_entity_stream("Player", stream_name)
	
func _physics_process(delta: float) -> void:
	handle_player_movement(delta)

	move_and_slide()

func _process(_delta: float) -> void:
	handle_camera_zoom()
