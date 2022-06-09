extends "res://addons/action_behavior_tree/lib/if.gd"

const CommandManager = preload("res://addons/action_command/lib/command_manager.gd")

enum DirectionType {
	None,
	ForwardOnly,
	BackwardOnly
}

export var action: String
export var fit_face_to: bool = false
export (DirectionType) var forward_type = DirectionType.None

var _action_queues = []

func _ready():
	_action_queues = []
	var array = action.split("|")
	for string in array:
		if not string.strip_escapes().empty():
			_action_queues.append(CommandManager.parse_command(string))

func test(tick):
	var target = tick.target
	if not _action_queues.empty():
		for queue in _action_queues:
			if fit_face_to and target._origin_face != target.face:
				queue = CommandManager.reverse(queue)
			var result = target.command_match(queue)
			if result != null:
				if forward_type == DirectionType.ForwardOnly:
					var vec = target.absolate_speed
					if (target.face == Defines.Face.Right and vec.x <= 0) or (target.face == Defines.Face.Left and vec.x >= 0):
						return false
				if forward_type == DirectionType.BackwardOnly:
					var vec = target.absolate_speed
					if (target.face == Defines.Face.Right and vec.x >= 0) or (target.face == Defines.Face.Left and vec.x <= 0):
						return false
				result.use(CommandManager.MatchResult.UseType.Press)
				return true
	return false

func debug_data():
	return {
		"action": action
	}
