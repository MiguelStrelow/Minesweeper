defmodule Teste do
def teste() do
tab = [['-','-','-','-'],['-','-','-','-'],['-','-','-','-'],['-','-','-','-']]
mines = [
  [true, false, false, false],
  [true, true, false, false],
  [false, false, true, false],
  [false, false, false, false]
]

Minesweeper.is_mine(mines, 0, 0)
end
end

