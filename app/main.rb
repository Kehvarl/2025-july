
def calc_gravity (m1, m2)
    G = 0.05
    dx = m2.x - m1.x
    dy = m2.y - m1.y
    d2 = dx**2 + dy**2
    d = Math.sqrt(d2)

    f = G * (m1.m * m2.m) / d2
    fx = f * (dx/d)
    fy = f * (dy/d)

    return fx, fy
end

def thrust_vector ship
    a_rad = (ship.angle + 90)   / 180 * 3.14

    ship.vx += Math.cos(a_rad) * ship.thrust
    ship.vy += Math.sin(a_rad) * ship.thrust
end

def init args
    args.state.center = {x: 640, y: 360, anchor_x: 0.5, anchor_y: 0.5,
                         w: 4, h: 4, path: "sprites/misc/tiny-star.png",
                         m: 25000}.sprite!

    args.state.player =  {x: 400, y: 100, anchor_x: 0.5, anchor_y: 0.5, angle: 0,
                         w: 16, h: 16, path: "sprites/misc/lowrez-ship-blue.png",
                         vx: 0, vy: 1, thrust: 0.01,
                         m: 10}.sprite!

    args.state.ships = []
    args.state.ships << args.state.player
    args.state.ships << {x: 880, y: 620, anchor_x: 0.5, anchor_y: 0.5, angle: 180,
                         w: 16, h: 16, path: "sprites/misc/lowrez-ship-red.png",
                         vx: 0, vy: -1, thrust: 0.01,
                         m: 10}.sprite!
end

def tick args
    if Kernel.tick_count <= 0
        init args
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

        if s.x <= 8 or s.x >= 1272
            s.x = s.x.clamp(16, 1264)
            s.vx = 0
        end
        if s.y <= 8 or s.y >= 712
            s.y = s.y.clamp(16, 704)
            s.vy = 0
        end
    end


    args.outputs.primitives << args.state.center
    args.outputs.primitives << args.state.ships

end
