
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

def init args
    args.state.center = {x: 640, y: 360, anchor_x: 0.5, anchor_y: 0.5,
                         w: 4, h: 4, path: "sprites/misc/tiny-star.png",
                         m: 25000}.sprite!
    args.state.ships = []
    args.state.ships << {x: 400, y: 100, anchor_x: 0.5, anchor_y: 0.5,
                         w: 16, h: 16, path: "sprites/misc/lowrez-ship-blue.png",
                         vx: 0, vy: 1,
                         m: 10}.sprite!

    args.state.ships << {x: 880, y: 620, anchor_x: 0.5, anchor_y: 0.5, angle: 180,
                         w: 16, h: 16, path: "sprites/misc/lowrez-ship-red.png",
                         vx: 0, vy: -1,
                         m: 10}.sprite!
end

def tick args
    if Kernel.tick_count <= 0
        init args
    end

    args.state.ships.each do |s|
        fx,fy = calc_gravity(s, args.state.center)
        ax = fx/s.m
        ay = fy/s.m
        s.vx += ax
        s.vy += ay

        s.x += s.vx
        s.y += s.vy
    end


    args.outputs.primitives << args.state.center
    args.outputs.primitives << args.state.ships

end
