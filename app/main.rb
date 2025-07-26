
def calc_gravity (m1, m2)
    G = 0.05
    # Calculate the gravitational force between 2 points in a plane
    # Return the X and Y vector components of the force.
    dx = m2.x - m1.x
    dy = m2.y - m1.y
    d2 = dx**2 + dy**2
    d = Math.sqrt(d2)

    f = G * (m1.m * m2.m) / d2
    fx = f * (dx/d)
    fy = f * (dy/d)

    return fx, fy
end

def deg2rad angle
    return angle * (Math::PI / 180)
end

def thrust_vector ship
    # Calculate Thrust in a plane
    # Apply the X and Y vectors to the ship

    # Assume space with the same properties as DragonRuby uses for Sprites
    # 0-degrees:  Positive X
    # Rotation :  Counterclockwise

    # Offset sprite rotation 90 degrees Counterclockwise to account for sprite orientation
    a_rad = deg2rad(ship.angle + 90)

    # Calculate X and Y components of total Thrust vector.
    ship.vx += Math.cos(a_rad) * ship.thrust
    ship.vy += Math.sin(a_rad) * ship.thrust
end

def calc_circular_orbit(ship, star)
    G = 0.05
    dx = ship.x - star.x
    dy = ship.y - star.y
    r = Math.sqrt(dx**2 + dy**2)
    v = Math.sqrt(G * (star.m / r))
    tx = -dy/r
    ty = -dx/r
    ship.vx = tx * v
    ship.vy = ty * v
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

def calc_camera args
    args.state.camera.x = args.state.player.x.clamp(640, 3200)
    args.state.camera.y = args.state.player.y.clamp(360, 1800)
end

def render_scene args
    args.outputs[:scene].transient = true
    args.outputs[:scene].w = 3840
    args.outputs[:scene].h = 2160
    args.outputs[:scene].background_color = [64, 64, 64, 255]
    args.outputs[:scene].primitives << {x:0, y:0, w:3840, h:2160, path: :background }.sprite!
    args.outputs[:scene].primitives << args.state.center
    args.outputs[:scene].primitives << args.state.ships
end

def render args
    out = [
        {x: 0, y: 0, w: 1280, h: 720, path: :scene,
        source_x: args.state.camera.x-640, source_y: args.state.camera.y-360,
        source_w: 1280, source_h: 720}.sprite!
    ]
    args.outputs.primitives << out
end

def init args
    args.state.center = {x: 1920, y: 1080, anchor_x: 0.5, anchor_y: 0.5,
                         w: 4, h: 4, path: "sprites/misc/tiny-star.png",
                         m: 100000}.sprite!

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
    generate_background args
end

def tick args
    if Kernel.tick_count <= 0
        init args
        #calc_circular_orbit(args.state.player, args.state.center)
    end

    if args.inputs.keyboard.left
        args.state.player.angle += 1
    elsif args.inputs.keyboard.right
        args.state.player.angle -= 1
    elsif args.inputs.keyboard.up
        thrust_vector(args.state.player)
    end

    args.state.ships.each do |s|
        fx,fy = calc_gravity(s, args.state.center)
        ax = fx/s.m
        ay = fy/s.m
        s.vx += ax
        s.vy += ay

        s.x += s.vx
        s.y += s.vy

        if s.x <= 8 or s.x >= 3832
            s.x = s.x.clamp(16, 3824)
            s.vx = 0
        end
        if s.y <= 8 or s.y >= 2152
            s.y = s.y.clamp(16, 2144)
            s.vy = 0
        end
    end

    calc_camera args
    render_scene args
    render args

end
