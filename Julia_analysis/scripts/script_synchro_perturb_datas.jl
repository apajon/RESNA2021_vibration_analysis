AccFree_MTiXsens_sync_perturb=Dict()
Xsensor_reduce_sync_perturb=Dict()
IBS_sync_perturb =Dict()

for experiment=1:size(filenameMTiXsens,1)
    #AccFree_MTiXsens_sync_perturb[filenameMTiXsens[experiment,1]]=Dict()
    #for n in sensorXsensNames
    #       AccFree_MTiXsens_sync_perturb[filenameMTiXsens[experiment,1]][n]=AccFree_MTiXsens_sync[filenameMTiXsens[experiment,1]][n][sync_[experiment].MTiXsens:sync_[experiment].MTiXsens+step_max_perturb,:]
    #end

    AccFree_MTiXsens_sync_perturb[filenameMTiXsens[experiment,1]]=Dict()
    for n in sensorXsensNames
        are = AccFree_MTiXsens_sync[filenameMTiXsens[experiment,1]][n][:,"PacketCounter"]
        ligne = findall(x -> x == sync_.MTiXsens[experiment], are)
        AccFree_MTiXsens_sync_perturb[filenameMTiXsens[experiment,1]][n]=
            AccFree_MTiXsens_sync[filenameMTiXsens[experiment,1]][n][
                ligne[1]:min(ligne[1]+step_max_perturb,size(AccFree_MTiXsens_sync[filenameMTiXsens[experiment,1]][n][ligne[1]:end,:],1)),
                :]
    end
end

for experiment=1:size(filenameXsensor,1)
    Xsensor_reduce_sync_perturb[filenameXsensor[experiment,1]]=
        Xsensor_reduce_sync[filenameXsensor[experiment,1]][
            sync_.Xsensor[experiment]:min(sync_.Xsensor[experiment]+convert(Int,step_max_perturb÷(Ts_Xsensor/Ts_MTiXsens)),size(Xsensor_reduce_sync[filenameXsensor[experiment,1]][sync_.Xsensor[experiment]:end,:],1)),
            :]
end

for experiment=1:size(filenameIBS,1)
    IBS_sync_perturb[filenameIBS[experiment,1]] =
        IBS_sync[filenameIBS[experiment,1]][
            sync_.IBS[experiment]:min(sync_.IBS[experiment]+convert(Int,step_max_perturb÷(Ts_IBS/Ts_MTiXsens)),size(IBS_sync[filenameIBS[experiment,1]][sync_.IBS[experiment]:end,:],1)),
            :]
end

println("Synchro perturb data finished")
