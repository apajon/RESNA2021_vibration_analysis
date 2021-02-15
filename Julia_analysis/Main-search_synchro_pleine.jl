cd("/Users/adrienpajon/Documents/all.nosync/git_repo/pulse_analysis/2020-11-12 xp pulse all seuil/Julia_analysis")

using CSV
using DataFrames
using JLD

# include("functions/prony.jl")
include("functions/pronyAlgo.jl")
include("functions/deleterows.jl")

#using Pyplot
pyplot()

##
Ts_MTiXsens=0.01
Ts_IBS = 0.02
Ts_Xsensor=1/55.2; #correctif dans la pratique on est plus vers 55.2Hz
convertlbpo2Nm = 0.11298482933333

## MTiXsens
#filenameMTiXsens : namefile of each experiment
#filenameMTiXsensID : name ID of each sensor with keys that refers to the position on the body
#sensorXsensNames : keys of each sensor equivalent to their position on the body
# include("imports/Import_filename_MTiXsens.jl")
filenameMTiXsens=load("imports/import_filename_MTiXsens_pleine.jld")["filenameMTiXsens"]
sensorXsensNames=load("imports/import_filename_MTiXsens_pleine.jld")["sensorXsensNames"]
filenameMTiXsensID=load("imports/import_filename_MTiXsens_pleine.jld")["filenameMTiXsensID"]

## Xsensor
#filenameXsensor : namefile of each experiment
# include("imports/Import_filename_Xsensor.jl")
filenameXsensor=load("imports/Import_filename_Xsensor_pleine.jld")["filenameXsensor"]


## Instrumented_backseat
#filenameIBS : namefile of each experiment
# include("imports/Import_filename_IBS.jl")
filenameIBS=load("imports/Import_filename_IBS_pleine.jld")["filenameIBS"]

println("FileName import finished")

## ##################################################################
#script to read CSV and store in
# MTiXsens
# Xsensor
# IBS
encoderFolderPath="../measures/pleine/encoder_file/"
IBSFolderPath="../measures/pleine/IBS/"
XsensorFolderPath="../measures/pleine/Xsensor/"
MTiXsensFolderPath="../measures/pleine/MTiXsens/"
include("scripts/script_read_CSV.jl")

## ##################################################################
#script to extract data from MTiXsens and Xsensor in
# AccFree_MTiXsens
# Xsensor_reduce
include("scripts/script_data_extract.jl")

# Treduce=12
# Vreduce=Int(Treduce/Ts_IBS)
# include("scripts/script_reduce_IBS.jl")
#
# badFileMTiXsens=[43]
# filenameMTiXsens=deleterows(filenameMTiXsens,badFileMTiXsens)
# # filenameXsensor=deleterows(filenameMTiXsens,badFile)
# badFileIBS=[41 63 67]
# filenameIBS=deleterows(filenameIBS,badFileIBS)

sync=Dict()

sync[1]=(MTiXsens=0,Xsensor=0,Instrumented_backseat=0)
sync[2]=(MTiXsens=0,Xsensor=0,Instrumented_backseat=0)
#MTiXsens est en Packet counter




## ######
# searchAllSynchroMTiXsens(AccFree_MTiXsens,filenameMTiXsens,N=20,threshold=0.1,p=2,q=2,f_coupure=15,f_sampling=100)
index_test_MTiXsens_1cm=searchAllSynchroMTiXsens(AccFree_MTiXsens,filenameMTiXsens[1:30,:],:siege,20,8,2,2,25,100)
index_test_MTiXsens_2cm=searchAllSynchroMTiXsens(AccFree_MTiXsens,filenameMTiXsens[31:60,:],:siege,20,8)
index_test_MTiXsens_3cm=searchAllSynchroMTiXsens(AccFree_MTiXsens,filenameMTiXsens[61:90,:],:siege,20,8)
index_test_MTiXsens_4cm=searchAllSynchroMTiXsens(AccFree_MTiXsens,filenameMTiXsens[91:end,:],:siege,20,8)
# index_test_MTiXsens_dda=searchAllSynchroMTiXsens(AccFree_MTiXsens,filenameMTiXsens[121:end,:],20,30)

index_test_MTiXsens=[index_test_MTiXsens_1cm;
                    index_test_MTiXsens_2cm;
                    index_test_MTiXsens_3cm;
                    index_test_MTiXsens_4cm]#
                    # index_test_MTiXsens_dda]

println(index_test_MTiXsens)
## ####
# index_test_Xsensor=[]
if size(Xsensor_reduce[filenameXsensor[1,1]],2)>6
    m=10
else
    m=4
end
index_test_Xsensor_1cm=searchAllSynchro(Xsensor_reduce,m,filenameXsensor[1:30,:],20,5*10^3)
index_test_Xsensor_2cm=searchAllSynchro(Xsensor_reduce,m,filenameXsensor[31:60,:],20,1*10^4)
index_test_Xsensor_3cm=searchAllSynchro(Xsensor_reduce,m,filenameXsensor[61:90,:],20,1*10^4)
index_test_Xsensor_4cm=searchAllSynchro(Xsensor_reduce,m,filenameXsensor[91:end,:],20,1*10^4)
# index_test_Xsensor=searchAllSynchro(Xsensor_reduce,m,filenameXsensor,20,1*10^4)

index_test_Xsensor=[index_test_Xsensor_1cm;
                    index_test_Xsensor_2cm;
                    index_test_Xsensor_3cm;
                    index_test_Xsensor_4cm]#
                    # index_test_MTiXsens_dda]
println(index_test_Xsensor)
## ####
index_test_IBS=[]
# index_test_IBS_01=searchAllSynchro(IBS,2,filenameIBS[1:49,:],20,2*10^5)
# index_test_IBS_02=searchAllSynchro(IBS,2,filenameIBS[50:end,:],20,1*10^6)
# index_test_IBS=[index_test_IBS_01;
#                     index_test_IBS_02]
#
# index_test_IBS_03=searchAllSynchro(IBS,2,filenameIBS[74,:],20,2*10^6)
# index_test_IBS[74]=index_test_IBS_03[1]
#
# index_test_IBS_04=searchAllSynchro(IBS,2,filenameIBS[39,:],20,1.5*10^6)
# index_test_IBS[39]=index_test_IBS_04[1]
#
# index_test_IBS.+=(Vreduce-1)
#
# println(index_test_IBS)

## #
# sync = Dict{String, Int64}()
sync=Dict()
sync_=Dict()
# for k=1:length(index_test_MTiXsens)
#     sync[k]=(MTiXsens=index_test_MTiXsens[k]-100,
#                 Xsensor=index_test_Xsensor[k]-55,
#                 IBS=index_test_IBS[k]-50)
#     sync_[k]=(MTiXsens=index_test_MTiXsens[k]-100,Xsensor=1,IBS=1)
# end

sync=(MTiXsens=index_test_MTiXsens.-100,
                Xsensor=index_test_Xsensor.-55,
                IBS=index_test_IBS.-50)
sync_=(MTiXsens=index_test_MTiXsens.-100,Xsensor=index_test_Xsensor.*0 .+1,IBS=index_test_IBS.*0 .+1)

step_max_perturb=400

save("imports/import_synchro_pleine.jld", "sync", sync)
save("imports/Import_synchro_perturb_pleine.jld", "sync_", sync_,
                                            "step_max_perturb",step_max_perturb)
