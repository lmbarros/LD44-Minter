extends Node2D

func _process(_delta: float) -> void:
	$Panel/RawMetal/Count.text = str(Globals.gameState.stocks[Globals.MintageState.RAW_METAL])
	$Panel/MoltenMetal/Count.text = str(Globals.gameState.stocks[Globals.MintageState.MOLTEN_METAL])
	$Panel/WetPlanchets/Count.text = str(Globals.gameState.stocks[Globals.MintageState.WET_PLANCHET])
	$Panel/Planchets/Count.text = str(Globals.gameState.stocks[Globals.MintageState.PLANCHET])
	$Panel/Coins/Count.text = str(Globals.gameState.stocks[Globals.MintageState.COIN])


func _on_OneTickPerSecondTimer_timeout() -> void:
	var perMinuteAdjustmentFactor: int = 60 / Globals.COIN_RATE_STATS_SIZE
	var gs := Globals.gameState
	gs.coinsPerSec = gs.coinsPerSecStats.front() * perMinuteAdjustmentFactor
	gs.coinsPerSecStats.pop_front()
	gs.coinsPerSecStats.push_back(0)

	$Panel/CoinsRate/Value.text = str(gs.coinsPerSec)
