AccFree_MTiXsens_sync=Dict()
Xsensor_reduce_sync=Dict()
IBS_sync = Dict()

for experiment=1:size(filenameMTiXsens,1)
    AccFree_MTiXsens_sync[filenameMTiXsens[experiment,1]]=Dict()
    # @info experiment
    for n in sensorXsensNames
        arr = AccFree_MTiXsens[filenameMTiXsens[experiment,1]][n][:,"PacketCounter"]
        ligne = findall(x -> x == sync.MTiXsens[experiment], arr)
        AccFree_MTiXsens_sync[filenameMTiXsens[experiment,1]][n]=AccFree_MTiXsens[filenameMTiXsens[experiment,1]][n][ligne[1]:end,:]
    end
end
for experiment=1:size(filenameXsensor,1)
    Xsensor_reduce_sync[filenameXsensor[experiment,1]]=Xsensor_reduce[filenameXsensor[experiment,1]][sync.Xsensor[experiment]:end,:]
end
for experiment=1:size(filenameIBS,1)
    IBS_sync[filenameIBS[experiment,1]] = IBS[filenameIBS[experiment,1]][sync.IBS[experiment]:end,:]
end

println("Synchro data finished")
