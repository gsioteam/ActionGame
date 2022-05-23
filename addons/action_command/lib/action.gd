extends Resource

class_name CommandAction, "action.png"

const TestResult = preload("status.gd").TestResult

export(String) var action_name

func test(event: InputEvent) -> int:
	return TestResult.NoRelevant
