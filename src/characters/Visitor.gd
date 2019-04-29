extends NPC

func _ready() -> void:
	add_to_group("Enemies")
	speed = 120


func _processAI(_deltaInSecs: float) -> void:
	if !_doingSomething:
		_doingSomething = true

		# Decide
		yield(get_tree().create_timer(1.5), "timeout")
		var r := randf()
		if r < 0.2:
			# Bored, leave
			_doingSomething = true
			var target = Globals.getPointInGroup("VisitorSpawnPoints")
			moveToThenDo(target, "doLeave")
		elif r < 0.6:
			# Walk around the museum area
			var target = Globals.getPointInGroup("ReceptionPoints")
			moveToThenDo(target, "doNothing")
		else:
			# Go rogue!
			var target = Globals.getPointInGroup("RoomPoints")
			moveToThenDo(target, "doGetHurt")
			Globals.showToast("Visitor going to forbidden areas! He may get hurt!")


func doGetHurt(_arg) -> void:
	_health -= 0.2
	Globals.showToast("Visitor got hurt and asked for compensation!")
	Globals.addCoinRateModifier("Injury compensation", 15.0, -10)


func die() -> void:
	Globals.showToast("Visitor died! Large compensation for the family!")
	Globals.addCoinRateModifier("Death compensation", 25.0, -20)
	queue_free()


func _receiveDamage():
	# Staff is attacking me, better go home
	_doingSomething = true
	var target = Globals.getPointInGroup("VisitorSpawnPoints")
	moveToThenDo(target, "doLeave")
