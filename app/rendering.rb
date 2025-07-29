def calc_camera args
    args.state.camera.x = args.state.player.x.clamp(640, 3200)
    args.state.camera.y = args.state.player.y.clamp(360, 1800)
end

def generate_background args
    args.outputs[:background].w = 3840
    args.outputs[:background].h = 2160
    args.outputs[:background].background_color = [0, 0, 0, 255]
    5000.times do
        x = rand(3840)
        y = rand(2160)
        args.outputs[:background].primitives << {x: x, y: y, w: 4, h: 4,
                                                 r: rand(255), g: rand(255), b: rand(255),
                                                 path: "sprites/misc/star.png"}
    end
end

def render_scene args
    args.outputs[:scene].transient = true
    args.outputs[:scene].w = 3840
    args.outputs[:scene].h = 2160
    args.outputs[:scene].background_color = [64, 64, 64, 255]
    args.outputs[:scene].primitives << {x:0, y:0, w:3840, h:2160, path: :background }.sprite!
    args.outputs[:scene].primitives << args.state.stars
    args.outputs[:scene].primitives << args.state.ships
    args.outputs[:scene].primitives << args.state.projectiles

end

def render args
    out = [
        {x: 0, y: 0, w: 1280, h: 720, path: :scene,
        source_x: args.state.camera.x-640, source_y: args.state.camera.y-360,
        source_w: 1280, source_h: 720}.sprite!
    ]
    args.outputs.primitives << out
end
