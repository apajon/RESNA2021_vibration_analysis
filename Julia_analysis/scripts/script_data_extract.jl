print_bool=false

include("../functions/MTiXsens_FillMissing.jl")

AccFree_MTiXsens=Dict()
Xsensor_reduce=Dict()

for experiment=1:size(filenameMTiXsens,1)
    #Extract FreeAcc from Xsens
    AccFree_MTiXsens_wthPacketCounter=Dict()
    for n in sensorXsensNames
        #extract useful column of MTiXsens datas and fill missing row datas
        AccFree_MTiXsens_wthPacketCounter[n] = MTiXsens_FillMissing(MTiXsens[filenameMTiXsens[experiment,1]][n][:,[1,5,6,7]])
    end
    AccFree_MTiXsens[filenameMTiXsens[experiment,1]]=AccFree_MTiXsens_wthPacketCounter
    #[filenameMTiXsens[experiment,1]]

    if print_bool
        println(string("Extract FreeAcc finished, experiment : "),experiment)
    end
end

for experiment=1:size(filenameXsensor,1)
    #Extract from Xsensor    Average Pressure	Peak Pressure	Contact Area (in²)	Est. Load (N)	COP Row	COP Column
    #siege first and dossier second
    ###WARNING###
    #Pay attention to column in xsensor experiment files
    #in this experiment there is a std dev column between Est. Load and COP
    #############
    #Xsensor_reduce[filenameXsensor[experiment,1]]=tryparse.(Float64,replace.(Xsensor[filenameXsensor[experiment,1]][:,[9,10,11,12,13,14,18,19,20,21,22,23]],[','=>'.']))
    if size(Xsensor[filenameXsensor[1,1]],2)>16
        if tryparse.(Float64,replace.(Xsensor[filenameXsensor[experiment,1]][1,12],[','=>'.']))[1] < 800
            Xsensor_reduce[filenameXsensor[experiment,1]]=tryparse.(Float64,replace.(Xsensor[filenameXsensor[experiment,1]][:,[19,20,21,22,24,25,9,10,11,12,14,15]],[','=>'.']))
        else
            Xsensor_reduce[filenameXsensor[experiment,1]]=tryparse.(Float64,replace.(Xsensor[filenameXsensor[experiment,1]][:,[9,10,11,12,14,15,19,20,21,22,24,25]],[','=>'.']))
        end
    else
        Xsensor_reduce[filenameXsensor[experiment,1]]=tryparse.(Float64,replace.(Xsensor[filenameXsensor[experiment,1]][:,[9,10,11,12,14,15]],[','=>'.']))

    end

    if print_bool
        println(string("Extract Xsensor finished, experiment : "),experiment)
    end

end

println("Extract data finished")
