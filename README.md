# Pokedex
## Network core
### Cache: 
Max 24h online/offline cache for all services.
### Errors: 
Errors description are located in ServiceError class.
### Operations:
Every service is an extension of BaseOperation, each operation can be an operation queue and each operation can be used in turn in another operation.
###Services
Each service contains all the operations inherent to that service


## Navigation
### Context
The application context must be passed to each coordinator, it containt all references for use network services, message services and storage services.
### Coordinator
The coordinator manages the view logic
### ViewController
The ViewController manages the UI view

## Layout
Component layout is managed by individual classes for each component, as well as fonts and colors

## Other
* No external library
* All native component utilities are implemented in extensions class
* Strings are localized
