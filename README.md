# keyframed procedural animation with web renderer

======

don't bother building if you don't want. [test here](http://evanmoore.no-ip.org/itp/zkrypt/zkrypt.html)

## requirements

* [noize renderer](http://github.com/2emoore4/noize)
* [node.js](http://nodejs.org/)
* [coffeescript](http://coffeescript.org/)
* some js libraries
  * from root directory, `mkdir third_party`
  * need some scripts in this directory. find the versions I'm using [here](http://evanmoore.no-ip.org/itp/zkrypt/third_party/)

## compiling
from root directory, `coffee -m --compile --output lib/ src/`

to watch for changes in source files, and compile automatically, `coffee --watch -m --compile --output lib/ src/`

## testing
the app is located in `zkrypt.html`

unless you want to disable your browser's same-origin policy, then use the development web server in the `server/` directory

from `server/`...

* `npm install` (this installs dependencies from `package.json`)
* `node server.js` (this starts the server on port 8888)

now you can use the application at [localhost:8008/zkrypt.html](localhost:8008/zkrypt.html)

I don't have any documentation yet. click or drag on the timeline to create a keyframe. a window will appear where you can write some lispy code (look in lang.js to figure out how the language works). if the app freezes on a keyframe, there was probably a syntax error, check the console.
