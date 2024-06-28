extends RefCounted
class_name CircularArray

var elements: Array = []

# Adds a new element to the array
func add(element):
	elements.append(element)

# Removes an element from the array by index
func remove(index: int):
	if index >= 0 and index < elements.size():
		elements.remove_at(index)

# Gets the element at the specified index, wrapping around if necessary
func getElement(index: int):
	if elements.size() == 0:
		return null
	return elements[index % elements.size()]

# Gets the size of the array
func size() -> int:
	return elements.size()
