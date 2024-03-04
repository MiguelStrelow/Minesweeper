def get_arr([h|t], 0), do:
h
end

def get_arr([_h|t], n), do:
get_arr([t], n-1)
end