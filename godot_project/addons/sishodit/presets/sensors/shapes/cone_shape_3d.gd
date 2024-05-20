
class_name ConeShape3D
extends ConvexPolygonShape3D

@export var radius : float = 1.0 :
	set(r):
		radius = r
		update_shape()
@export var height : float = 2.0:
	set(h):
		height = h
		update_shape()
@export var steps : int = 16:
	set(s):
		steps = s
		update_shape()

func update_shape():
	var new_points = PackedVector3Array()
	new_points.clear()
	new_points.append(Vector3())
	var angle = 2.0*PI/steps
	for i in range(steps):
		new_points.append(Vector3(sin(i*angle)*radius, height, cos(i*angle))*radius)
	points = new_points
