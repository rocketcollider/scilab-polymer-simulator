radius = 1
dR = 0.1
dt = 0.1
omega = 0.1 * %pi

//Define basic geometrics:
function[vector]=vectoR(pars,par)
    unit=ones(squeeze(pars(:,1,:)))
    r=pars
    r(:,1,:)=unit * diag(par(:,1))-squeeze(pars(:,1,:))
    r(:,2,:)=unit * diag(par(:,2))-squeeze(pars(:,2,:))
    r(:,3,:)=unit * diag(par(:,3))-squeeze(pars(:,3,:))
    vector=r
endfunction

function[commuted]=commutator(A, B)
    commuted =  A*B - B*A
endfunction

function[dist]=distances(par)
    len = size(par)
    unit = ones(len(1), len(1))
    permutations = zeros(len(1), len(2), len(1))
    for i = 1:len(2)
        //Can be done since unit is a square matrix!
        permutations(:,i,:) = commutator(unit, diag(par(:,i)))
    end
    dist = permutations
endfunction

function [distributed] = gaussian(s)
    //TO BE IMPLEMENTED
endfunction

//potentials:
function [force] = parForce(r)
    absDist = sqrt(squeeze(sum(r.^2, 2)))
    potForce = gaussian(absDist)
    ret = zeros(r)
    for i=1:3
        ret(:,i,:) = squeeze(r(:,i,:)) ./ absDist .* potForce
    end

    force = ret
endfunction

// spherical cavity!
function [force] = extForce(par, t)
    Rnew = R + sin(omega*t)*dR
    absDist = sqrt(squeeze(sum(par.^2, 2)))
    toofar = absDist > Rnew
    F = zeros(par)
    F(tooFar, :) = par(tooFar, :)-Rnew./absDist(tooFar,:)/dt
    force = F
endfunction

//simulation function:
function[iteration]=step(previous, current)
    time = current * dt
    r = distances(permPar, previous)
    v = parForce(r) + extForce(previous, current*dt) + random()
    posNew = previous + v*dt
    iteration = posNew
endfunction

timeseries = (particleNumber, 3, 100) // lastNumber = Number of steps!
function [data] = simulation(start)
    previous = start
    for i = 1 : 100
        new = step(previous, i*dt)
        // TO BE IMPLEMENTED:
        // measure (function to measure density)
        // collect (object to store measured values)
        //collect(:,:,i)=measure(new)
        timeseries(:,:,i) = new
        previous = new
    end
endfunction
