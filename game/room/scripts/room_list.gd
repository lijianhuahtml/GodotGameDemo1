extends BoxContainer

const Item = preload("res://game/room/scenes/room_item.tscn")

func update(list: Array):
	var childrens = self.get_children()
	var max_size = max(list.size(), childrens.size())
	for i in max_size:
		if i < list.size() and i < childrens.size():
			childrens[i].update(list[i])
		elif i < childrens.size():
			remove_child(childrens[i])
		else:
			var item = Item.instantiate()
			item.update(list[i])
			add_child(item)
