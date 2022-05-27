extends Spatial

export (float) var min_x = -2
export (float) var max_x = 2

var anim: AnimationPlayer
var camera: Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = $anim
	camera = $camera

func shake():
	anim.play("shake")

func _process(delta):
	var scene = GameScene.current(self)
	var target = 0
	for ally in scene.allies:
		target += ally.translation.x
	target = target/scene.allies.size()
	
	target = min(max_x, max(min_x, target))
	var pos = translation
	if target > pos.x + 1:
		pos.x += target - (pos.x + 1)
	elif target < pos.x - 1:
		pos.x += target - (pos.x - 1)
	
	if abs(target - pos.x) > 0.01:
		translation = pos
