class Tetrimino
  constructor: (@colour, plus = 1, minus = 1, @rotation = 0) ->
    @offset = { plus, minus }
    @domain = TetrisGrid.CreateDomain this

class I extends Tetrimino
  constructor: ->
    @shape = [[[0,0,0,0],
               [1,1,1,1],
               [0,0,0,0],
               [0,0,0,0]],
              [[0,1,0,0],
               [0,1,0,0],
               [0,1,0,0],
               [0,1,0,0]]]
    super 1, 2

class J extends Tetrimino
  constructor: ->
    @shape = [[[0,0,0],
               [1,1,1],
               [0,0,1]],
              [[0,1,0],
               [0,1,0],
               [1,1,0]],
              [[1,0,0],
               [1,1,1],
               [0,0,0]],
              [[0,1,1],
               [0,1,0],
               [0,1,0]]]
    super 2

class L extends Tetrimino
  constructor: ->
    @shape = [[[0,0,0],
               [1,1,1],
               [1,0,0]],
              [[1,1,0],
               [0,1,0],
               [0,1,0]],
              [[0,0,1],
               [1,1,1],
               [0,0,0]],
              [[0,1,0],
               [0,1,0],
               [0,1,1]]]
    super 3

class O extends Tetrimino
  constructor: ->
    @shape = [[[1,1],
              [1,1]]]
    super 4, 1, 0

class S extends Tetrimino
  constructor: ->
    @shape = [[[0,0,0],
               [0,1,1],
               [1,1,0]],
              [[1,0,0],
               [1,1,0],
               [0,1,0]],
              [[0,1,1],
               [1,1,0],
               [0,0,0]],
              [[0,1,0],
               [0,1,1],
               [0,0,1]]]
    super 5

class T extends Tetrimino
  constructor: ->
    @shape = [[[0,0,0],
               [1,1,1],
               [0,1,0]],
              [[0,1,0],
               [1,1,0],
               [0,1,0]],
              [[0,1,0],
               [1,1,1],
               [0,0,0]],
              [[0,1,0],
               [0,1,1],
               [0,1,0]]]
    super 6

class Z extends Tetrimino
  constructor: ->
    @shape = [[[0,0,0],
               [1,1,0],
               [0,1,1]],
              [[0,1,0],
               [1,1,0],
               [1,0,0]],
              [[1,1,0],
               [0,1,1],
               [0,0,0]],
              [[0,0,1],
               [0,1,1],
               [0,1,0]]]
    super 7

(exports ? @).TetriminoBag = class TetriminoBag
  constructor: ->
    @_ =
      bag: [new I, new J, new L, new O, new S, new T, new Z]
      nextBag: []

  getNext: ->
    if @_.bag.length is 0
      @_.bag = @_.nextBag
      @_.nextBag = []
    select = Math.floor(Math.random() * @_.bag.length)
    selected = (@_.bag.splice(select, 1))[0]
    @_.nextBag.push selected
    selected