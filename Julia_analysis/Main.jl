cd("/Users/adrienpajon/Documents/all.nosync/git_repo/pulse_analysis/2020-11-12 xp pulse all seuil/Julia_analysis")

#Open Libraries
using JLD

using CSV

using DataFrames

using Plots

using StatsPlots

using LinearAlgebra

# using FFTW #pwelch ? spectrum PSD ? (matlab)#
using DSP

# using Pyplot
pyplot()


#Constant
Ts_MTiXsens=0.01;
#Ts_Xsensor=0.02; #idéalement 50Hz
Ts_Xsensor=1/55.2; #correctif dans la pratique on est plus vers 55.2Hz
Ts_IBS = 0.02
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

####################################################################
#script example to find synchro values
#include("Main-search_synchro.jl")

# include("imports/Import_synchro.jl")
sync=load("imports/import_synchro.jld")["sync"]
println("Synchro import finished")

#script to synchronize datas in
#AccFree_MTiXsens_sync
#Xsensor_reduce_sync
#IBS_sync
include("scripts/script_synchro_datas.jl")

# include("imports/Import_synchro_perturb.jl")
sync_=load("imports/Import_synchro_perturb.jld")["sync_"]
step_max_perturb=load("imports/Import_synchro_perturb.jld")["step_max_perturb"]
println("Synchro perturb import finished")

include("scripts/script_synchro_perturb_datas.jl")

####################################################################
# #Plot datas
#
# #Plot MTiXsens acc in plot_Acc_MTiXsens
# include("scripts/figure_MTiXsensAcc.jl")
#
# #Plot Xsensor load and COM in plot_Xsensor
# include("scripts/figure_Xsensor.jl")
#
# #Plot Optotrak position in plot_Optotrak
# include("scripts/figure_Optotrak.jl")

####################################################################
#include("functions/lowpassf.jl")
#AccSignalFreeFilt=Dict()
#for n in sensorXsensNames
#    AccSignalFreeFilt[n]=[lowpassf(AccSignalFree[n][:,1],Ts,0.011) lowpassf(AccSignalFree[n][:,2],Ts,0.011) lowpassf(AccSignalFree[n][:,3],Ts,0.011)]
#end
#
#println("lowpass filter on signal finished")

####################################################################
#plot of AccSignalFreeFilt
#include("figure_AccFilt.jl")

####################################################################
#plot of AccSignalFreeFilt
#include("figure_AccFilt.jl")

####################################################################


println("Computation finished")
