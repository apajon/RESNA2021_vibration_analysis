include("../functions/analysisPULSE.jl")

####################################################################
step_max_perturb_MTiXsens=step_max_perturb

Energysignal_MTiXsens,
rms_MTiXsens,
vdv_MTiXsens,
crest_factor_MTiXsens,
Energysignal_MTiXsens_polar,
rms_MTiXsens_polar,
vdv_MTiXsens_polar=analysisPULSE_MTiXsens(AccFree_MTiXsens_sync_perturb,
                                                    filenameMTiXsens,
                                                    sensorXsensNames,
                                                    Ts_MTiXsens,
                                                    step_max_perturb_MTiXsens)

splitName,
plot_order,
perturbLabel,
perturbIndices,
wheelType=splitFileName(filenameMTiXsens,0.05)

include("../functions/analysisPULSE.jl")
plotAnalysisPULSE_MTiXsens(
        Energysignal_MTiXsens,
        rms_MTiXsens,
        vdv_MTiXsens,
        crest_factor_MTiXsens,
        filenameMTiXsens,
        sensorXsensNames,
        ["x-y";"z"],
        perturbLabel_,
        plot_order,
        perturbIndices,
        [:blue :red :green :orange :yellow],
        [:rect :rect :rect :rect :circle])

plotAnalysisPULSE_MTiXsens(
        Energysignal_MTiXsens_polar,
        rms_MTiXsens_polar,
        vdv_MTiXsens_polar,
        crest_factor_MTiXsens,
        filenameMTiXsens,
        sensorXsensNames,
        ["r";"\u03B8"],
        perturbLabel_,
        plot_order,
        perturbIndices,
        [:blue :red :green :orange :yellow],
        [:rect :rect :rect :rect :circle])

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
