extends Resource
class_name Character

# Appearance and textures
# hardcode this for now since there's no variations to these ones anyway
@export var body_texture: Texture = load(Global.PLAYER_TEXTURES[Global.BODY_PART.BODY])
@export var eye_texture: Texture = load(Global.PLAYER_TEXTURES[Global.BODY_PART.EYES])
@export var pupil_texture: Texture = load(Global.PLAYER_TEXTURES[Global.BODY_PART.PUPILS])
@export var hair_texture: Texture = load(Global.PLAYER_TEXTURES[Global.BODY_PART.HAIR])

@export var colour: Dictionary[Global.BODY_PART, Color] = {
	Global.BODY_PART.BODY: Color(0, 0, 0),
	Global.BODY_PART.PUPILS: Color(0, 0, 0),
	Global.BODY_PART.HAIR: Color(0, 0, 0),
}

@export var clothes: Dictionary[Global.CLOTHING_TYPE, Clothing] = {
	Global.CLOTHING_TYPE.TOP: null,
	Global.CLOTHING_TYPE.BOTTOM: null,
}

# different hair on x coordinates, y coordinate is for hair faces
@export var hair_coord: Vector2

func set_texture(part: Global.BODY_PART, texture: Texture) -> void:
	match part:
		Global.BODY_PART.BODY:
			body_texture = texture
		Global.BODY_PART.EYES:
			eye_texture = texture
		Global.BODY_PART.PUPILS:
			pupil_texture = texture
		Global.BODY_PART.HAIR:
			hair_texture = texture

func set_hair(frame_coord: Vector2) -> void:
	hair_coord = frame_coord
	
func set_part_colour(body_part: Global.BODY_PART, new_colour: Color) ->  void:
	colour[body_part] = new_colour

func set_clothing(clothing_type: Global.CLOTHING_TYPE, clothing: Clothing) -> void:
	clothes[clothing_type] = clothing

func load_character(template: Character) -> void:
	body_texture = template.body_texture
	eye_texture = template.eye_texture
	pupil_texture = template.pupil_texture
	hair_texture = template.hair_texture

	colour[Global.BODY_PART.BODY] = template.colour[Global.BODY_PART.BODY]
	colour[Global.BODY_PART.PUPILS] = template.colour[Global.BODY_PART.PUPILS]
	colour[Global.BODY_PART.HAIR] = template.colour[Global.BODY_PART.HAIR]

	clothes[Global.CLOTHING_TYPE.TOP] = template.clothes[Global.CLOTHING_TYPE.TOP]
	clothes[Global.CLOTHING_TYPE.BOTTOM] = template.clothes[Global.CLOTHING_TYPE.BOTTOM]

	hair_coord = template.hair_coord