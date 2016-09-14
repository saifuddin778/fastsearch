fastsearch = require 'fastsearch'
local function test_fastsearch(data)
	local k = fastsearch
	k.init(data)
	k.create_mappings()
	--exact search
	print("city -> ", k.search("city", false))
	print("love ->", k.search("love", false))
	print("germany ->", k.search("germany", false))
	print("newyork ->", k.search("newyork", false))
	--non exact search -- needs some other solid logic
	print("lovee ->", k.search("lov", false))
	print("kfc ->", k.search("kfc", false))
	print("world ->", k.search("world", false))
	--multi search
	print("new york ->", k.search("new york", true))
	print("love beach ->", k.search("love beach", true))
	print("love new york ->", k.search("love new york", true))
end

--this must be a big dataset ..
data = {
			{1, 'i love my cat'},
            {2, 'new york is the best city'},
            {3, 'what are we looking for'},
            {4, 'i love beach'},
            {5, 'that fuck man in the city kfcu'},
            {6, 'quick and fast cat'},
            {7, 'germany got the worldcup'},
            {8, 'karach karachi has great restaurants'}
        }

test_fastsearch(data)
