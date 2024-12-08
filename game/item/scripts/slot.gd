class_name Slot extends Resource

@export var item_data: ItemData
@export var amount: int:
	set(new_value):
		new_value = max(0, new_value)
		if amount != new_value:
			amount = new_value
			if amount == 0:
				item_data = null
			emit_changed()

func _init(_item_data: ItemData = null, _amount: int = 0) -> void:
	item_data = _item_data
	amount = _amount

func merge(slot: Slot, _amount: int = 0) -> int:
	if !item_data:
		item_data = slot.item_data
	if item_data != slot.item_data:
		return 0
	
	_amount = slot.amount if _amount <= 0 else _amount
	
	var add_amount = item_data.stack - (amount + _amount)
	add_amount = clamp(add_amount, 0, _amount)
	
	if add_amount > 0:
		slot.amount -= add_amount
		amount += add_amount
	
	return add_amount

func split(_amount: int = 0) -> Slot:
	if _amount <= 0:
		return null
	_amount = clamp(_amount, 0, amount)
	
	var slot = duplicate()
	slot.amount = _amount
	amount -= _amount
	
	return slot
