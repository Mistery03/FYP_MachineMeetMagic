class_name LinkedList
extends Node2D

var head:Dictionary = {}

# Function to create a new node
func create_node(value, next=null)->Dictionary:
	return {"value": value, "next": next}


func insertAtBegin(value)->void:
	var new_node = create_node(value)
	if head.is_empty():
		head = new_node
		return
	else:
		new_node.next = head
		head = new_node


func insertAtEnd(value)->void:
	var new_node = create_node(value)
	if head.is_empty():
		head = new_node
		return
	else:
		var current_node = self.head
		while(current_node.next):
			current_node = current_node.next

		current_node.next = new_node

# Indexing starts from 0.
func insertAtIndex(value, index):
	var new_node = create_node(value)
	var current_node = self.head
	var positionList = 0
	if positionList == index:
		self.insertAtBegin(value)
	else:
		while(current_node != null and positionList+1 != index):
			positionList = positionList+1
			current_node = current_node.next

	if current_node != null:

		new_node.next = current_node.next
		current_node.next = new_node
	else:
		print("Index not present")
		
func remove_first_node()->void:
	if(head.is_empty()):
		return
	 
	head = head.next

func remove_last_node()->void:
 
	if head.is_empty():
		return

	var current_node = self.head
	while(current_node.next.next):
		current_node = current_node.next

	current_node.next = null
	
# Method to remove at given index
func remove_at_index(index)->void:
	if head.is_empty():
		return

	var current_node = self.head
	var positionList= 0
	if positionList== index:
		self.remove_first_node()
	else:
		while(current_node != null and positionList+1 != index):
			positionList= positionList+1
			current_node = current_node.next

	if current_node != null:
		current_node.next = current_node.next.next
	else:
		print("Index not present")	


func remove_node(value)->void:
	var current_node = self.head
 
	# Check if the head node contains the specified value
	if current_node.value == value:
		self.remove_first_node()
		return

	while current_node != null and current_node.next.value != value:
		current_node = current_node.next

	if current_node == null:
		return
	else:
		current_node.next = current_node.next.next
# print method for the linked list
func printLinkedList():
	var current_node = self.head
	while(current_node):
		print(current_node.value)
		current_node = current_node.next
		

