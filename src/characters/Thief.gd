extends "res://characters/NPC.gd"


var _numStolenCoins := 0


func _ready() -> void:
	add_to_group("Enemies")


func _processAI(_deltaInSecs: float) -> void:
	if !_doingSomething:
		_doingSomething = true

		# Leave if happy with the coins
		var chanceToLeave := (_numStolenCoins - 3) / 10.0
		if randf() < chanceToLeave:
			var target = Globals.getPointInGroup("ThiefSpawnPoints")
			moveToThenDo(target, "doLeave")
			return

		# Otherwise, keep thinking
		var r := randf()
		if r < 0.1:
			# Go to a random room and decide again
			var target = Globals.getPointInGroup("RoomPoints")
			moveToThenDo(target, "doNothing")
		else:
			# Steal!
			var target = Globals.getPointInGroup("SafePoints")
			moveToThenDo(target, "doSteal")


func doSteal(_arg) -> void:
	if getCoinStock() == 0:
		# No more coins, get out of here!
		_doingSomething = true
		var target = Globals.getPointInGroup("ThiefSpawnPoints")
		moveToThenDo(target, "doLeave")

		return

	# There are still coins in the safe. Get one and redecide
	var mintage := get_tree().get_nodes_in_group("Mintage")[0] as Node2D
	for m in mintage.get_children():
		if m.state == Globals.MintageState.COIN:
			m.get_parent().remove_child(m)
			$StolenCoins.add_child(m)
			Globals.gameState.stocks[Globals.MintageState.COIN] -= 1
			_numStolenCoins += 1
			break
	yield(get_tree().create_timer(0.5), "timeout")
	_doingSomething = false


func getCoinStock() -> int:
	return Globals.gameState.stocks[Globals.MintageState.COIN]


func die() -> void:
	var mintage := get_tree().get_nodes_in_group("Mintage")[0] as Node2D
	for m in $StolenCoins.get_children():
		m.get_parent().remove_child(m)
		mintage.add_child(m)
		Globals.gameState.stocks[Globals.MintageState.COIN] += 1
	queue_free()
