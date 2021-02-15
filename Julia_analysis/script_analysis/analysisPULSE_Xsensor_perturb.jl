cd("/Users/adrienpajon/Documents/all.nosync/git_repo/pulse_analysis/2020-11-12 xp pulse all seuil/Julia_analysis")

using Plots

using StatsPlots

using JLD

# using Pyplot
pyplot()

include("../functions/analysisPULSE.jl")

####################################################################
gel=load("results/PULSE_analysis_gel.jld")
pleine=load("results/PULSE_analysis_pleine.jld")
pneu=load("results/PULSE_analysis_pneu.jld")

filenameXsensor=[gel["filenameXsensor"];pleine["filenameXsensor"];pneu["filenameXsensor"]]
Energysignal_Xsensor_seat=merge(gel["Energysignal_Xsensor_seat"],pleine["Energysignal_Xsensor_seat"],pneu["Energysignal_Xsensor_seat"])
rms_Xsensor_seat=merge(gel["rms_Xsensor_seat"],pleine["rms_Xsensor_seat"],pneu["rms_Xsensor_seat"])
vdv_Xsensor_seat=merge(gel["vdv_Xsensor_seat"],pleine["vdv_Xsensor_seat"],pneu["vdv_Xsensor_seat"])
crest_factor_Xsensor_seat=merge(gel["crest_factor_Xsensor_seat"],pleine["crest_factor_Xsensor_seat"],pneu["crest_factor_Xsensor_seat"])
std_Xsensor_seat=merge(gel["std_Xsensor_seat"],pleine["std_Xsensor_seat"],pneu["std_Xsensor_seat"])
min_Xsensor_seat=merge(gel["min_Xsensor_seat"],pleine["min_Xsensor_seat"],pneu["min_Xsensor_seat"])
max_Xsensor_seat=merge(gel["max_Xsensor_seat"],pleine["max_Xsensor_seat"],pneu["max_Xsensor_seat"])
range_Xsensor_seat=merge(gel["range_Xsensor_seat"],pleine["range_Xsensor_seat"],pneu["range_Xsensor_seat"])

splitName,
plot_order,
perturbLabel,
perturbLabel_unique,
perturbIndices,
wheelType,
wheelLabel_unique,
wheelIndices=splitFileName(filenameXsensor)

bool_perturb_choice="4cm"#"3cm"
bool_perturb=perturbLabel.==bool_perturb_choice

filenameXsensor_=filenameXsensor[bool_perturb]

splitName,
plot_order,
perturbLabel,
perturbLabel_unique,
perturbIndices,
wheelType,
wheelLabel_unique,
wheelIndices=splitFileName(filenameXsensor_,0,0.05)

include("../functions/analysisPULSE.jl")
plotAnalysisPULSE_All(
        Energysignal_Xsensor_seat,
        rms_Xsensor_seat,
        vdv_Xsensor_seat,
        crest_factor_Xsensor_seat,
        filenameXsensor_,
        "Xsensor",
        wheelLabel_unique,
        plot_order,
        wheelIndices,
        [:blue :red :green :orange :yellow],
        [:rect :rect :rect :rect :circle],
        string("\n","perturbation : ",bool_perturb_choice))

include("../functions/analysisPULSE.jl")
plotAnalysisPULSE_All_2(
            std_Xsensor_seat,
            min_Xsensor_seat,
            max_Xsensor_seat,
            range_Xsensor_seat,
            filenameXsensor_,
            "Xsensor",
            ["x";"y"],
            wheelLabel_unique,
            plot_order,
            wheelIndices,
            [:blue :red :green :orange :yellow],
            [:rect :rect :rect :rect :circle],
            string("\n","perturbation : ",bool_perturb_choice))

println("PULSE Analysis Finished")

# using JLD
# save("results/PULSE_analysis_gel.jld",
#         "filenameXsensor_seat",filenameXsensor_seat,
#         "sensorXsensNames",sensorXsensNames,
#         "step_max_perturb_Xsensor_seat",step_max_perturb_Xsensor_seat,
#         "Energysignal_Xsensor_seat",Energysignal_Xsensor_seat,
#         "rms_Xsensor_seat",rms_Xsensor_seat,
#         "vdv_Xsensor_seat",vdv_Xsensor_seat,
#         "crest_factor_Xsensor_seat",crest_factor_Xsensor_seat,
#         "Energysignal_Xsensor_seat_polar",Energysignal_Xsensor_seat_polar,
#         "rms_Xsensor_seat_polar",rms_Xsensor_seat_polar,
#         "vdv_Xsensor_seat_polar",vdv_Xsensor_seat_polar)
