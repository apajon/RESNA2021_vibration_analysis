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

filenameMTiXsens=[gel["filenameMTiXsens"];pleine["filenameMTiXsens"];pneu["filenameMTiXsens"]]
sensorXsensNames=gel["sensorXsensNames"]
Energysignal_MTiXsens=merge(gel["Energysignal_MTiXsens"],pleine["Energysignal_MTiXsens"],pneu["Energysignal_MTiXsens"])
rms_MTiXsens=merge(gel["rms_MTiXsens"],pleine["rms_MTiXsens"],pneu["rms_MTiXsens"])
vdv_MTiXsens=merge(gel["vdv_MTiXsens"],pleine["vdv_MTiXsens"],pneu["vdv_MTiXsens"])
crest_factor_MTiXsens=merge(gel["crest_factor_MTiXsens"],pleine["crest_factor_MTiXsens"],pneu["crest_factor_MTiXsens"])
Energysignal_MTiXsens_polar=merge(gel["Energysignal_MTiXsens_polar"],pleine["Energysignal_MTiXsens_polar"],pneu["Energysignal_MTiXsens_polar"])
rms_MTiXsens_polar=merge(gel["rms_MTiXsens_polar"],pleine["rms_MTiXsens_polar"],pneu["rms_MTiXsens_polar"])
vdv_MTiXsens_polar=merge(gel["vdv_MTiXsens_polar"],pleine["vdv_MTiXsens_polar"],pneu["vdv_MTiXsens_polar"])

splitName,
plot_order,
perturbLabel,
perturbLabel_unique,
perturbIndices,
wheelType,
wheelLabel_unique,
wheelIndices=splitFileName(filenameMTiXsens)

bool_perturb_choice="gel"
bool_perturb=wheelType.==bool_perturb_choice

filenameMTiXsens_=filenameMTiXsens[bool_perturb]

splitName,
plot_order,
perturbLabel,
perturbLabel_unique,
perturbIndices,
wheelType,
wheelLabel_unique,
wheelIndices=splitFileName(filenameMTiXsens_,0.05,0)

include("../functions/analysisPULSE.jl")
plotAnalysisPULSE_MTiXsens(
        Energysignal_MTiXsens,
        rms_MTiXsens,
        vdv_MTiXsens,
        crest_factor_MTiXsens,
        filenameMTiXsens_,
        sensorXsensNames,
        ["x-y";"z"],
        perturbLabel_unique,
        plot_order,
        perturbIndices,
        [:blue :red :green :orange :yellow],
        [:rect :rect :rect :rect :circle],
        string("\n","wheel : ",bool_perturb_choice))

plotAnalysisPULSE_MTiXsens(
        Energysignal_MTiXsens_polar,
        rms_MTiXsens_polar,
        vdv_MTiXsens_polar,
        crest_factor_MTiXsens,
        filenameMTiXsens_,
        sensorXsensNames,
        ["r";"\u03B8"],
        perturbLabel_unique,
        plot_order,
        perturbIndices,
        [:blue :red :green :orange :yellow],
        [:rect :rect :rect :rect :circle],
        string("\n","wheel : ",bool_perturb_choice))

println("PULSE Analysis Finished")

# using JLD
# save("results/PULSE_analysis_gel.jld",
#         "filenameMTiXsens",filenameMTiXsens,
#         "sensorXsensNames",sensorXsensNames,
#         "step_max_perturb_MTiXsens",step_max_perturb_MTiXsens,
#         "Energysignal_MTiXsens",Energysignal_MTiXsens,
#         "rms_MTiXsens",rms_MTiXsens,
#         "vdv_MTiXsens",vdv_MTiXsens,
#         "crest_factor_MTiXsens",crest_factor_MTiXsens,
#         "Energysignal_MTiXsens_polar",Energysignal_MTiXsens_polar,
#         "rms_MTiXsens_polar",rms_MTiXsens_polar,
#         "vdv_MTiXsens_polar",vdv_MTiXsens_polar)
