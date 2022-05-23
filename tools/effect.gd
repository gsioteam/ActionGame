extends Spatial

const Defines = preload("res://tools/defines.gd")
const Face = Defines.Face

export (Defines.Face) var face
var origin_face

func _ready():
	origin_face = face

func set_face(face: int):
	if self.face != face:
		self.face = face
		_set_face(face)

func _set_face(face: int):
	pass
