Because we have fancy machines with multi-core processors, and nice new shiny browsers
we can use [**`WebWorkers`**][Worker] to run multiple instances of [**`TetrisAI`**][TetrisAI]
in parallel, which allows us to speed up the progress of the genetic algorithm. However, 
a **`Worker`** has a number of restrictions (for instance it cannot access the **`DOM`**). To
get around this, we split out the functionality so that the heavy-lifting is done by the **`Worker`**
and it just reports back to the main thread, which handles the rendering and the distribution of the work.

[Worker]: http://www.whatwg.org/specs/web-apps/current-work/multipage/workers.html
[TetrisAI]: ../docs/TetrisAI.html

## Setup:
___

We first need to import the scripts that we depend on, which is just the combined
**`Tetris`** script and the [**`underscore`**][_] utility library.

[_]: http://underscorejs.org/

    importScripts 'tetris.js', '/libraries/underscore.js'
    
Then we declare some variables which will be accessed from throughout the script.

    _tetris = _chromosomeIndex = null

## Update:
___

The **`update`** function is in charge of reporting the information back to the main thread
(via [**`self.postMessage`**][postMessage]), based on the two possible states of the current game.

[postMessage]: http://www.whatwg.org/specs/web-apps/current-work/multipage/workers.html#dom-dedicatedworkerglobalscope-postmessage

    update = ->
    
### There are still valid moves to be made:

If the **`TetrisAI`** is still playing the game, the whole [**`TetrisGrid`**][TetrisGrid] is
passed back to the main thread for rendering, along with the index of the [**`Chromosome`**][Chromosome]
is the current generation.

[TetrisGrid]: ../docs/TetrisGrid.html
[Chromosome]: ../docs/Chromosome.html

      unless _tetris.gameOver()
        _tetris.makeMove()
        self.postMessage
          func: 'move'
          tetris: _tetris
          index: _chromosomeIndex

### The game is over:

Once the game is finished - which happens when the AI can no longer find a valid more (or it hits the top)
of the **`TetrisGrid`** - the final score is returned to the main thread, and the **`WebWorker`** destroys itself.

      else
        self.postMessage 
          func: 'complete'
          score: _tetris.score
          index: _chromosomeIndex
        self.close()

## Event delegation:
___

In order for the **`Worker`** to know what to do, it needs to be able to handle the different
types of messages that can come from the main thread. We do this by passing a value called **`func`**
with each message. Each different possible value of **`func`** is handled differently:

    handlers =

The first message that comes from the main thread will always have a **`func`** value of **`"evaluateFitness"`**.
This tells us that we can expect to get some information about the current **`Chromosome`**, which will let us 
initialise an instance of **`TetrisAI`** and get to work.

      evaluateFitness: ->
        { chromosome, index} = e.data
        { workerIndex, chromosomeIndex } = index

        _tetris = new TetrisAI(chromosome.genes)
        _chromosomeIndex = chromosomeIndex

        update()

Every message that comes after that will have a **`func`** value of **`"update"`** which means the **`TetrisAI`**
should evaluate and try to make another move.

      update: ->
        update()

Lastly, we need to actually add an event listener so that we can handle any messages that
the **`Worker`** receives from the main thread.

    self.addEventListener 'message', (e) -> do handlers[e.data.func]