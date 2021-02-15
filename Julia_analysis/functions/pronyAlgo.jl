using Plots
using Statistics
using DSP

include("prony.jl")

function computePronyErr(line,N,p=2,q=2)
    err_test=[]
    for k = 1:length(line)-N
        line_start = k
        line_end = line_start + N - 1
        b, a, err = prony(line[line_start:line_end], p, q)

        append!(err_test,err)

        # myPoly = PolynomialRatio(b, a)
        # append!(mean_test,mean(impz(myPoly, N)))
        # append!(std_test,std(impz(myPoly, N)))
        # append!(max_test,maximum(impz(myPoly, N)))
    end
    return err_test
end

function searchSynchro(line,N,threshold=0.1,p=2,q=2)
    err_test=computePronyErr(line,N,p,q)
    first_err=findfirst(err_test.>threshold)-1
    first_impact=first_err.+(N-1)

    return err_test, first_err, first_impact
end

function plotSearchSynchro(line,err_test,first_err,first_impact,experiment,save_filename)
    p1=plot(line,label="signal",xlims = (0,length(line)),linecolor=:blue,title="Temporal signal")
    p1=plot!(p1,[first_err;first_err],[0;maximum(line)],linecolor=:red,label="First err")
    p1=plot!(p1,[first_impact;first_impact],[0;maximum(line)],linecolor=:black,label="First impact",linewidth = 2)

    p3=plot(err_test,label="err",xlims = (0,length(line)),linecolor=:blue,title="Curve of prony's error")
    p3=plot!([first_err;first_err],[0;maximum(err_test)],linecolor=:red,label="First err")
    p3=plot!([first_impact;first_impact],[0;maximum(err_test)],linecolor=:black,label="First impact")

    pTotal=plot(p1, p3, layout = (2, 1),title=string("Experiment : ",experiment))
    savefig(pTotal,save_filename)
end

function searchAllSynchroMTiXsens(AccFree_MTiXsens,filenameMTiXsens,sensorName,N=20,threshold=0.1,p=2,q=2,f_coupure=15,f_sampling=100)
    index_test=[]
    # experiment=1
    for experiment=1:length(filenameMTiXsens[:,1]) # =1:length(filenameMTiXsens[:,1]))
        @info experiment
        xline = AccFree_MTiXsens[filenameMTiXsens[experiment,1]][sensorName][:,:FreeAcc_X]
        yline = AccFree_MTiXsens[filenameMTiXsens[experiment,1]][sensorName][:,:FreeAcc_Y]

        designmethod = Butterworth(5)
        ff = digitalfilter(Lowpass(f_coupure/f_sampling),designmethod)
        xline=filtfilt(ff,xline)
        yline=filtfilt(ff,yline)

        line = xline.^2 .+yline.^2
        # line=line./maximum(line)

        err_test, first_err, first_impact = searchSynchro(line,N,threshold,p,q)
        # print(err_test)
        append!(index_test,AccFree_MTiXsens[filenameMTiXsens[experiment,1]][sensorName][first_impact,:PacketCounter])

        save_filename=string("save_figure/figure_prony/MTiXsens_",experiment,".png")
        plotSearchSynchro(line,err_test,first_err,first_impact,filenameMTiXsens[experiment,1],save_filename)
    end
    println("search Synchro MTiXsens Finished")

    return index_test
end

function searchAllSynchro(data,m,filename,N=20,threshold=0.1,p=2,q=2)
    index_test=[]
    experiment=1
    for experiment=1:length(filename[:,1]) # =1:length(filenameMTiXsens[:,1]))
        @info experiment
        line = data[filename[experiment,1]][:,m]
        line=line.-mean(line[1:25])
        # line=line./maximum(line)

        f_coupure=25
        f_sampling=50

        designmethod = Butterworth(5)
        ff = digitalfilter(Lowpass(f_coupure/f_sampling),designmethod)
        line=filtfilt(ff,line)

        err_test, first_err, first_impact = searchSynchro(line,N,threshold,p,q)
        # print(err_test)
        append!(index_test,first_impact)

        save_filename=string("save_figure/figure_prony/",replace(filename[experiment,1]," "=> "_"),".png")
        plotSearchSynchro(line,err_test,first_err,first_impact,filename[experiment,1],save_filename)
    end
    println("search Synchro Finished")

    return index_test
end
