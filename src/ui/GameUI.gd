extends Node2D

func _process(delta):
	$Panel/RawMetal/Count.text = str(Globals.gameState.rawMetalStock)
	$Panel/MoltenMetal/Count.text = str(Globals.gameState.moltenMetalStock)
	$Panel/WetPlanchets/Count.text = str(Globals.gameState.wetPlanchetStock)
	$Panel/Planchets/Count.text = str(Globals.gameState.planchetStock)
	$Panel/Coins/Count.text = str(Globals.gameState.coinStock)
