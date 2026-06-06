extends Resource
class_name Clothing


@export var name: String
@export var texture: Texture
@export var type: Global.CLOTHING_TYPE
@export var colour: Color

func init(
  clothing_name: String,
  clothing_texture: Texture,
  clothing_colour: Color,
  clothing_type: Global.CLOTHING_TYPE,
) -> void:
  name = clothing_name
  texture = clothing_texture
  type = clothing_type
  colour = clothing_colour

