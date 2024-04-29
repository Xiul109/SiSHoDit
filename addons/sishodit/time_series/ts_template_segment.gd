class_name TSTemplateSegment
extends Resource 

## Stores the properties needed for representing a time series segment

## Curve for defining the shape of the time series
@export var shape : Curve

## Duration of the segment. It will be modified later to be at least as long
## as the period of the sensor using it
@export var duration : float = 0.1
