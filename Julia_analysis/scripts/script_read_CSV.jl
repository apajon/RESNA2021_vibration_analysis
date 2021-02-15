# using CSV

#experiment number in filenameMTiXsens
print_bool=false

MTiXsens=Dict()
Xsensor=Dict()
IBS = Dict()

if size(filenameMTiXsens)!=size(filenameXsensor)
    @warn "MTiXsens and Xsensor do not have the same number of files"
end

if size(filenameMTiXsens)!=size(filenameIBS)
    @warn "MTiXsens and IBS do not have the same number of files"

end

for experiment=1:size(filenameMTiXsens,1)
    #Read CSV of Xsens
    MTiXsens[filenameMTiXsens[experiment,1]]=Dict()
    for n=1:5
        MTiXsens[filenameMTiXsens[experiment,1]][sensorXsensNames[n]] = CSV.read(string(MTiXsensFolderPath,filenameMTiXsens[experiment,1], filenameMTiXsensID[n],".txt");header=5)
    end

    if print_bool
        println(string("Xsens CSV read finished, experiment : "),experiment)
    end
end

for experiment=1:size(filenameXsensor,1)
    #Read CSV of Xsensor
    #Xsensor[filenameXsensor[experiment,1]]=Dict()
    Xsensor[filenameXsensor[experiment,1]]= CSV.read(string(XsensorFolderPath,filenameXsensor[experiment,1], ".csv");header=2)

    if print_bool
        println(string("Xsensor CSV read finished, experiment : "),experiment)
    end
end

for experiment=1:size(filenameIBS,1)
    #Read CSV of IBS
    #IBS[filenameIBS[experiment,1]]=Dict()
    IBS[filenameIBS[experiment,1]]= CSV.read(string(IBSFolderPath,filenameIBS[experiment,1], ".CSV");header=2)

    if print_bool
        println(string("Instrumented Backseat CSV read finished, experiment : "),experiment)
    end
end

println("CSV read finished")
