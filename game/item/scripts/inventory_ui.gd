class_name InventoryUi extends Control

const SlotUiScene = preload("res://game/item/scenes/slot_ui.tscn")

@onready var grid_container: GridContainer = $PanelContainer/MarginContainer/GridContainer
@export var slot_uis: Array[SlotUi]

@export var inventory: Inventory
@export var grabbed_slot: SlotUi

func _process(delta: float) -> void:
	if grabbed_slot.slot and grabbed_slot.slot.item_data:
		grabbed_slot.visible = true
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(10, 10)
	else:
		grabbed_slot.slot = null
		grabbed_slot.visible = false

func refresh(_inventory: Inventory = null):
	if _inventory:
		inventory = _inventory
		inventory.slots_changed.connect(refresh)
	if !inventory:
		return
	
	for i in inventory.volume:
		if slot_uis.size() <= i:
			slot_uis.append(SlotUiScene.instantiate())
			grid_container.add_child(slot_uis[i])
			slot_uis[i].connect("slot_clicked", slot_clicked)
		if !slot_uis[i]:
			slot_uis[i] = SlotUiScene.instantiate()
			grid_container.add_child(slot_uis[i])
			slot_uis[i].connect("slot_clicked", slot_clicked)
		slot_uis[i].refresh(inventory.slots[i])

func slot_clicked(index: int, button_index: int) -> void:
	match [Input.is_key_pressed(KEY_CTRL), grabbed_slot.slot, inventory.slots[index], button_index]:
		[false, null, _, _]:
			grabbed_slot.slot = inventory.slots[index]
			inventory.slots[index] = null
		[false, _, null, _]:
			inventory.slots[index] = grabbed_slot.slot
			grabbed_slot.slot = null
		[true, _, null, _]:
			inventory.slots[index] = grabbed_slot.slot.split(1)
		[true, null, _, _]:
			grabbed_slot.slot = inventory.slots[index].split(1)
		[true, _, _, MOUSE_BUTTON_LEFT]:
			grabbed_slot.slot.merge(inventory.slots[index], 1)
		[false, _, _, MOUSE_BUTTON_LEFT]:
			if grabbed_slot.slot.merge(inventory.slots[index]) == 0:
				var slot = grabbed_slot.slot
				grabbed_slot.slot = inventory.slots[index]
				inventory.slots[index] = slot
		[true, _, _, MOUSE_BUTTON_RIGHT]:
			inventory.slots[index].merge(grabbed_slot.slot, 1)
		[false, _, _, MOUSE_BUTTON_RIGHT]:
			if inventory.slots[index].merge(grabbed_slot.slot) == 0:
				var slot = grabbed_slot.slot
				grabbed_slot.slot = inventory.slots[index]
				inventory.slots[index] = slot
	if inventory.slots[index] and inventory.slots[index].amount <= 0:
		inventory.slots[index] = null
	slot_uis[index].refresh(inventory.slots[index])
	grabbed_slot.refresh(grabbed_slot.slot)
