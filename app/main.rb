
def dist(m1, m2)
    dx = abs(m1.x - m2.x)
    dy = abs(m1.y - m2.y)
    return Math.sqrt(dx^2 + dy^2)
end

def calc_gravity (m1, m2)
    G = 6.674e-11
    d = dist(m1, m2)
    return G * ((m1.m * m2.m)/d^2)
end

def init args
    args.state.center = {x: 640, y: 360, anchor_x: 0.5, anchor_y: 0.5,
                         w: 4, h: 4, path: "sprites/misc/tiny-star.png",
                         m: 5.0e30}.sprite!
    args.state.ship = {x: 400, y: 100, anchor_x: 0.5, anchor_y: 0.5,
                       w: 16, h: 16, path: "sprites/misc/lowrez-ship-blue.png",
                       m: 10}.sprite!
end

def tick args
    if Kernel.tick_count <= 0
        init args
    end

    dx = 0
    if inputs.keyboard.left
        dx = -3
    elsif inputs.keyboard.right
        dx =  3
    end

    dy = 0
    if inputs.keyboard.up
        dy =  3
    elsif inputs.keyboard.down
        dy = -3
    end

    args.outputs.primitives << args.state.center
    args.outputs.primitives << args.state.ship

end
