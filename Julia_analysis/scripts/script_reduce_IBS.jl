print_bool=false

for experiment=1:size(filenameIBS,1)
    #############
    # Treduce=12
    # Vreduce=Int(Treduce/Ts_IBS)
    IBS[filenameIBS[experiment,1]]=IBS[filenameIBS[experiment,1]][Vreduce:end,:]


    if print_bool
        println(string("Reduce IBS finished, experiment : "),experiment)
    end

end

println("Reduce IBS finished")
