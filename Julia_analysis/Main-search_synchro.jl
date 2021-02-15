cd("/Users/adrienpajon/Documents/all.nosync/git_repo/pulse_analysis/2020-11-12 xp pulse all seuil/Julia_analysis")

using CSV
using DataFrames
using JLD

# include("functions/prony.jl")
include("functions/pronyAlgo.jl")

#using Pyplot
pyplot()

Ts_MTiXsens=0.01
Ts_IBS = 0.02
Ts_Xsensor=1/55.2; #correctif dans la pratique on est plus vers 55.2Hz
convertlbpo2Nm = 0.11298482933333
#MTiXsens
#filenameMTiXsens : namefile of each experiment
#filenameMTiXsensID : name ID of each sensor with keys that refers to the position on the body
#sensorXsensNames : keys of each sensor equivalent to their position on the body
# include("imports/Import_filename_MTiXsens.jl")
filenameMTiXsens=load("imports/import_filename_MTiXsens.jld")["filenameMTiXsens"]
sensorXsensNames=load("imports/import_filename_MTiXsens.jld")["sensorXsensNames"]
filenameMTiXsensID=load("imports/import_filename_MTiXsens.jld")["filenameMTiXsensID"]

#Xsensor
#filenameXsensor : namefile of each experiment
# include("imports/Import_filename_Xsensor.jl")
filenameXsensor=load("imports/Import_filename_Xsensor.jld")["filenameXsensor"]


#Instrumented_backseat
#filenameIBS : namefile of each experiment
# include("imports/Import_filename_IBS.jl")
filenameIBS=load("imports/Import_filename_IBS.jld")["filenameIBS"]

println("FileName import finished")

####################################################################
#script to read CSV and store in
# MTiXsens
# Xsensor
# IBS
encoderFolderPath="../measures/encoder_file/20201026_test_1p/"
IBSFolderPath="../measures/IBS/"
XsensorFolderPath="../measures/Xsensor/"
MTiXsensFolderPath="../measures/MTiXsens/"
include("scripts/script_read_CSV.jl")

####################################################################
#script to extract data from MTiXsens and Xsensor in
# AccFree_MTiXsens
# Xsensor_reduce
include("scripts/script_data_extract.jl")
include("scripts/script_reduce_IBS.jl")

# include("imports/Import_synchro.jl")
# sync_OLD=sync

sync=Dict()

#MTiXsens est en Packet counter


sync[1]=(MTiXsens=0,Xsensor=0,Instrumented_backseat=0)
sync[2]=(MTiXsens=0,Xsensor=0,Instrumented_backseat=0)
#MTiXsens est en Packet counter



########
index_test_MTiXsens=searchAllSynchroMTiXsens(AccFree_MTiXsens,filenameMTiXsens,20,50)
println(index_test_MTiXsens)
# plot(pTotal[1])

######
if size(Xsensor_reduce[filenameXsensor[1,1]],2)>6
    m=10
else
    m=4
end
index_test_Xsensor=searchAllSynchro(Xsensor_reduce,m,filenameXsensor,20,1*10^4)
println(index_test_Xsensor)

######
index_test_IBS=searchAllSynchro(IBS,2,filenameIBS,20,1*10^5)
println(index_test_IBS)

# sync = Dict{String, Int64}()
sync=Dict()
sync_=Dict()
for k=1:length(index_test_MTiXsens)
    sync[k]=(MTiXsens=index_test_MTiXsens[k]-100,
                Xsensor=index_test_Xsensor[k]-55,
                IBS=index_test_IBS[k]-50)
    sync_[k]=(MTiXsens=index_test_MTiXsens[k]-100,Xsensor=1,IBS=1)
end
step_max_perturb=400

save("imports/import_synchro.jld", "sync", sync)
save("imports/Import_synchro_perturb.jld", "sync_", sync_,
                                            "step_max_perturb",step_max_perturb)
