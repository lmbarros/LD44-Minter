extends Node2D

var _isGamingOver := false

func _process(delta: float) -> void:
	$Panel/Score/Value.text = str(Globals.gameState.score)
	_updateCoinRateModifiers(delta)
	$HelpText.text = Globals.helpText


func _updateCoinRateModifiers(delta: float) -> void:
	Globals.updateCoinRateModifiers(delta) # horrible place to do this :-)
	
	var mods := Globals.gameState.coinRateModifiers
	var modsText := ""
	
	for m in mods:
		modsText += "%s  %s (%.1fs)\n" % [m.amount, m.descr, m.secsRemaining]

	$Panel/CoinRateModifiers/Value.text = modsText


func _on_OneTickPerSecondTimer_timeout() -> void:
	var perMinuteAdjustmentFactor: int = 60 / Globals.COIN_RATE_STATS_SIZE
	var gs := Globals.gameState
	gs.coinsPerSec = gs.coinsPerSecStats.front() * perMinuteAdjustmentFactor
	gs.coinsPerSec += Globals.getCurrentCoinRateModifier()
	gs.coinsPerSec = max(gs.coinsPerSec, 0)
	gs.coinsPerSecStats.pop_front()
	gs.coinsPerSecStats.push_back(0)

	$Panel/CoinsRate/Value.text = str(gs.coinsPerSec)

	Globals.generateRandomEventMaybe($OneTickPerSecondTimer.wait_time)
	
	if Globals.gameState.coinsPerSec <= 0 and !_isGamingOver:
		_isGamingOver = true
		Globals.showToast("Augh! You let the coins per second drop to zero! This is...")
		yield(get_tree().create_timer(5.0), "timeout")
		get_tree().change_scene("res://screens/GameOverScreen.tscn")
