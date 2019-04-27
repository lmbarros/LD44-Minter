extends Node2D

const INITIAL_RESOURCE_COUNT := 10
const WORK_PER_SEC := 0.3

func _process(delta: float) -> void:
	var mintage := $Mintage.get_children()

	for m in mintage:
		var changed: bool = m.work(delta * WORK_PER_SEC)
		if changed:
			m.moveTo(getPositionForNextState(m))


func _ready() -> void:
	addRawMetalToFurnace(INITIAL_RESOURCE_COUNT)
	addMoltenMetalToMolding(INITIAL_RESOURCE_COUNT)
	addWetPlanchetToDrying(INITIAL_RESOURCE_COUNT)
	addPlanchetToPress(INITIAL_RESOURCE_COUNT)
	addCoinToOut(INITIAL_RESOURCE_COUNT)


func addRawMetalToFurnace(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.RAW_METAL,
			randomPointInside($FurnaceDepot),
			getInitialWorkForNextState())
		$Mintage.add_child(m)


func addMoltenMetalToMolding(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.MOLTEN_METAL,
			randomPointInside($MoldingDepot),
			getInitialWorkForNextState())
		$Mintage.add_child(m)


func addWetPlanchetToDrying(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.WET_PLANCHET,
			randomPointInside($DryingDepot),
			getInitialWorkForNextState())
		$Mintage.add_child(m)


func addPlanchetToPress(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.PLANCHET,
			randomPointInside($PressDepot),
			getInitialWorkForNextState())
		$Mintage.add_child(m)


func addCoinToOut(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.COIN,
			randomPointInside($OutDepot),
			getInitialWorkForNextState())
		$Mintage.add_child(m)


func randomPointInside(cr: ColorRect) -> Vector2:
	var p: Vector2

	p.x = rand_range(cr.rect_position.x, cr.rect_position.x + cr.rect_size.x)
	p.y = rand_range(cr.rect_position.y, cr.rect_position.y + cr.rect_size.y)
	return p


func getPositionForNextState(m: Mintage) -> Vector2:
	match m.state:
		Globals.MintageState.RAW_METAL:
			return randomPointInside($FurnaceDepot)
		Globals.MintageState.MOLTEN_METAL:
			return randomPointInside($MoldingDepot)
		Globals.MintageState.WET_PLANCHET:
			return randomPointInside($DryingDepot)
		Globals.MintageState.PLANCHET:
			return randomPointInside($PressDepot)
		Globals.MintageState.COIN:
			return randomPointInside($OutDepot)


func getInitialWorkForNextState() -> float:
	return rand_range(
		Globals.WORK_FOR_NEXT_STATE / 10.0, Globals.WORK_FOR_NEXT_STATE)
