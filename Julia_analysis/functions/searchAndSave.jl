using Glob
using JLD

function searchAndSave(FolderPath,Name,SaveFilename,saveKey)
    Filename=glob(Name,FolderPath)
    n=sizeof(FolderPath)
    for k=1:size(Filename,1)
        println(Filename[k][n+1:end-4]) #
        Filename[k]=Filename[k][n+1:end-4]
    end

    save(SaveFilename, saveKey, Filename)

end

function searchAndSaveMTiXsens(FolderPath,NameID,filenameMTiXsensID,SaveFilename,saveKey)
    MTiXsensFilename=glob(string("*",NameID),FolderPath)
    n=sizeof(FolderPath)
    m=sizeof(NameID)
    for k=1:size(MTiXsensFilename,1)
        println(MTiXsensFilename[k][n+1:end-m]) #
        MTiXsensFilename[k]=MTiXsensFilename[k][n+1:end-m]
    end

    sensorXsensNames=collect(keys(filenameMTiXsensID));

    save(SaveFilename, saveKey[1], MTiXsensFilename,
                        saveKey[2], filenameMTiXsensID,
                        saveKey[3], sensorXsensNames)

end
