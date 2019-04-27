extends Node2D

const INITIAL_RESOURCE_COUNT := 10

func _ready():
	Globals.initGameState()
	addRawMetalToInStock(INITIAL_RESOURCE_COUNT)
	addRawMetalToFurnace(INITIAL_RESOURCE_COUNT)
	addMoltenMetalToMolding(INITIAL_RESOURCE_COUNT)
	addWetPlanchetToDrying(INITIAL_RESOURCE_COUNT)
	addPlanchetToPress(INITIAL_RESOURCE_COUNT)
	addCoinToOut(INITIAL_RESOURCE_COUNT)


func addRawMetalToInStock(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.RAW_METAL,
			randomPointInside($Mint/InDepot))
		$Mintage.add_child(m)


func addRawMetalToFurnace(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.RAW_METAL,
			randomPointInside($Mint/FurnaceDepot))
		$Mintage.add_child(m)


func addMoltenMetalToMolding(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.MOLTEN_METAL,
			randomPointInside($Mint/MoldingDepot))
		$Mintage.add_child(m)


func addWetPlanchetToDrying(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.WET_PLANCHET,
			randomPointInside($Mint/DryingDepot))
		$Mintage.add_child(m)


func addPlanchetToPress(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.PLANCHET,
			randomPointInside($Mint/PressDepot))
		$Mintage.add_child(m)


func addCoinToOut(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.COIN,
			randomPointInside($Mint/OutDepot))
		$Mintage.add_child(m)


func randomPointInside(cr: ColorRect) -> Vector2:
	var p: Vector2
	
	p.x = rand_range(cr.rect_position.x, cr.rect_position.x + cr.rect_size.x)
	p.y = rand_range(cr.rect_position.y, cr.rect_position.y + cr.rect_size.y)
	return p
