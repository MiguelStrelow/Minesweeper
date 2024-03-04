def get_arr([h|t], 0), do:
h
end

def get_arr([_h|t], n), do:
get_arr([t], n-1)
end

def update_arr([_h|t], 0, v), do:
[v|t]
end

def update_arr([h|t], n, v), do:
[h|update_arr([t], n-1, v)]
end

def get_pos(tab, l, c), do:
  get_arr(get_arr(tab, l), c)
end

def update_pos(tab, l, c, v), do:
  update_arr(get_arr(tab, l), c, v)
end

def is_mine(tab, l, c), do:
  mine = get_pos(tab, l, c)
  if(mine == 0) do
    false
    else
    true
    end
  end

def is_valid_pos(tamanho, l, c), do:
  cond do:
    0<l<=tamanho and 0<c<=tamanho -> true