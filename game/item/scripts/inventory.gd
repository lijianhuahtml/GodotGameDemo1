@tool
class_name Inventory extends Resource

@export var slots: Array[Slot] = []

@export var volume: int:
	set(new_value):
		new_value = max(0, new_value)
		if volume != new_value:
			volume = new_value
			for i in range(min(volume, slots.size()), max(volume, slots.size())):
				if slots.size() <= i:
					slots.push_back(null)
				else:
					slots.pop_back()
			emit_changed()

signal slots_changed

func insert(item_data: ItemData, amount: int = 1) -> int:
	if !item_data or amount <= 0:
		return amount
	
	var insert_slot = Slot.new(item_data, amount)
	
	for i in volume:
		if insert_slot.amount <= 0:
			break
		if slots.size() > i and slots[i]:
			slots[i].merge(insert_slot)
	
	for i in volume:
		if insert_slot.amount <= 0:
			break
		if !slots.size() <= i or !slots[i]:
			slots[i] = Slot.new(insert_slot.item_data)
			slots[i].merge(insert_slot)
	
	if insert_slot.amount != amount:
		slots_changed.emit()

	return insert_slot.amount
