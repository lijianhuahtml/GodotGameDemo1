class_name SlotUi extends Control

@onready var item_texture: TextureRect = $MarginContainer/ItemTexture
@onready var amount: Label = $MarginContainer/Amount

@export var slot: Slot

signal slot_clicked(index: int, button_index: int)

func refresh(_slot: Slot = null):
	slot = _slot
	
	if slot and slot.amount > 0:
		item_texture.texture = slot.item_data.icon
		item_texture.visible = true
		amount.text = str(slot.amount)
		amount.visible = slot.amount > 1
		tooltip_text = slot.item_data.desc
	else:
		item_texture.visible = false
		amount.visible = false
		tooltip_text = ""

func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.is_pressed()):
		return
	slot_clicked.emit(get_index(), event.button_index)
