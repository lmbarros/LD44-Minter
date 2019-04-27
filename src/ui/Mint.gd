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
			randomPointInside($FurnaceRoom/Depot),
			getInitialWorkForNextState())
		$Mintage.add_child(m)


func addMoltenMetalToMolding(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.MOLTEN_METAL,
			randomPointInside($MoldingRoom/Depot),
			getInitialWorkForNextState())
		$Mintage.add_child(m)


func addWetPlanchetToDrying(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.WET_PLANCHET,
			randomPointInside($DryingRoom/Depot),
			getInitialWorkForNextState())
		$Mintage.add_child(m)


func addPlanchetToPress(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.PLANCHET,
			randomPointInside($PressRoom/Depot),
			getInitialWorkForNextState())
		$Mintage.add_child(m)


func addCoinToOut(count: int) -> void:
	for i in range(count):
		var m := Globals.makeMintage(Globals.MintageState.COIN,
			randomPointInside($SafeRoom/Depot),
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
			return randomPointInside($FurnaceRoom/Depot)
		Globals.MintageState.MOLTEN_METAL:
			return randomPointInside($MoldingRoom/Depot)
		Globals.MintageState.WET_PLANCHET:
			return randomPointInside($DryingRoom/Depot)
		Globals.MintageState.PLANCHET:
			return randomPointInside($PressRoom/Depot)
		Globals.MintageState.COIN:
			return randomPointInside($SafeRoom/Depot)


func getInitialWorkForNextState() -> float:
	return rand_range(
		Globals.WORK_FOR_NEXT_STATE / 5.0, Globals.WORK_FOR_NEXT_STATE)


func _on_InTimer_timeout():
	var m := Globals.makeMintage(Globals.MintageState.RAW_METAL, $Courtyard/InPosition.position)
	var s := m.find_node("Sprite") as Sprite
	s.modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	var tweenDuration := 0.8
	var t := m.find_node("MoveTween") as Tween
	t.interpolate_property(s, "modulate", s.modulate, Color(1.0, 1.0, 1.0, 1.0),
		tweenDuration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Mintage.add_child(m)
	m.moveTo(getPositionForNextState(m))


func _on_OutTimer_timeout():
	var mintage := $Mintage.get_children()
	for m in mintage:
		if m.state == Globals.MintageState.COIN:
			# Remove from $Coinage; it is considered removed already
			m.get_parent().remove_child(m)
			add_child(m)
			Globals.gameState.stocks[Globals.MintageState.COIN] -= 1

			# Show it going away
			var tweenDuration := 2.0
			var t := m.find_node("MoveTween") as Tween
			var s := m.find_node("Sprite") as Sprite
			t.interpolate_property(s, "modulate", s.modulate,
				Color(1.0, 1.0, 1.0, 0.0), tweenDuration, Tween.TRANS_QUAD,
				Tween.EASE_IN_OUT)
			m.moveTo($Courtyard/OutPosition.position)

			# Give the coin some time and remove it for once
			yield(get_tree().create_timer(3.0), "timeout")
			m.queue_free()
			break
