extends Node2D


func _process(delta: float) -> void:
	$Panel/Score/Value.text = str(Globals.gameState.score)
	$Panel/RawMetal/Count.text = str(Globals.gameState.stocks[Globals.MintageState.RAW_METAL])
	$Panel/MoltenMetal/Count.text = str(Globals.gameState.stocks[Globals.MintageState.MOLTEN_METAL])
	$Panel/WetPlanchets/Count.text = str(Globals.gameState.stocks[Globals.MintageState.WET_PLANCHET])
	$Panel/Planchets/Count.text = str(Globals.gameState.stocks[Globals.MintageState.PLANCHET])
	$Panel/Coins/Count.text = str(Globals.gameState.stocks[Globals.MintageState.COIN])

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
	gs.coinsPerSecStats.pop_front()
	gs.coinsPerSecStats.push_back(0)

	$Panel/CoinsRate/Value.text = str(gs.coinsPerSec)

	Globals.generateRandomEventMaybe($OneTickPerSecondTimer.wait_time)
