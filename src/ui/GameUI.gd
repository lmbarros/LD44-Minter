extends Node2D

func _process(delta):
	$Panel/RawMetal/Count.text = str(Globals.gameState.stocks[Globals.MintageState.RAW_METAL])
	$Panel/MoltenMetal/Count.text = str(Globals.gameState.stocks[Globals.MintageState.MOLTEN_METAL])
	$Panel/WetPlanchets/Count.text = str(Globals.gameState.stocks[Globals.MintageState.WET_PLANCHET])
	$Panel/Planchets/Count.text = str(Globals.gameState.stocks[Globals.MintageState.PLANCHET])
	$Panel/Coins/Count.text = str(Globals.gameState.stocks[Globals.MintageState.COIN])
