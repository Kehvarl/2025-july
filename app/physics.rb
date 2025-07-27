# Newtonian Physics in a 2d Plane

def deg2rad angle
    return angle * (Math::PI / 180)
end

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
