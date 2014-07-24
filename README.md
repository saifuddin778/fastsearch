fastsearch
==========

A fast document lookup system based on right-array division technique. 

###Usage Steps:
* Build the mappings by providing the data
* Once the mappings are built, query for documents based on keywords.

###Example:
```lua
> require 'fastsearch'
> local k = fastsearch
> data = {{id, doc(string)}, {id, doc(string)}...}
> k.init(data)
> k.create_mappings()
```
Once the mappings are created, docs can be queried/searched via keywords in two possible ways:
####Single Keywords:
```lua
> k.search(keyword, 0)
> {1: 1, 2: 6, ...}
```
####Multiple Keywords:
```lua
> k.search(keyword or sentence, 1)
> {1: 1, 2: 5, ...}
```
####Output Types:
The output for a given query is the document id in which the searched keyword(s) is/are existing. There are two types of outputs this system can produce:
* Precise: Given that the keyword(s) existed in the dataset on which the mappings are built.
* Inexact: A condition in which the searched keyword(s) do not exist in the mappings dataset - in which case, the result is bascically all the docs that contain keywords structurally close to the provided keyword(s).
