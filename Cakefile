{spawn, exec} = require 'child_process'
fs = require 'fs'
path = require 'path'

PROJECT_ROOT = path.dirname fs.realpathSync __filename

task 'compile', 'compile tetris', ->
  console.log 'Running CoffeeScript compile for projects...'
  console.log 'Compiling Tetris:'
  exec 'coffee -o javascript -c coffeescript/tetris.litcoffee'
  exec 'coffee -o javascript -c coffeescript/tetrisWorker.litcoffee'
  tetrisFiles = ['tetrisAI', 'tetrisGrid', 'tetrominoes']
  tetrisFiles = ("coffeescript/#{tetrisFile}.litcoffee" for tetrisFile in tetrisFiles)
  exec "coffee -j javascript/src.js -c #{tetrisFiles.join ' '}"
  console.log "coffee -j javascript/src.js -c #{tetrisFiles.join ' '}"
  console.log 'Done Tetris compile.'

task 'uglify', 'minify and compress', ->
  console.log 'Minifying and compressing Tetris:'
  exec 'uglifyjs "javascript/src.js" -o "javascript/src.min.js" -c'
  exec 'uglifyjs "javascript/tetris.js" -o "javascript/tetris.min.js" -c'
  exec 'uglifyjs "javascript/tetrisWorker.js" -o "javascript/tetrisWorker.min.js" -c'

task 'docco', 'create documentation', ->
  exec 'docco coffeescript/tetrisWorker.litcoffee -l linear'

task 'all', 'build everything', ->
  invoke 'compile'
  invoke 'uglify'
  invoke 'docco'