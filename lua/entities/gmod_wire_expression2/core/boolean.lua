registerType("boolean", "b", false,
	nil,
	nil,
	nil,
	function(v)
		return not isbool(v)
	end
)

registerOperator("as", "b=n", "n", function(self, b)
	return b and 1 or 0
end, 1, nil, { legacy = false })

registerOperator("as", "n=b", "b", function(self, n)
	return n ~= 0
end, 1, nil, { legacy = false })

e2function string boolean:toString()
	return tostring(this)
end