defmodule Minesweeper do

  def get_arr([], _n) do
  []
  end
  
  def get_arr([h|_t], 0) do
    h
  end
  
  def get_arr([_h|t], n) do
    get_arr(t, n-1)
  end

  def update_arr([], _n, v) do
  [v]
  end
  
  def update_arr([_h|t], 0, v) do
    [v|t]
  end
  
  def update_arr([h|t], n, v) do
  [h|update_arr(t, n-1, v)]
  end
  
  def get_pos(tab, l, c) do
    get_arr(get_arr(tab, l), c)
  end
  
  def update_pos(tab, l, c, v) do
    update_arr(tab, l, update_arr(get_arr(tab,l),c,v))
  end
  
  def is_mine(tab, l, c) do
    get_pos(tab, l, c)
  end
  
  def is_valid_pos(tamanho, l, c) do
    cond do
      0<=l and l<tamanho and 0<=c and c<tamanho -> true
      true -> false 
    end
  end
  
  def _valid_moves({l,c},tamanho) do
    is_valid_pos(tamanho, l, c)
  end
  
  def valid_moves(tamanho, l, c) do
  if l<0 or c<0 or l>=tamanho or c>= tamanho do
   IO.puts "Coordenadas inválidas"
  else
    [{l-1,c-1}, {l-1, c}, {l-1, c+1},
  {l, c-1}, {l, c+1},
  {l+1, c-1}, {l+1, c}, {l+1, c+1}]
  |>
    Enum.filter(fn{x,y} -> _valid_moves({x,y},tamanho) end)
  end
  end
  
  def _conta_minas_adj({l, c}, tab) do
    is_mine(tab, l, c)
  end
  
  def conta_minas_adj(tab, l, c) do
    x = length(tab)
    valid_moves(x, l, c)
    |>
    Enum.reduce(0, fn {x, y}, acc ->
      if _conta_minas_adj({x, y}, tab) do
        acc + 1
      else
        acc
      end
    end)
  end
  
  def _abre_jogada({l,c}, minas, tab) do
    abre_jogada(l,c,minas,tab)
  end
    
def abre_jogada(l, c, minas, tab) do
  x = conta_minas_adj(minas, l, c)
  case {is_mine(minas, l, c), get_pos(tab, l, c)} do
    {true, _} -> tab
    {_, '-'} ->
      new_tab = update_pos(tab, l, c, x)
      if x == 0 do
        valid_moves(length(tab), l, c)
        |> Enum.reduce(new_tab, fn {x, y}, acc_tab ->
          abre_jogada(x, y, minas, acc_tab)
        end)
      else
        new_tab
      end
    {_, _} -> tab
  end
end
  
def abre_posicao(tab, minas, l, c) do
  x = get_pos(tab, l, c)
  cond do
    x != '-' -> update_pos(tab, l, c, x)
    is_mine(minas, l, c) -> update_pos(tab, l, c, '*')
    true -> update_pos(tab, l, c, conta_minas_adj(minas, l, c))
  end
end

defp cria_coord(_tab, l, c) when l < 0 or c < 0, do: []
defp cria_coord(tab, l, c) do
  [{l, c} | cria_coord(tab, l, c - 1) ++ cria_coord(tab, l - 1, length(Enum.at(tab, l - 1)) - 1)]
end

def abre_tabuleiro(minas, tab) do
  tab_size = length(tab) - 1
  cria_coord(tab, tab_size, tab_size)
  |> Enum.reduce(tab, fn {l, c}, acc -> abre_posicao(acc, minas, l, c) end)
end
  
  def row_to_string([]), do: ""
  
  def row_to_string(l), do: Enum.join(l, "|")

  def board_to_string([]), do: ""
  
  def board_to_string(board) do
    [h|t] = board
    x = row_to_string(h)
    y = board_to_string(t)
    x<>"\n"<>y
  end

  def gera_lista(1, v) do
    [v]
  end
  def gera_lista(n, v) do
    [v|gera_lista(n-1, v)]
  end
  
  def gera_tabuleiro(n) do
    gera_lista(n,gera_lista(n, '-'))
  end
  
  def gera_mapa_de_minas(n) do
    gera_lista(n,gera_lista(n, false))
  end
  
  def conta_fechadas(tab) do
    Enum.reduce(tab, 0, fn l, acc ->
    acc+conta_fechadas_linhas(l)
    end)
  end

  def conta_fechadas_linhas(l) do
  Enum.reduce(l, 0, fn x, acc -> cond do
  x == '-' -> acc+1
  true -> acc
  end
  end)
  end
  
  def conta_minas(minas) do
  Enum.reduce(minas, 0, fn l, acc ->
    acc + conta_minas_linha(l)
  end)
  end

  def conta_minas_linha(l) do
  Enum.reduce(l, 0, fn x, acc -> cond do 
  x==true -> acc+1
  true -> acc
  end
  end)
  
end


  
  def end_game(minas, tab) do
    cond do
    conta_fechadas(tab) == conta_minas(minas) -> true
    true -> false
    end
  end
end
