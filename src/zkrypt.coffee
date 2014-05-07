stage = new PIXI.Stage 0xc5fcea

w = document.getElementById("viewer").clientWidth
h = document.getElementById("viewer").clientHeight

renderer = new PIXI.WebGLRenderer w, h, null, null, true
graphics = new PIXI.Graphics
drawing_renderer = new UTIL.renderer(graphics, w, h)
window.r = drawing_renderer

noise.seed(Math.random())

actor = null
init = () ->
    document.getElementById("viewer").appendChild(renderer.view)

    actor = new UTIL.geometry_2d().regular_polygon(4)
    window.actor = actor
    actor.reset_state()
    drawing_renderer.world.add(actor)

    stage.addChild graphics
    setInterval render_graphics, 60

render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274

    drawing_renderer.render_world()
    renderer.render stage

init()
