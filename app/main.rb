require 'app/physics.rb'
require 'app/rendering.rb'


def init args
    args.state.stars = []
    args.state.stars << {x: 1920, y: 1080, anchor_x: 0.5, anchor_y: 0.5,
                         w: 12, h: 12, path: "sprites/misc/tiny-star.png",
                         m: 250000}.sprite!
    args.state.stars << {x: 960 + rand(1920), y: 540 + rand(1080), anchor_x: 0.5, anchor_y: 0.5,
                         w: 12, h: 12, path: "sprites/misc/tiny-star.png",
                         m: 250000}.sprite!

    args.state.player =  {x: 400, y: 100, anchor_x: 0.5, anchor_y: 0.5, angle: 0,
                         w: 16, h: 16, path: "sprites/misc/lowrez-ship-blue.png",
                         vx: 0, vy: 1, thrust: 0.01,
                         m: 10}.sprite!
    args.state.camera = {x: 0, y: 0}

    args.state.ships = []
    args.state.ships << args.state.player
    args.state.ships << {x: 1520, y: 2060, anchor_x: 0.5, anchor_y: 0.5, angle: 180,
                         w: 16, h: 16, path: "sprites/misc/lowrez-ship-red.png",
                         vx: 0, vy: -1, thrust: 0.01,
                         m: 10}.sprite!
    args.state.projctiles = []
    generate_background args
end

def handle_inputs args
    if args.inputs.keyboard.left
        args.state.player.angle += 1
    elsif args.inputs.keyboard.right
        args.state.player.angle -= 1
    elsif args.inputs.keyboard.up
        thrust_vector(args.state.player)
    end
end

def calculate_physics args
    args.state.ships.each do |s|
        args.state.stars.each do |center|
            fx,fy = calc_gravity(s, center)
            ax = fx/s.m
            ay = fy/s.m
            s.vx += ax
            s.vy += ay
        end
        s.x += s.vx
        s.y += s.vy

        world_wrap s
    end
end

def world_clamp s
    if s.x <= 8 or s.x >= 3832
        s.x = s.x.clamp(16, 3824)
        s.vx = 0
    end
    if s.y <= 8 or s.y >= 2152
        s.y = s.y.clamp(16, 2144)
        s.vy = 0
    end
end

def world_wrap s
    s.vx = s.vx.clamp(-5, 5)
    s.vy = s.vy.clamp(-5, 5)
    s.x = s.x % 3840
    s.y = s.y % 2160
end

def tick args
    if Kernel.tick_count <= 0
        init args
        #calc_circular_orbit(args.state.player, args.state.center)
    end

    handle_inputs args
    calculate_physics args
    calc_camera args
    render_scene args
    render args
end
