@tool
class_name ContextProvider
extends Simulable

## Any node that provides context to the simulation must inherit from ContextProvider and initialize
## the keys it adds to context dictionary. In addition, it's important to make these nodes @tool to
## ensure proper functioning (if not, keys var does not exists for the editor).

var keys : Array[String] = []
