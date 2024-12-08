class_name ItemData extends Resource

enum ItemType {
	Prop
}

@export var type: ItemType
@export var name: String
@export var icon: Texture2D
@export var sprites: SpriteFrames

## 堆叠上限
@export var stack: int:
	set(new_value):
		new_value = max(0, new_value)
		if stack != new_value:
			stack = new_value
			emit_changed()

@export_multiline var desc: String
