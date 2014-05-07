canvas = document.getElementById("keys")

canvas.width = document.body.clientWidth * 0.988
canvas.height = document.body.clientHeight * 0.4

d = null
if canvas.getContext
    d = canvas.getContext("2d")

current_frame = 0
max_frame = 100
cursor_control = false
paused = true
keys = []
window.k = keys

editor = ace.edit("editor_div")
start_editor = () ->
    document.getElementById("editor_div").style.display = "block"
    document.getElementById("save").style.display = "block"
    document.getElementById("cancel").style.display = "block"
    goto_cursor()

stop_editor = () ->
    document.getElementById("editor_div").style.display = "none"
    document.getElementById("save").style.display = "none"
    document.getElementById("cancel").style.display = "none"
    editor.setValue("")
    editor.gotoLine(1)

save_key = () ->
    # compare mouse_start to mouse_pos
    x_diff = mouse_end.x - mouse_start.x
    y_diff = mouse_end.y - mouse_start.y
    distance = Math.sqrt(x_diff * x_diff + y_diff * y_diff)

    range = 0
    if distance > 10
        range = x_to_frame(mouse_end.x) - x_to_frame(mouse_start.x)

    key = {
        frame: x_to_frame(mouse_start.x),
        range: range,
        script: editor.getValue()
    }
    keys.push(key)

draw_line = (p1, p2) ->
    d.beginPath()
    d.moveTo(p1.x, p1.y)
    d.lineTo(p2.x, p2.y)
    d.stroke()

point = (x, y) ->
    { x: x, y: y }

frame_to_x = (frame) ->
    percent = frame / max_frame
    10 + percent * (canvas.width - 20)

x_to_frame = (x) ->
    adj = x - 10

    if adj < 0
        adj = 0

    percent = adj / (canvas.clientWidth - 20)
    Math.floor(percent * max_frame)

draw_time_divisions = () ->
    for frame in [0..100] by 10
        line_x = frame_to_x(frame)
        d.lineWidth = 1
        draw_line(point(line_x, 0), point(line_x, canvas.height))

draw_keys = () ->
    for i in [0...keys.length]
        key = keys[i]

        # TODO fix overlap detection
        overlaps = 0
        for j in [0...i]
            if key.frame >= keys[j].frame and key.frame <= (keys[j].frame + keys[j].range)
                overlaps += 1

        y = overlaps * 21 + 10
        if key.range == 0
            draw_circle(key.frame, y)
        else
            draw_rectangle(key.frame, y, key.range)

draw_circle = (frame, y) ->
    x = frame_to_x(frame)

    d.beginPath()
    d.arc(x, y, 7, 0, 2 * Math.PI, false)
    d.fillStyle = '#ffffff'
    d.fill()
    d.lineWidth = 2
    d.stroke()

draw_rectangle = (frame, y, range) ->
    x = frame_to_x(frame)
    y = y - 7

    width = frame_to_x(frame + range) - x
    height = 14
    radius = 7

    d.beginPath()
    d.moveTo(x + radius, y)
    d.lineTo(x + width - radius, y)
    d.quadraticCurveTo(x + width, y, x + width, y + radius)
    d.lineTo(x + width, y + height - radius)
    d.quadraticCurveTo(x + width, y + height, x + width - radius, y + height)
    d.lineTo(x + radius, y + height)
    d.quadraticCurveTo(x, y + height, x, y + height - radius)
    d.lineTo(x, y + radius)
    d.quadraticCurveTo(x, y, x + radius, y)
    d.closePath()

    d.fillStyle = '#ffffff'
    d.fill()
    d.lineWidth = 2
    d.stroke()

update_frame_pointer = () ->
    document.getElementById("frame-counter").innerText = current_frame
    line_x = frame_to_x(current_frame)
    d.lineWidth = 3
    draw_line(point(line_x, 0), point(line_x, canvas.height))

clear_canvas = () ->
    d.save()

    d.setTransform(1, 0, 0, 1, 0, 0)
    d.clearRect(0, 0, canvas.width, canvas.height)

    d.restore()

goto_cursor = () ->
    current_frame = x_to_frame(mouse_pos.x)
    update_frame_pointer()
    handle_current_frame(false)

update = () ->
    window.frame = current_frame
    clear_canvas()
    draw_time_divisions()
    update_frame_pointer()
    draw_keys()

    if cursor_control
        goto_cursor()
    else
        if !paused
            handle_current_frame(true)

    setTimeout(update, 40)

handle_current_frame = (adv) ->
    # look in keys array for stuff
    for key in keys
        if current_frame >= key.frame and current_frame <= (key.frame + key.range)
            PLT.parser.parse(key.script)

    # only advance frame if animation is NOT paused
    if adv
        if current_frame == max_frame
            current_frame = 0
        else
            current_frame++

toggle_play = () ->
    toggle_button = document.getElementById("toggle")
    paused = !paused
    if paused
        toggle_button.innerHTML = "play"
    else
        toggle_button.innerHTML = "pause"

document.getElementById("toggle").onclick = toggle_play
document.getElementById("cancel").onclick = stop_editor

document.getElementById("undo").onclick = () ->
    keys.pop()

document.getElementById("reset").onclick = () ->
    keys = []

down = false
mouse_start = point(0, 0)
canvas.onmousedown = () ->
    down = true
    mouse_start = mouse_pos

mouse_end = point(0, 0)
canvas.onmouseup = () ->
    down = false
    mouse_end = mouse_pos
    start_editor()

document.getElementById("save").onclick = () ->
    save_key()
    stop_editor()

document.onkeydown = (e) ->
    if e.keyCode == 91
        cursor_control = true

document.onkeyup = (e) ->
    if e.keyCode == 91
        cursor_control = false

mouse_pos = point(0, 0)
canvas.addEventListener('mousemove', (e) ->
    rect = canvas.getBoundingClientRect()
    mouse_pos = point(e.clientX - rect.left, e.clientY - rect.top)
, false)

init = () ->
    update()

init()
