cd("/Users/adrienpajon/Documents/all.nosync/git_repo/pulse_analysis/2020-11-12 xp pulse all seuil/Julia_analysis")

using Glob
using JLD

include("functions/searchAndSave.jl")

#######
encoderFolderPath="../measures/gel/encoder_file/"
encoderFilename="*.txt"
encoderSaveFilename="imports/import_filename_encoder_gel.jld"
encoderSaveKey="filenameEncoder"
searchAndSave(encoderFolderPath,encoderFilename,encoderSaveFilename,encoderSaveKey)

#######
IBSFolderPath="../measures/gel/IBS/"
IBSFilename="*.CSV"
IBSSaveFilename="imports/import_filename_IBS_gel.jld"
IBSSaveKey="filenameIBS"
searchAndSave(IBSFolderPath,IBSFilename,IBSSaveFilename,IBSSaveKey)

#######
XsensorFolderPath="../measures/gel/Xsensor/"
XsensorFilename="*.csv"
XsensorSaveFilename="imports/import_filename_Xsensor_gel.jld"
XsensorSaveKey="filenameXsensor"
searchAndSave(XsensorFolderPath,XsensorFilename,XsensorSaveFilename,XsensorSaveKey)

#######
MTiXsensFolderPath="../measures/gel/MTiXsens/"
NoMTiXsens="00B41DF6.txt"
#dossier = SHOU R - torse = PROP 1 - siege = uARM R - cuisse = uLEG R - tete = lLEG R
filenameMTiXsensID = (dossier="00B41DF6",torse="00B41E68",siege="00B41E6D",cuisse="00B41E77",tete="00B41E86")
MTiXsensSaveFilename="imports/import_filename_MTiXsens_gel.jld"
MTiXsensSaveKey=["filenameMTiXsens" "filenameMTiXsensID" "sensorXsensNames"]
searchAndSaveMTiXsens(MTiXsensFolderPath,
                        NoMTiXsens,
                        filenameMTiXsensID,
                        MTiXsensSaveFilename,
                        MTiXsensSaveKey)
