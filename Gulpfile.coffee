gulp       = require('gulp')
coffeelint = require('gulp-coffeelint')
stylus     = require('gulp-stylus')
uglify     = require('gulp-uglify')

browserify = require('browserify')
coffeeify  = require('coffeeify')
buffer     = require('vinyl-buffer')
vinyl      = require('vinyl-source-stream')
fs         = require('fs')

environmentVars = require './app/coffee/config/environment-vars.coffee'
env = require './app/coffee/config/env.coffee'

# This is a development build
process.env.NODE_ENV = env

### Fonction pour supprimer le repertoire de build sans warnings ###
deleteFolderRecursive = (path) ->
  if fs.existsSync(path)
    fs.readdirSync(path).forEach (file, index) ->
      curPath = path + '/' + file
      if fs.lstatSync(curPath).isDirectory()
        deleteFolderRecursive curPath
      else
        fs.unlinkSync curPath
      return
    fs.rmdirSync path
  return

paths =
  assets: './app/assets/**/*.*'
  app: './app'
  dist: './dist'
  coffeeDir: '/coffee'
  css: './app/css/main.styl'
  mainCoffeeFile: './app/coffee/app.coffee'
  html: './app/index.html'
  coffeeFiles: './app/coffee/*.coffee'
htmlOutput = 'index.html'

### Permet de vérifier le code .coffee ###
gulp.task 'lint', ->
  gulp.src(paths.coffeeFiles).pipe(coffeelint()).pipe(coffeelint.reporter()).pipe coffeelint.reporter('failOnWarning')

### Supprime le repertoire de build ###
gulp.task 'clean', (cb) ->
  deleteFolderRecursive paths.dist
  return

### Copie les 'assets' du jeu ###
gulp.task 'copy-assets', ->
  gulp.src(paths.assets, base: paths.app).pipe gulp.dest(paths.dist)

### Compile le code css (compression) ###
gulp.task 'compile-css', ->
  gulp.src(paths.css).pipe(stylus(compress: true)).pipe gulp.dest(paths.dist)

### Compile le code .coffee en .js (compression) ###
gulp.task 'compile-coffee', ->

  # browserify rend un code qui n'est pas "debuggable"
  if process.env.NODE_ENV == environmentVars.release
    browserify(paths.mainCoffeeFile, debug: false).transform(coffeeify).bundle().pipe(vinyl('main.js')).pipe(buffer()).pipe(uglify(compress: true)).pipe gulp.dest(paths.dist)
  else
    browserify(paths.mainCoffeeFile, debug: true).transform(coffeeify).bundle().pipe(vinyl('main.js')).pipe gulp.dest(paths.dist)

### Copie le fichier html ###
gulp.task 'copy-html', ->
  gulp.src(paths.html).pipe gulp.dest(paths.dist)

### Methodes qui vont etre appellees par npm ###
gulp.task 'build', [
  'clean'
  'copy-assets'
  'compile-css'
  'compile-coffee'
  'copy-html'
]

gulp.task 'default', [ 'clean' ]
