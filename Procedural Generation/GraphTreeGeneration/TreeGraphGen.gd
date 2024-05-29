class_name TreeGraphGeneration
extends Node2D

@export var maxNodes:int = 5
# Adjacency list represented as a dictionary
var adjacency_list = {}
# Node positions for visualization
var node_positions = {}

# Function to add a node
func add_node(node):
	if not adjacency_list.has(node):
		adjacency_list[node] = []
		
# Function to add an edge
func add_edge(node1, node2):
	if adjacency_list.has(node1) and adjacency_list.has(node2):
		adjacency_list[node1].append(node2)
		adjacency_list[node2].append(node1) # For an undirected graph

# Function to remove an edge
func remove_edge(node1, node2):
	if adjacency_list.has(node1) and adjacency_list.has(node2):
		adjacency_list[node1].erase(node2)
		adjacency_list[node2].erase(node1) # For an undirected graph

# Function to remove a node
func remove_node(node):
	if adjacency_list.has(node):
		for neighbor in adjacency_list[node]:
			adjacency_list[neighbor].erase(node)
		adjacency_list.erase(node)

# Function to print the adjacency list
func print_adjacency_list():
	for node in adjacency_list.keys():
		print("%s: %s" % [node, adjacency_list[node]])

# Function to print the parent of a given node
func print_parent(node):
	for parent_node in adjacency_list.keys():
		if node in adjacency_list[parent_node]:
			print("%s's parent is %s" % [node, parent_node])
			return
	print("%s has no parent (it's a root node or disconnected)" % node)

# Function to print the children of a given node
func print_children(node):
	if adjacency_list.has(node):
		print("%s's children are: %s" % [node, adjacency_list[node]])
	else:
		print("%s does not exist in the graph" % node)

# Function to create a random spanning tree with a maximum degree of 4
func create_spanning_tree(max_nodes):
	randomize()  # Ensure random seed is different each run

	# Create nodes
	for i in range(max_nodes):
		add_node(str(i))

	# List to keep track of added nodes to ensure the tree property
	var added_nodes = [str(0)]

	# Create a random spanning tree
	for i in range(1, max_nodes):
		var new_node = str(i)
		var existing_node = added_nodes[randi() % added_nodes.size()]

	# Ensure the existing node does not exceed a degree of 4
		while adjacency_list[existing_node].size() >= 4:
			existing_node = added_nodes[randi() % added_nodes.size()]

		add_edge(new_node, existing_node)
		added_nodes.append(new_node)

func print_degrees():
	for node in adjacency_list.keys():
		var degree = adjacency_list[node].size()
		print("%s has a degree of %d" % [node, degree])

func getAdjacencyDegreeList():
	var degreeList = {}
	degreeList.clear()
	for node in adjacency_list.keys():
		var degree = adjacency_list[node].size()
		degreeList[node] = []
		degreeList[node].append(degree)
	return degreeList

func getAdjacencyValueByKey(key:int):
	var valueList = []
	valueList.clear()
	for node in adjacency_list.get(str(key)):
		valueList.append(int(node))
	return valueList

func getAdjacencyDegree(key:int):
	return adjacency_list.get(str(key)).size()


