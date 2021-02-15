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
                                                    filenameMTiXsens[1:109],
                                                    sensorXsensNames,
                                                    Ts_MTiXsens,
                                                    step_max_perturb_MTiXsens)

Energysignal_MTiXsens_2,
rms_MTiXsens_2,
vdv_MTiXsens_2,
crest_factor_MTiXsens_2,
Energysignal_MTiXsens_polar_2,
rms_MTiXsens_polar_2,
vdv_MTiXsens_polar_2=analysisPULSE_MTiXsens(AccFree_MTiXsens_sync_perturb,
                                                filenameMTiXsens[90:end],
                                                sensorXsensNames,
                                                Ts_MTiXsens_40,
                                                step_max_perturb_MTiXsens)

merge!(Energysignal_MTiXsens,Energysignal_MTiXsens_2)
merge!(rms_MTiXsens,rms_MTiXsens_2)
merge!(vdv_MTiXsens,vdv_MTiXsens_2)
merge!(crest_factor_MTiXsens,crest_factor_MTiXsens_2)
merge!(Energysignal_MTiXsens_polar,Energysignal_MTiXsens_polar_2)
merge!(rms_MTiXsens_polar,rms_MTiXsens_polar_2)
merge!(vdv_MTiXsens_polar,vdv_MTiXsens_polar_2)

splitNameMTiXsens=[]
plot_order=[]
perturbLabel=[]
wheelType=[]
for k in filenameMTiXsens
        splitName=split(k,'_')
        append!(splitNameMTiXsens,[splitName])
        append!(plot_order,parse(Int,splitName[5][2]))
        append!(perturbLabel,[splitName[4]])
        append!(wheelType,[splitName[3]])
end
perturbLabel_=unique(perturbLabel)
perturbIndices=[]
for k in perturbLabel_
        append!(perturbIndices,findfirst(perturbLabel.==k))
end
for k in 1:size(perturbIndices,1)-1
        i1=perturbIndices[k]
        i2=perturbIndices[k+1]-1
        plot_order[i1:i2]=plot_order[i1:i2].+(0.05*(k-1))
end
plot_order[perturbIndices[end]:end]=plot_order[perturbIndices[end]:end].+(0.05*(size(perturbIndices,1)-1))

# include("../functions/analysisPULSE.jl")
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
