require 'math'
local fastsearch = {}

--init
function fastsearch.init(data)
    if #data then
    	fastsearch.t = {}
    	fastsearch.sorted_t = {}
    	fastsearch.com = {a = 1, b = 2, c=3, d=4, e=5, f=6, g=7, h=8, i=9, j=10, k=11, l=12, m=13, n=14, o=16, p=17, q=18, r=19, s=20, t=21, u=22, v=23, w=24, x=25, y=26, z=27}
    	fastsearch.data = data
    else
    	print("no data provided")
    end
end

--flatten the table
function fastsearch.flatten(t, y)
	for i = 1, #t do
		if type(t[i]) == type({}) then
			y = fastsearch.flatten(t[i], y)
		else
			table.insert(y, t[i])
		end
	end
	return y
end

--split word
function fastsearch.split_word(word)
	local splitted = {}
	word:gsub(".",function(c) table.insert(splitted,c) end)
	return splitted
end

--split sentence
function fastsearch.split_sentence(sentence)
	local splitted_sentence = {}
	for token in string.gmatch(sentence, "[^%s]+") do
		table.insert(splitted_sentence, token)
	end
	return splitted_sentence
end

--right division of vector
function fastsearch.div(v)
	local k = v[1]
	for i = 2, #v do
		k = k/v[i]
	end
	return k
end

--generate the vector
function fastsearch.wv_gen(word)
	local wv = {}
	local splitted = fastsearch.split_word(word)
	for i = 1, #splitted do
		table.insert(wv, fastsearch.com[splitted[i]])
		if i == #splitted then
			for j = 1, (#fastsearch.com - #splitted) do
				table.insert(wv, #fastsearch.com)
			end
		end
	end
	return wv
end

--main method to generate mappings
function fastsearch.create_mappings()
	for i = 1, #fastsearch.data do
		local _id = fastsearch.data[i][1]
		local doc_split = fastsearch.split_sentence(fastsearch.data[i][2])
		for j = 1, #doc_split do
			local word_ = doc_split[j]
			if #word_ > 2 then
				local val = fastsearch.div(fastsearch.wv_gen(word_))
				if fastsearch.t[val] ~= nil then
					table.insert(fastsearch.t[val], _id)
				else
					fastsearch.t[val] = {}
					table.insert(fastsearch.t[val], _id)
				end
				table.insert(fastsearch.sorted_t, val)
			end
		end
	end
	table.sort(fastsearch.sorted_t)
end

--finds the closest friend for the key
function fastsearch.get_friend(value)
	local current_val = math.abs(fastsearch.sorted_t[1] - value)
	local current_item = fastsearch.sorted_t[1]
	for i = 1, #fastsearch.sorted_t do
		if math.abs(fastsearch.sorted_t[i]-value) < current_val then
			current_item = fastsearch.sorted_t[i]
			current_val = math.abs(fastsearch.sorted_t[i]-value)
		end
	end
	return current_item
end

--search/lookup
function fastsearch.search(keyword, multi)
	if multi then
		local temp_ = {}
		local keyword_ = fastsearch.split_sentence(keyword)
		for i = 1, #keyword_ do
			if fastsearch.t[fastsearch.div(fastsearch.wv_gen(keyword_[i]))] ~= nil then
				table.insert(temp_, fastsearch.t[fastsearch.div(fastsearch.wv_gen(keyword_[i]))])
			else
				local val = fastsearch.div(fastsearch.wv_gen(keyword_[i]))
				table.insert(temp_, fastsearch.t[fastsearch.get_friend(val)])
			end
		end
		result = fastsearch.flatten(temp_, {})
	else
		if fastsearch.t[fastsearch.div(fastsearch.wv_gen(keyword))] ~= nil then
			result = fastsearch.t[fastsearch.div(fastsearch.wv_gen(keyword))]
		else
			local val = fastsearch.div(fastsearch.wv_gen(keyword))
			result = fastsearch.t[fastsearch.get_friend(val)]
		end
	end
	return result
end

return fastsearch
