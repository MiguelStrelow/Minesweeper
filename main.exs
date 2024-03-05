defmodule Minesweeper do
  
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
      true -> false 
    end
  end
  
  def _valid_moves({l,c},tamanho), do:
    is_valid_pos(tamanho, l, c)
  end
  
  def valid_moves(tamanho, l, c), do:
    [{l-1,c-1}, {l-1, c}, {l-1, c+1},
  {l, c-1}, {l, c+1},
  {l+1, c-1}, {l+1, c}, {l+1, c+1}]
  |>
    Enum.filter(_valid_moves(tamanho))
    
  end
  
  def _conta_minas_adj({l, c}, tab), do:
    is_mine(tab, l, c)
  end
  
  def conta_minas_adj(tab, l, c), do:
    {x, y} = Matrix.size(tab)
    valid_moves(x, l, c)
    |>
    Enum.reduce(_conta_minas_adj(tab))
  end
  
  def _abre_jogada({l,c}, minas, tab), do:
    abre_jogada(l,c,minas,tab)
  end
    
  def abre_jogada(l,c,minas,tab), do:
    cond do:
      is_mine(minas, l, c) -> ""
  
      get_pos(tab, l, c) != '-' -> ""
  
      x = conta_minas_adj(minas, l, c) > 0 -> update_pos(tab, l, c, x)
  
      x == 0 -> 
      update_pos(tab, l, c, x) 
      Matrix.size(tab)|>
      valid_moves(l, c)|>
      Enum.map(_abre_jogada(minas, tab))
      end
      end
  
  def abre_posicao(tab,minas,l,c), do
    cond do:
      get_pos(tab, l, c) != '-' -> ""
      is_mine(minas, l, c) -> update_pos(tab, l, c, '*')
      get_pos(tab, l, c) == '-' -> update_pos(tab, l, c, conta_minas_adj(minas, l, c)) 
    end
  end
  
  def cria_coord(tab, l, c), do:
    [{l, c}|cria_tab(tab, l-1, c)]
  end
  
  def cria_coord(tab, 0, c), do:
    [{0,c}|cria_tab(tab, Matrix.size(tab), c-1)]
  end
  
  def cria_coord(tab, 0, 0), do:
    {0,0}
  
  def _abre_tabuleiro({l, c}, minas, tab), do:
    abre_posicao(tab, minas, l, c)
  end
  
  def abre_tabuleiro(minas, tab), do:
    {size, _} = Matrix.size(tab)
    cria_coord(tab, size, size)|>
    Enum.map(_abre_tabuleiro({l, c}, minas, tab))
  end
  
  def board_to_string(tab), do:
    {size, _} = Matrix.size(tab)
    cria_coord(tab, size, size)|>
    Enum.map(get_pos(tab, l, c))
  end
  
  def gera_lista(0, v), do:
    v
  end
  def gera_lista(n, v), do:
    [v|gera_lista(n-1, v)]
  end
  
  def gera_tabuleiro(n), do:
    gera_lista(n,gera_lista(n, '-'))
  end
  
  def gera_mapa_de_minas(n), do:
    gera_lista(n,gera_lista(n, false))
  end
  
  def conta_fechadas(tab), do:
    Enum.reduce(tab, 0, fn x -> x == '-')
  end
  
  def conta_minas(minas), do:
    Enum.reduce(minas, 0, fn x -> x == true)
  end
  
  def end_game(minas, tab), do:
    cond do:
    conta_fechadas == conta_minas -> true
    true -> false
  end
end

defmodule Motor do
  def main() do
   v = IO.gets("Digite o tamanho do tabuleiro: \n")
   {size,_} = Integer.parse(v)
   minas = gen_mines_board(size)
   IO.inspect minas
   tabuleiro = Minesweeper.gera_tabuleiro(size)
   game_loop(minas,tabuleiro)
  end
  def game_loop(minas,tabuleiro) do
    IO.puts Minesweeper.board_to_string(tabuleiro)
    v = IO.gets("Digite uma linha: \n")
    {linha,_} = Integer.parse(v)
    v = IO.gets("Digite uma coluna: \n")
    {coluna,_} = Integer.parse(v)
    if (Minesweeper.is_mine(minas,linha,coluna)) do
      IO.puts "VOCÊ PERDEU!!!!!!!!!!!!!!!!"
      IO.puts Minesweeper.board_to_string(Minesweeper.abre_tabuleiro(minas,tabuleiro))
      IO.puts "TENTE NOVAMENTE!!!!!!!!!!!!"
    else
      novo_tabuleiro = Minesweeper.abre_jogada(linha,coluna,minas,tabuleiro)
      if (Minesweeper.end_game(minas,novo_tabuleiro)) do
          IO.puts "VOCÊ VENCEU!!!!!!!!!!!!!!"
          IO.puts Minesweeper.board_to_string(Minesweeper.abre_tabuleiro(minas,novo_tabuleiro))
          IO.puts "PARABÉNS!!!!!!!!!!!!!!!!!"
      else
          game_loop(minas,novo_tabuleiro)
      end
    end
  end
  def gen_mines_board(size) do
    add_mines(ceil(size*size*0.15), size, Minesweeper.gera_mapa_de_minas(size))
  end
  def add_mines(0,_size,mines), do: mines
  def add_mines(n,size,mines) do
    linha = :rand.uniform(size-1)
    coluna = :rand.uniform(size-1)
    if Minesweeper.is_mine(mines,linha,coluna) do
      add_mines(n,size,mines)
    else
      add_mines(n-1,size,Minesweeper.update_pos(mines,linha,coluna,true))
    end
  end
end

Motor.main()