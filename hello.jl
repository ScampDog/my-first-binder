using Pkg
Pkg.add("ControlSystems")
using ControlSystems

# First Order Response
τ=1.0 # time constant
G_first = zpk([], [-τ], τ) # Generic first order system
y, t, x = step(G_first) # find the step response
t_10 = -log(0.9)
t_90 = -log(0.1)
Ts = -log(0.02)
stepplot(G_first, label = "System response") # plot the step response
title!("First Order System")
xlabel!("Normalized time, t/τ")
# note when response reaches 10% and 90% of steady state...
scatter!([t_10 t_90], [0.1 0.9], shape=[:+], label="") 
plot!([t_10, t_10], [0.0, 1.0], label="", linestyle=:dot)
plot!([t_90, t_90], [0.0, 1.0], label="", linestyle=:dot)
# This is the rise time!
plot!([t_10, t_90], [0.5, 0.5], linestyle=:dot, label="Rise time, 2.2τ", arrow = :both)
# now display the settling time, when the response gets within 2% of the steady state
plot!([Ts, Ts], [0.0, 1.0], linestyle = :dot, label="Settling time, 3.9τ")
plot!([0.0, 6.0], [0.98, 0.98], linestyle = :dot, label="y=0.98")

# Second Order Response
ζ = 0.25
ω = 1.0
Tf = 25
G_second = tf(1.0, [1.0, 2ζ*ω, ω^2])
y, t, x = step(G_second, Tf)
peak_response = findmax(y)
t_peak = t[peak_response[2]]
y_peak = peak_response[1]
stepplot(G_second, Tf, label = "System response")
plot!(t_bounds, [1.0, 1.0], label = "set point")
plot!(t_bounds, [0.98, 0.98], linestyle = :dot, label="set point ±2%")
plot!(t_bounds, [1.02, 1.02], linestyle = :dot, label="")
scatter!([t_peak], [y_peak], shape = [:x], label = "Peak of 1.44 at 3.22s")
title!("Second order step response, ζ=0.25")

# SunDyne heat exchanger example
τ = 1.25 # time constant
K_process = 2.5/(0.5/16*100)       # Process gain, change in T from valve change
G_hx = tf(K_process, [τ, 1])       # Transfer function of heat exchanger
z_location = -3.0   # controller zero location, an arbitrary choice for the moment
C_pi = zpk([z_location], [0], 1)   # PI controller
rlocusplot(series(C_pi, G_hx), xlims = (-8, 1), title="") # Keynote will provide the title
