extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_group: Node2D = $SpriteGroup
var template: Character = load("user://player.tres")
var view_only: bool = false # need a better way to do this

# get sounds
var grass_walk: Array[String] = Global.get_player_footsteps("grass_walk")
var dirt_walk: Array[String] = Global.get_player_footsteps("dirt_walk")

# movement
var move_speed: float = Global.PLAYER_MOVE_SPEED
var last_facing_direction: Vector2 = Vector2(0, 0) # direction of last movement
var direction: Vector2 = Vector2.ZERO # direction of movement

func _physics_process(delta: float) -> void:
  _handle_player_movement(delta)
  _handle_player_animation()
  move_and_slide()

func _ready() -> void:
  _init_character()

  animation_tree.active = true
  # create sfx streams
  AudioManager.create_new_entity_stream("Player", "GrassWalk", "random", grass_walk)
  AudioManager.create_new_entity_stream("Player", "DirtWalk", "random", dirt_walk)

# stop gap to prevent character from playing animations or moving in non game screens i.e character creator
func set_view_only(is_view_only: bool) -> void:
  view_only = is_view_only
  move_speed = 0

func _init_character() -> void:
  # load textures
  var hair_sprite: Sprite2D = sprite_group.get_node("Hair")
  hair_sprite.texture = template.hair_texture
  hair_sprite.hframes = 5
  hair_sprite.vframes = 3
  hair_sprite.frame_coords = template.hair_coord

  var top_sprite: Sprite2D = sprite_group.get_node("Top")
  top_sprite.texture = template.clothes[Global.CLOTHING_TYPE.TOP].texture
  top_sprite.hframes = 8
  top_sprite.vframes = 3

  var bottom_sprite: Sprite2D = sprite_group.get_node("Bottom")
  bottom_sprite.texture = template.clothes[Global.CLOTHING_TYPE.BOTTOM].texture
  bottom_sprite.hframes = 8
  bottom_sprite.vframes = 3

  # load colours
  hair_sprite.self_modulate = template.colour[Global.BODY_PART.HAIR]

  sprite_group.get_node("BodyBase").self_modulate = template.colour[Global.BODY_PART.BODY]
  sprite_group.get_node("Pupils").self_modulate = template.colour[Global.BODY_PART.PUPILS]

  top_sprite.self_modulate = template.clothes[Global.CLOTHING_TYPE.TOP].colour
  bottom_sprite.self_modulate = template.clothes[Global.CLOTHING_TYPE.BOTTOM].colour

func _handle_player_movement(delta: float) -> void:
  direction = Input.get_vector("key_left", "key_right", "key_up", "key_down")
  velocity = direction * delta * move_speed * 200 # arbitrary const to speed up player

func _handle_player_animation() -> void:
  var idle: bool = !velocity
  if !idle:
    last_facing_direction = velocity.normalized()

  animation_tree.set("parameters/Idle/blend_position", last_facing_direction)
  animation_tree.set("parameters/Walk/blend_position", last_facing_direction)

func play_footstep() -> void:
  var current_terrain: String = GameWorldManager.get_terrain(position)
  if !current_terrain: return # early return to avoid nest

  var stream_name: String = current_terrain + "Walk"
  AudioManager.play_entity_stream("Player", stream_name)
