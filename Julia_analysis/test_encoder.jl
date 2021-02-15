cd("/Users/adrienpajon/Documents/all.nosync/git_repo/pulse_analysis/2020-11-12 xp pulse all seuil/Julia_analysis")

using CSV

using DataFrames

using Plots

using StatsPlots

include("./functions/rectangle.jl")

#using Pyplot
#pyplot()

#Encoder's resolutio
Encoder_mm_per_Pulse = 0.02

#experiment number
experiment = "03"
speed = "3"

#read CSV of encoder logger file
Encoder = CSV.read(
    string("../measures/xp_pulse_all_seuil/encoder/20201119_gel_1cm/Logger_encoder_gel_1cm_v",speed,"_", experiment, ".txt");
    header = 1,
)

#convert the number of pulse position change into mm
Encoder.PositionChange_mm = Encoder." PositionChange" * Encoder_mm_per_Pulse

#convert the detected time of change into from ms to s
#WARNING sometime the encoder is disconnected and we lose measures
#you can track those deconnection by looking at TimeChange==0ms
#As we don't know the time duration of deconnection, I added 1s delay
time = cumsum(Encoder." TimeChange" + (Encoder." TimeChange" .== 0) .* 1000) / 1000

#plot the encoder velocity in time
plot_Encoder = plot(
    time,
    Encoder.PositionChange_mm ./ Encoder." TimeChange",
    xlabel = "time[s]",
    ylabel = "Velocity[m/s]",
    label = "Velocity",
    title = string("velocity and position of experiment ", experiment),
    xlims = (42.5,43.5)
)

#draws 1s grey rectangle during unknown deconnection duration
for k in findall(x -> x == 0, Encoder." TimeChange")
    if k == 1
        plot_Encoder = plot!(
            rectangle(time[k+1] - time[k], 2, time[k], 0),
            color = :grey,
            label = "unknown timing",
        )
    elseif k != size(time)
        if k == findfirst(x -> x == 0, Encoder." TimeChange")
            plot_Encoder = plot!(
                rectangle(time[k+1] - time[k-1], 2, time[k-1], 0),
                color = :grey,
                label = "unknown timing",
            )
        elseif k != findlast(x -> x == 0, Encoder." TimeChange")
            plot_Encoder = plot!(
                rectangle(time[k+1] - time[k-1], 2, time[k-1], 0),
                color = :grey,
                label = false,
            )
        end
    end
end

# #add driven distance in front of the velocity
# #add right y axis
# #WARNING the right axis is only visible in the pdf image, not in the Juno Plots interface
# plot_Encoder=plot!(twinx(),
#     time,
#     cumsum(Encoder.PositionChange_mm./1000),
#     color=:red,
#     ylabel = "Position[m]",
#     label = "Position")
plot_Encoder
#save the plot
#savefig(plot_Encoder, string("save_figure/velocity/velocity_", experiment, ".pdf"))
