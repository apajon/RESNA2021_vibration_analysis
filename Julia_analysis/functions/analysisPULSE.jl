using Statistics

function Energysignal(data,Ts)
    return Energysignal_=sum(data.^2,dims=1).*Ts
end
function accRMS(data,step_max_perturb)
    return rms_=(sum(data.^2,dims=1)./(step_max_perturb+1)).^(1/2)
end
function accVDV(data,Ts)
    return vdv_=(sum(data.^4,dims=1).*Ts).^(1/4)
end
function crestFactor(data,accRMS)
    return crest_factor_=mapslices(maximum, data, dims=1)./accRMS
end
function convertPolar(data)
    # convert 2D cartesian to 2D polar coordinate
    data_=[sum(data.^2,dims=2).^(1/2) atand.(data[:,1]./data[:,2])]
end

function splitData(data,filename,plot_order)
    data_=[data[filename[i,1]][] for i in 1 : size(plot_order,1)]
    if size(filename,1)>size(plot_order,1)
        for k in 1:size(filename,1)÷size(plot_order,1)-1
            data_=hcat(data_,[data[filename[i,1]][] for i in 1+k*size(plot_order,1) : size(plot_order,1)+k*size(plot_order,1)])
        end
    end

    return data_
end

function splitData_2(data,filename,plot_order,k)
    data_=[data[filename[i,1]][k] for i in 1 : size(plot_order,1)]
    if size(filename,1)>size(plot_order,1)
        for k in 1:size(filename,1)÷size(plot_order,1)-1
            data_=hcat(data_,[data[filename[i,1]][k] for i in 1+k*size(plot_order,1) : size(plot_order,1)+k*size(plot_order,1)])
        end
    end

    return data_
end

function splitDataMTiXsens(data,filename,plot_order,n,k)
    data_=[data[filename[i,1]][n][1,k] for i in 1 : size(plot_order,1)]
    if size(filename,1)>size(plot_order,1)
        for k in 1:size(filename,1)÷size(plot_order,1)-1
            data_=hcat(data_,[data[filename[i,1]][n][1,k] for i in 1+k*size(plot_order,1) : size(plot_order,1)+k*size(plot_order,1)])
        end
    end

    return data_
end

function analysisPULSE(data,Ts,step_max_perturb)
    data_=data.-(sum(data[1:10,1],dims=1)/10)

    Energysignal_=Energysignal(data_,Ts)
    rms_=accRMS(data_,step_max_perturb)
    vdv_=accVDV(data_,Ts)
    crest_factor_=crestFactor(abs.(data_),rms_)
    std_=std(data_,dims=1)
    min_=minimum(data_,dims=1)
    max_=maximum(data_,dims=1)
    range_=max_.-min_

    return Energysignal_, rms_, vdv_, crest_factor_,std_,min_,max_,range_
end

function analysisPULSE_MTiXsens(AccFree_MTiXsens,
                                filename,
                                sensorXsensNames,
                                Ts_MTiXsens,
                                step_max_perturb,
                                f_coupure=15,
                                f_sampling=100)
    Energysignal_=Dict()
    rms_=Dict()
    vdv_=Dict()
    crest_factor_=Dict()

    Energysignal_polar_=Dict()
    rms_polar_=Dict()
    vdv_polar_=Dict()
    # crest_factor_polar_=Dict()
    for experiment=1:size(filename,1)
        Energysignal_[filename[experiment,1]]=Dict()
        rms_[filename[experiment,1]]=Dict()
        vdv_[filename[experiment,1]]=Dict()
        crest_factor_[filename[experiment,1]]=Dict()
        min_[filename[experiment,1]]=Dict()
        max_[filename[experiment,1]]=Dict()
        range_[filename[experiment,1]]=Dict()

        Energysignal_polar_[filename[experiment,1]]=Dict()
        rms_polar_[filename[experiment,1]]=Dict()
        vdv_polar_[filename[experiment,1]]=Dict()
        crest_factor_polar[filename[experiment,1]]=Dict()
        min_polar_[filename[experiment,1]]=Dict()
        max_polar_[filename[experiment,1]]=Dict()
        range_polar_[filename[experiment,1]]=Dict()

        # crest_factor_polar_[filename[experiment,1]]=Dict()
        for n in sensorXsensNames
            data_=convert(Matrix,AccFree_MTiXsens[filename[experiment,1]][n][:,2:4])
            # f_coupure=25
            # f_sampling=100
            designmethod = Butterworth(5)
            ff = digitalfilter(Lowpass(f_coupure/f_sampling),designmethod)
            data_=[filtfilt(ff,data_[:,1]) filtfilt(ff,data_[:,2]) filtfilt(ff,data_[:,3])]

            # acc_temp=convert(Matrix,AccFree_MTiXsens[filename[experiment,1]][n][:,2:4])
            acc_temp=[sqrt.(data_[:,1].^2+data_[:,2].^2) data_[:,3]]

            Energysignal_[filename[experiment,1]][n],
            rms_[filename[experiment,1]][n],
            vdv_[filename[experiment,1]][n],
            crest_factor_[filename[experiment,1]][n],
            min_[filename[experiment,1]][n],
            max_[filename[experiment,1]][n],
            range_[filename[experiment,1]][n]=analysisPULSE(acc_temp,Ts_MTiXsens,step_max_perturb)

            acc_temp_polar=convertPolar(acc_temp)

            Energysignal_polar_[filename[experiment,1]][n],
            rms_polar_[filename[experiment,1]][n],
            vdv_polar_[filename[experiment,1]][n],
            crest_factor_polar_[filename[experiment,1]][n],
            min_polar_[filename[experiment,1]][n],
            max_polar_[filename[experiment,1]][n],
            range_polar_[filename[experiment,1]][n]=analysisPULSE(acc_temp,Ts_MTiXsens,step_max_perturb)

            # Energysignal_polar_[filename[experiment,1]][n]=convertPolar(Energysignal_[filename[experiment,1]][n])
            # rms_polar_[filename[experiment,1]][n]=convertPolar(rms_[filename[experiment,1]][n])
            # vdv_polar_[filename[experiment,1]][n]=convertPolar(vdv_[filename[experiment,1]][n])
            # crest_factor_polar_[filename[experiment,1]][n]=
        end
    end
    return Energysignal_, rms_, vdv_, crest_factor_, Energysignal_polar_, rms_polar_, vdv_polar_
end

function analysisPULSE_All(data,filename,Ts,step_max_perturb,m)
    Energysignal=Dict()
    rms=Dict()
    vdv=Dict()
    crest_factor=Dict()
    std_=Dict()
    min_=Dict()
    max_=Dict()
    range_=Dict()
    for experiment=1:size(filename,1)
       Energysignal[filename[experiment,1]],
       rms[filename[experiment,1]],
       vdv[filename[experiment,1]],
       crest_factor[filename[experiment,1]],
       std_[filename[experiment,1]],
       min_[filename[experiment,1]],
       max_[filename[experiment,1]],
       range_[filename[experiment,1]]=analysisPULSE(data[filename[experiment,1]][:,m],Ts,step_max_perturb)
    end
    return Energysignal, rms, vdv, crest_factor,std_,min_,max_,range_
end

function analysisPULSE_IBS(data,filename,Ts,step_max_perturb,m)
    Energysignal=Dict()
    rms=Dict()
    vdv=Dict()
    crest_factor=Dict()
    std_=Dict()
    min_=Dict()
    max_=Dict()
    range_=Dict()
    for experiment=1:size(filename,1)
       data_=data[filename[experiment,1]][:,m]

       Energysignal[filename[experiment,1]],
       rms[filename[experiment,1]],
       vdv[filename[experiment,1]],
       crest_factor[filename[experiment,1]],
       std_[filename[experiment,1]],
       min_[filename[experiment,1]],
       max_[filename[experiment,1]],
       range_[filename[experiment,1]]=analysisPULSE(data_[data_.<0],Ts,step_max_perturb)
    end
    return Energysignal, rms, vdv, crest_factor,std_,min_,max_,range_
end

function addScatterPlotMTiXsens(pPlot,Energysignal,filename,plot_order,perturbIndices,n,k,perturbLabel,linecolor,perturbshape)
    if isempty(perturbIndices)
        data=splitDataMTiXsens(Energysignal,filename,plot_order,n,k)
        pPlot[n] = scatter!(
             plot_order,
            data,
            label=perturbLabel,
            markershape=perturbshape
        );
    else
        for ind in 1:size(perturbIndices,1)-1
            i1=perturbIndices[ind]
            i2=perturbIndices[ind+1]-1
            data=splitDataMTiXsens(Energysignal,filename[i1:i2],plot_order[i1:i2],n,k)
            pPlot[n] = scatter!(
                plot_order[i1:i2],
                data,
                label=perturbLabel[ind],
                markercolor=(if isempty(linecolor);:match;else;linecolor[ind];end),# markercolor=linecolor[ind],
                markershape=perturbshape[ind]
            );
        end
        ind=size(perturbIndices,1)
        i1=perturbIndices[ind]
        data=splitDataMTiXsens(Energysignal,filename[i1:end],plot_order[i1:end],n,k)
        pPlot[n] = scatter!(
            plot_order[i1:end],
            data,
            label=perturbLabel[ind],
            markercolor=(if isempty(linecolor);:match;else;linecolor[ind];end),# markercolor=linecolor[ind],
            markershape=perturbshape[ind]
        );
    end
end

function addScatterPlot_2(pPlot,Energysignal,filename,plot_order,perturbIndices,k,perturbLabel,linecolor,perturbshape)
    if isempty(perturbIndices)
        data=splitData_2(Energysignal,filename,plot_order,k)
        pPlot = scatter!(
             plot_order,
            data,
            label=perturbLabel,
            markershape=perturbshape
        );
    else
        for ind in 1:size(perturbIndices,1)-1
            i1=perturbIndices[ind]
            i2=perturbIndices[ind+1]-1
            data=splitData_2(Energysignal,filename[i1:i2],plot_order[i1:i2],k)
            pPlot = scatter!(
                plot_order[i1:i2],
                data,
                label=perturbLabel[ind],
                markercolor=(if isempty(linecolor);:match;else;linecolor[ind];end),# markercolor=linecolor[ind],
                markershape=perturbshape[ind]
            );
        end
        ind=size(perturbIndices,1)
        i1=perturbIndices[ind]
        data=splitData_2(Energysignal,filename[i1:end],plot_order[i1:end],k)
        pPlot = scatter!(
            plot_order[i1:end],
            data,
            label=perturbLabel[ind],
            markercolor=(if isempty(linecolor);:match;else;linecolor[ind];end),# markercolor=linecolor[ind],
            markershape=perturbshape[ind]
        );
    end
end

function addScatterPlot(pPlot,Energysignal,filename,plot_order,perturbIndices,perturbLabel,linecolor,perturbshape)
    if isempty(perturbIndices)
        data=splitData(Energysignal,filename,plot_order)
        pPlot = scatter!(
             plot_order,
            data,
            label=perturbLabel,
            markershape=perturbshape
        );
    else
        for ind in 1:size(perturbIndices,1)-1
            i1=perturbIndices[ind]
            i2=perturbIndices[ind+1]-1
            data=splitData(Energysignal,filename[i1:i2],plot_order[i1:i2])
            pPlot = scatter!(
                plot_order[i1:i2],
                data,
                label=perturbLabel[ind],
                markercolor=(if isempty(linecolor);:match;else;linecolor[ind];end),# markercolor=linecolor[ind],
                markershape=perturbshape[ind]
            );
        end
        ind=size(perturbIndices,1)
        i1=perturbIndices[ind]
        data=splitData(Energysignal,filename[i1:end],plot_order[i1:end])
        pPlot = scatter!(
            plot_order[i1:end],
            data,
            label=perturbLabel[ind],
            markercolor=(if isempty(linecolor);:match;else;linecolor[ind];end),# markercolor=linecolor[ind],
            markershape=perturbshape[ind]
        );
    end
end

function plotAnalysisPULSE_MTiXsens(
            Energysignal_MTiXsens,
            rms_MTiXsens,
            vdv_MTiXsens,
            crest_factor_MTiXsens,
            filenameMTiXsens,
            sensorXsensNames,
            axis_name=["x-y";"z"],
            perturbLabel=[],
            plot_order=[],
            perturbIndices=[],
            linecolor= [],
            perturbshape=[],
            addTitle="")

    # plot_order=[1 1 1 2 2 2 3 3 3]'
    # linecolor= [:blue :red];
    # perturbshape=[:circle :utriangle]
    # perturbLabel=["Planche 1" "Planche 2"]
    #each sensor
    for k in 1:size(axis_name,1)
        ####################################################################
        pMTiXsens_SignalEnergy=Dict()
        pMTiXsens_RMS=Dict()
        pMTiXsens_VDV=Dict()
        pMTiXsens_crest_factor=Dict()
        for n in sensorXsensNames
            pMTiXsens_SignalEnergy[n]=plot(
            title = string("MTiXsens signal energy in ",n," along ",axis_name[k],"-axis",addTitle),
            layout = (1, 1),
            # legend = false,
            legend=:best,
            #ylims = (0,30),
            xlabel = "vel [-]",
            ylabel = "Signal energy [m.s^-1]")

            addScatterPlotMTiXsens(pMTiXsens_SignalEnergy,Energysignal_MTiXsens,filenameMTiXsens,plot_order,perturbIndices,n,k,perturbLabel,linecolor,perturbshape)

            ####################################################################
            pMTiXsens_RMS[n]=plot(
            title = string("MTiXsens RMS in ",n," along ",axis_name[k],"-axis",addTitle),
            layout = (1, 1),
            # legend = false,
            legend=:best,
            #ylims = (0,30),
            xlabel = "vel [-]",
            ylabel = "RMS []")

            addScatterPlotMTiXsens(pMTiXsens_RMS,rms_MTiXsens,filenameMTiXsens,plot_order,perturbIndices,n,k,perturbLabel,linecolor,perturbshape)

            ####################################################################
            pMTiXsens_VDV[n]=plot(
            title = string("MTiXsens VDV in ",n," along ",axis_name[k],"-axis",addTitle),
            layout = (1, 1),
            # legend = false,
            legend=:best,
            #ylims = (0,30),
            xlabel = "vel [-]",
            ylabel = "VDV []")

            addScatterPlotMTiXsens(pMTiXsens_VDV,vdv_MTiXsens,filenameMTiXsens,plot_order,perturbIndices,n,k,perturbLabel,linecolor,perturbshape)

            ####################################################################
            pMTiXsens_crest_factor[n]=plot(
            title = string("MTiXsens Crest Factor in ",n," along ",axis_name[k],"-axis",addTitle),
            layout = (1, 1),
            # legend = false,
            legend=:best,
            #ylims = (0,30),
            xlabel = "vel [-]",
            ylabel = "Crest Factor []")

            addScatterPlotMTiXsens(pMTiXsens_crest_factor,crest_factor_MTiXsens,filenameMTiXsens,plot_order,perturbIndices,n,k,perturbLabel,linecolor,perturbshape)

            pMTiXsens_crest_factor[n]=plot!([0.8 3.2]',[9 9]',
                                                linestyle=:dot,
                                                linecolor=:black,
                                                label="threshold")
        end

        #savefig(plot_Acc_MTiXsens_norme[filenameMTiXsens[experiment,1]], string("save_figure/MTiXsens/Dossier_Xsens_", experiment, ".pdf"))
        for n in sensorXsensNames
            savefig(pMTiXsens_SignalEnergy[n],string("save_figure/figure_SE_RMS_VDV/SE_",n,"_",axis_name[k],"axis",".png"))
            savefig(pMTiXsens_RMS[n],string("save_figure/figure_SE_RMS_VDV/RMS_",n,"_",axis_name[k],"axis",".png"))
            savefig(pMTiXsens_VDV[n],string("save_figure/figure_SE_RMS_VDV/VDV_",n,"_",axis_name[k],"axis",".png"))

            savefig(pMTiXsens_crest_factor[n],string("save_figure/figure_SE_RMS_VDV/crest_factor_",n,"_",axis_name[k],"axis",".png"))

        end
    end

    # #tete-siege
    # for k in 1:size(axis_name,1)
    #     ####################################################################
    #     linecolor= [:blue :red];
    #
    #     pMTiXsens_SignalEnergy_tete_siege = scatter(
    #          plot_order,
    #         hcat([Energysignal_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 1 : 9],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 13 : 21],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 1 : 9],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens signal energy in tete-siege along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,30),
    #         xlabel = "vel [-]",
    #         ylabel = "Signal energy [m.s^-1]",
    #         markercolor=linecolor,
    #         label=["Planche 1 tete" "Planche 2 tete" "Planche 1 siege" "Planche 2 siege"],
    #         markershape=[:circle :circle :rect :rect]
    #     );
    #
    #     pMTiXsens_RMS_tete_siege = scatter(
    #          plot_order,
    #         hcat([rms_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 1 : 9],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 13 : 21],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 1 : 9],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens RMS in tete-siege along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,7),
    #         xlabel = "vel [-]",
    #         ylabel = "RMS []",
    #         markercolor=linecolor,
    #         label=["Planche 1 tete" "Planche 2 tete" "Planche 1 siege" "Planche 2 siege"],
    #         markershape=[:circle :circle :rect :rect]
    #     );
    #
    #     pMTiXsens_VDV_tete_siege = scatter(
    #          plot_order,
    #         hcat([vdv_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 1 : 9],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 13 : 21],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 1 : 9],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens VDV in tete-siege along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,8),
    #         xlabel = "vel [-]",
    #         ylabel = "VDV []",
    #         markercolor=linecolor,
    #         label=["Planche 1 tete" "Planche 2 tete" "Planche 1 siege" "Planche 2 siege"],
    #         markershape=[:circle :circle :rect :rect]
    #     );
    #
    #     savefig(pMTiXsens_SignalEnergy_tete_siege,string("save_figure/figure_SE_RMS_VDV/SE_tete-siege_",axis_name[k],"axis"))
    #     savefig(pMTiXsens_RMS_tete_siege,string("save_figure/figure_SE_RMS_VDV/RMS_tete-siege_",axis_name[k],"axis"))
    #     savefig(pMTiXsens_VDV_tete_siege,string("save_figure/figure_SE_RMS_VDV/VDV_tete-siege_",axis_name[k],"axis"))
    # end
    #
    # #coussin-siege
    # for k in 1:size(axis_name,1)
    #     ####################################################################
    #     linecolor= [:blue :red];
    #
    #     pMTiXsens_SignalEnergy_coussin_siege = scatter(
    #          plot_order,
    #         hcat([Energysignal_MTiXsens[filenameMTiXsens[i,1]][:coussin][1,k] for i in 1 : 9],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:coussin][1,k] for i in 13 : 21],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 1 : 9],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens signal energy in coussin-siege along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,30),
    #         xlabel = "vel [-]",
    #         ylabel = "Signal energy [m.s^-1]",
    #         markercolor=linecolor,
    #         label=["Planche 1 coussin" "Planche 2 coussin" "Planche 1 siege" "Planche 2 siege"],
    #         markershape=[:circle :circle :rect :rect]
    #     );
    #
    #     pMTiXsens_RMS_coussin_siege = scatter(
    #          plot_order,
    #         hcat([rms_MTiXsens[filenameMTiXsens[i,1]][:coussin][1,k] for i in 1 : 9],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:coussin][1,k] for i in 13 : 21],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 1 : 9],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens RMS in coussin-siege along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,7),
    #         xlabel = "vel [-]",
    #         ylabel = "RMS []",
    #         markercolor=linecolor,
    #         label=["Planche 1 coussin" "Planche 2 coussin" "Planche 1 siege" "Planche 2 siege"],
    #         markershape=[:circle :circle :rect :rect]
    #     );
    #
    #     pMTiXsens_VDV_coussin_siege = scatter(
    #          plot_order,
    #         hcat([vdv_MTiXsens[filenameMTiXsens[i,1]][:coussin][1,k] for i in 1 : 9],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:coussin][1,k] for i in 13 : 21],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 1 : 9],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens VDV in coussin-siege along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,8),
    #         xlabel = "vel [-]",
    #         ylabel = "VDV []",
    #         markercolor=linecolor,
    #         label=["Planche 1 coussin" "Planche 2 coussin" "Planche 1 siege" "Planche 2 siege"],
    #         markershape=[:circle :circle :rect :rect]
    #     );
    #
    #     savefig(pMTiXsens_SignalEnergy_coussin_siege,string("save_figure/figure_SE_RMS_VDV/SE_coussin-siege_",axis_name[k],"axis"))
    #     savefig(pMTiXsens_RMS_coussin_siege,string("save_figure/figure_SE_RMS_VDV/RMS_coussin-siege_",axis_name[k],"axis"))
    #     savefig(pMTiXsens_VDV_coussin_siege,string("save_figure/figure_SE_RMS_VDV/VDV_coussin-siege_",axis_name[k],"axis"))
    # end
    #
    # #tete-dossier
    # for k in 1:size(axis_name,1)
    #     ####################################################################
    #     linecolor= [:blue :red];
    #
    #     pMTiXsens_SignalEnergy_tete_dossier = scatter(
    #          plot_order,
    #         hcat([Energysignal_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 1 : 9],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 13 : 21],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 1 : 9],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens signal energy in tete-dossier along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,30),
    #         xlabel = "vel [-]",
    #         ylabel = "Signal energy [m.s^-1]",
    #         markercolor=linecolor,
    #         label=["Planche 1 tete" "Planche 2 tete" "Planche 1 dossier" "Planche 2 dossier"],
    #         markershape=[:circle :circle :rect :rect]
    #     );
    #
    #     pMTiXsens_RMS_tete_dossier = scatter(
    #          plot_order,
    #         hcat([rms_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 1 : 9],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 13 : 21],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 1 : 9],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens RMS in tete-dossier along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,7),
    #         xlabel = "vel [-]",
    #         ylabel = "RMS []",
    #         markercolor=linecolor,
    #         label=["Planche 1 tete" "Planche 2 tete" "Planche 1 dossier" "Planche 2 dossier"],
    #         markershape=[:circle :circle :rect :rect]
    #     );
    #
    #     pMTiXsens_VDV_tete_dossier = scatter(
    #          plot_order,
    #         hcat([vdv_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 1 : 9],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:tete][1,k] for i in 13 : 21],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 1 : 9],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens VDV in tete-dossier along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,8),
    #         xlabel = "vel [-]",
    #         ylabel = "VDV []",
    #         markercolor=linecolor,
    #         label=["Planche 1 tete" "Planche 2 tete" "Planche 1 dossier" "Planche 2 dossier"],
    #         markershape=[:circle :circle :rect :rect]
    #     );
    #
    #     savefig(pMTiXsens_SignalEnergy_tete_dossier,string("save_figure/figure_SE_RMS_VDV/SE_tete-dossier_",axis_name[k],"axis"))
    #     savefig(pMTiXsens_RMS_tete_dossier,string("save_figure/figure_SE_RMS_VDV/RMS_tete-dossier_",axis_name[k],"axis"))
    #     savefig(pMTiXsens_VDV_tete_dossier,string("save_figure/figure_SE_RMS_VDV/VDV_tete-dossier_",axis_name[k],"axis"))
    # end
    #
    # #STHT chest-siege
    # for k in 1:size(axis_name,1)
    #     ####################################################################
    #     linecolor= [:blue :red];
    #
    #     pMTiXsens_SignalEnergy_STHT_chest_siege = scatter(
    #          plot_order,
    #         hcat([Energysignal_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/Energysignal_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 1 : 9],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/Energysignal_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens signal energy STHT chest-siege along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,2),
    #         xlabel = "vel [-]",
    #         ylabel = "Signal energy STHT [-]",
    #         markercolor=linecolor,
    #         label=perturbLabel,
    #         markershape
    #     );
    #
    #     pMTiXsens_VDV_STHT_chest_siege=plot!([0.8 3.2]',[1 1]',
    #                                         linestyle=:dot,
    #                                         linecolor=:black,
    #                                         label="threshold")
    #
    #     pMTiXsens_RMS_STHT_chest_siege = scatter(
    #          plot_order,
    #         hcat([rms_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/rms_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 1 : 9],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/rms_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens RMS STHT chest-siege along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,2),
    #         xlabel = "vel [-]",
    #         ylabel = "RMS STHT []",
    #         markercolor=linecolor,
    #         label=perturbLabel,
    #         markershape
    #     );
    #     pMTiXsens_RMS_STHT_chest_siege=plot!([0.8 3.2]',[1 1]',
    #                                         linestyle=:dot,
    #                                         linecolor=:black,
    #                                         label="threshold")
    #
    #
    #     pMTiXsens_VDV_STHT_chest_siege = scatter(
    #          plot_order,
    #         hcat([vdv_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/vdv_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 1 : 9],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/vdv_MTiXsens[filenameMTiXsens[i,1]][:siege][1,k] for i in 13 : 21],
    #             ),
    #         title = [string("MTiXsens VDV STHT chest-siege along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,2),
    #         xlabel = "vel [-]",
    #         ylabel = "VDV STHT []",
    #         markercolor=linecolor,
    #         label=perturbLabel,
    #         markershape
    #     );
    #     pMTiXsens_VDV_STHT_tete_siege=plot!([0.8 3.2]',[1 1]',
    #                                         linestyle=:dot,
    #                                         linecolor=:black,
    #                                         label="threshold")
    #
    #     savefig(pMTiXsens_SignalEnergy_STHT_chest_siege,string("save_figure/figure_SE_RMS_VDV/SE_STHT_chest-siege_",axis_name[k],"axis"))
    #     savefig(pMTiXsens_RMS_STHT_chest_siege,string("save_figure/figure_SE_RMS_VDV/RMS_STHT_chest-siege_",axis_name[k],"axis"))
    #     savefig(pMTiXsens_VDV_STHT_chest_siege,string("save_figure/figure_SE_RMS_VDV/VDV_STHT_chest-siege_",axis_name[k],"axis"))
    # end
    #
    # #STHT chest-dossier
    # for k in 1:size(axis_name,1)
    #     ####################################################################
    #     linecolor= [:blue :red];
    #
    #     pMTiXsens_SignalEnergy_STHT_chest_dossier = scatter(
    #          plot_order,
    #         hcat([Energysignal_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/Energysignal_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 1 : 9],
    #                 [Energysignal_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/Energysignal_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens signal energy STHT chest-dossier along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,2),
    #         xlabel = "vel [-]",
    #         ylabel = "Signal energy STHT [-]",
    #         markercolor=linecolor,
    #         label=perturbLabel,
    #         markershape
    #     );
    #
    #     pMTiXsens_VDV_STHT_chest_dossier=plot!([0.8 3.2]',[1 1]',
    #                                         linestyle=:dot,
    #                                         linecolor=:black,
    #                                         label="threshold")
    #
    #     pMTiXsens_RMS_STHT_chest_dossier = scatter(
    #          plot_order,
    #         hcat([rms_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/rms_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 1 : 9],
    #                 [rms_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/rms_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 13 : 21]
    #             ),
    #         title = [string("MTiXsens RMS STHT chest-dossier along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,2),
    #         xlabel = "vel [-]",
    #         ylabel = "RMS STHT []",
    #         markercolor=linecolor,
    #         label=perturbLabel,
    #         markershape
    #     );
    #     pMTiXsens_RMS_STHT_chest_dossier=plot!([0.8 3.2]',[1 1]',
    #                                         linestyle=:dot,
    #                                         linecolor=:black,
    #                                         label="threshold")
    #
    #
    #     pMTiXsens_VDV_STHT_chest_dossier = scatter(
    #          plot_order,
    #         hcat([vdv_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/vdv_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 1 : 9],
    #                 [vdv_MTiXsens[filenameMTiXsens[i,1]][:chest][1,k]/vdv_MTiXsens[filenameMTiXsens[i,1]][:dossier][1,k] for i in 13 : 21],
    #             ),
    #         title = [string("MTiXsens VDV STHT chest-dossier along ",axis_name[k],"-axis")],
    #         layout = (1, 1),
    #         # legend = false,
    #         legend=:best,
    #         #ylims = (0,2),
    #         xlabel = "vel [-]",
    #         ylabel = "VDV STHT []",
    #         markercolor=linecolor,
    #         label=perturbLabel,
    #         markershape
    #     );
    #     pMTiXsens_VDV_STHT_chest_dossier=plot!([0.8 3.2]',[1 1]',
    #                                         linestyle=:dot,
    #                                         linecolor=:black,
    #                                         label="threshold")
    #
    #     savefig(pMTiXsens_SignalEnergy_STHT_chest_dossier,string("save_figure/figure_SE_RMS_VDV/SE_STHT_chest-dossier_",axis_name[k],"axis"))
    #     savefig(pMTiXsens_RMS_STHT_chest_dossier,string("save_figure/figure_SE_RMS_VDV/RMS_STHT_chest-dossier_",axis_name[k],"axis"))
    #     savefig(pMTiXsens_VDV_STHT_chest_dossier,string("save_figure/figure_SE_RMS_VDV/VDV_STHT_chest-dossier_",axis_name[k],"axis"))
    # end
end

function plotAnalysisPULSE_All(
            Energysignal,
            rms,
            vdv,
            crest_factor,
            filename,
            sensorName=[],
            perturbLabel=[],
            plot_order=[],
            perturbIndices=[],
            linecolor= [],
            perturbshape=[],
            addTitle="")

    #each sensor
    ####################################################################
    # plot_order=[1 1 1 2 2 2 3 3 3]',
    # linecolor= [:blue :red]
    # perturbshape=[:circle :utriangle]

    pSignalEnergy=plot(
    title = string(sensorName, " signal energy",addTitle),
    layout = (1, 1),
    # legend = false,
    legend=:best,
    #ylims = (0,30),
    xlabel = "vel [-]",
    ylabel = "SE []")

    addScatterPlot(pSignalEnergy,Energysignal,filename,plot_order,perturbIndices,perturbLabel,linecolor,perturbshape)

    ####################################################################
    pRMS=plot(
    title = string(sensorName, " RMS",addTitle),
    layout = (1, 1),
    # legend = false,
    legend=:best,
    #ylims = (0,30),
    xlabel = "vel [-]",
    ylabel = "RMS []")

    addScatterPlot(pRMS,rms,filename,plot_order,perturbIndices,perturbLabel,linecolor,perturbshape)

    ####################################################################
    pVDV=plot(
    title = string(sensorName, " VDV",addTitle),
    layout = (1, 1),
    # legend = false,
    legend=:best,
    #ylims = (0,30),
    xlabel = "vel [-]",
    ylabel = "VDV []")

    addScatterPlot(pVDV,vdv,filename,plot_order,perturbIndices,perturbLabel,linecolor,perturbshape)

    ####################################################################
    pcrest_factor=plot(
    title = string(sensorName, " Crest Factor",addTitle),
    layout = (1, 1),
    # legend = false,
    legend=:best,
    #ylims = (0,30),
    xlabel = "vel [-]",
    ylabel = "Crest Factor []")

    addScatterPlot(pcrest_factor,crest_factor,filename,plot_order,perturbIndices,perturbLabel,linecolor,perturbshape)

    pcrest_factor=plot!([0.8 3.2]',[9 9]',
                                        linestyle=:dot,
                                        linecolor=:black,
                                        label="threshold")

    savefig(pSignalEnergy,string("save_figure/figure_SE_RMS_VDV/SE_",sensorName,".png"))
    savefig(pRMS,string("save_figure/figure_SE_RMS_VDV/RMS_",sensorName,".png"))
    savefig(pVDV,string("save_figure/figure_SE_RMS_VDV/VDV_",sensorName,".png"))
    savefig(pcrest_factor,string("save_figure/figure_SE_RMS_VDV/crest_factor_",sensorName,".png"))
end

function plotAnalysisPULSE_All_2(
            std,
            min,
            max,
            range,
            filename,
            sensorName=[],
            axis_name=["x";"y"],
            perturbLabel=[],
            plot_order=[],
            perturbIndices=[],
            linecolor= [],
            perturbshape=[],
            addTitle="")

    #each sensor
    ####################################################################
    # plot_order=[1 1 1 2 2 2 3 3 3]',
    # linecolor= [:blue :red]
    # perturbshape=[:circle :utriangle]
    for k in 1:size(axis_name,1)
        pStd=Dict()
        pMTiXsens_RMS=Dict()
        pMTiXsens_VDV=Dict()
        pMTiXsens_crest_factor=Dict()

        pStd=plot(
        title = string(sensorName, " standard deviation of CoP"," along ",axis_name[k],"-axis",addTitle),
        layout = (1, 1),
        # legend = false,
        legend=:best,
        #ylims = (0,30),
        xlabel = "vel [-]",
        ylabel = "CoP [cm]")

        # addScatterPlot(pStd,std,filename,plot_order,perturbIndices,perturbLabel,linecolor,perturbshape)
        addScatterPlot_2(pStd,std,filename,plot_order,perturbIndices,k,perturbLabel,linecolor,perturbshape)
        ####################################################################
        pMin=plot(
        title = string(sensorName, " min of CoP"," along ",axis_name[k],"-axis",addTitle),
        layout = (1, 1),
        # legend = false,
        legend=:best,
        #ylims = (0,30),
        xlabel = "vel [-]",
        ylabel = "CoP [cm]")

        # addScatterPlot(pMin,min,filename,plot_order,perturbIndices,perturbLabel,linecolor,perturbshape)
        addScatterPlot_2(pMin,min,filename,plot_order,perturbIndices,k,perturbLabel,linecolor,perturbshape)

        ####################################################################
        pMax=plot(
        title = string(sensorName, " max of CoP"," along ",axis_name[k],"-axis",addTitle),
        layout = (1, 1),
        # legend = false,
        legend=:best,
        #ylims = (0,30),
        xlabel = "vel [-]",
        ylabel = "CoP [cm]")

        # addScatterPlot(pMax,max,filename,plot_order,perturbIndices,perturbLabel,linecolor,perturbshape)
        addScatterPlot_2(pMax,max,filename,plot_order,perturbIndices,k,perturbLabel,linecolor,perturbshape)

        ####################################################################
        pRange=plot(
        title = string(sensorName, " range of CoP"," along ",axis_name[k],"-axis",addTitle),
        layout = (1, 1),
        # legend = false,
        legend=:best,
        #ylims = (0,30),
        xlabel = "vel [-]",
        ylabel = "CoP [cm]")

        # addScatterPlot(pRange,range,filename,plot_order,perturbIndices,perturbLabel,linecolor,perturbshape)
        addScatterPlot_2(pRange,range,filename,plot_order,perturbIndices,k,perturbLabel,linecolor,perturbshape)

        ## #
        savefig(pStd,string("save_figure/figure_SE_RMS_VDV/STD_",sensorName,"_",axis_name[k],".png"))
        savefig(pMin,string("save_figure/figure_SE_RMS_VDV/MIN_",sensorName,"_",axis_name[k],".png"))
        savefig(pMax,string("save_figure/figure_SE_RMS_VDV/MAX_",sensorName,"_",axis_name[k],".png"))
        savefig(pRange,string("save_figure/figure_SE_RMS_VDV/RANGE_",sensorName,"_",axis_name[k],".png"))
    end


end

function splitFileName(filename,shiftFactor_perturb=0,shiftFactor_wheel=0)
    splitName=[]
    plot_order=[]
    perturbLabel=[]
    wheelType=[]
    for k in filename
            splitName_temp=split(k,'_')
            append!(splitName,[splitName_temp])
            append!(plot_order,parse(Int,splitName_temp[5][2]))
            append!(perturbLabel,[splitName_temp[4]])
            append!(wheelType,[splitName_temp[3]])
    end

    perturbLabel_unique=unique(perturbLabel)
    perturbIndices=[]
    for k in perturbLabel_unique
            append!(perturbIndices,findfirst(perturbLabel.==k))
    end
    for k in 1:size(perturbIndices,1)-1
            i1=perturbIndices[k]
            i2=perturbIndices[k+1]-1
            plot_order[i1:i2]=plot_order[i1:i2].+(shiftFactor_perturb*(k-1))
    end
    plot_order[perturbIndices[end]:end]=plot_order[perturbIndices[end]:end].+(shiftFactor_perturb*(size(perturbIndices,1)-1))

    wheelLabel_unique=unique(wheelType)
    wheelIndices=[]
    for k in wheelLabel_unique
            append!(wheelIndices,findfirst(wheelType.==k))
    end
    for k in 1:size(wheelIndices,1)-1
            i1=wheelIndices[k]
            i2=wheelIndices[k+1]-1
            plot_order[i1:i2]=plot_order[i1:i2].+(shiftFactor_wheel*(k-1))
    end
    plot_order[wheelIndices[end]:end]=plot_order[wheelIndices[end]:end].+(shiftFactor_wheel*(size(wheelIndices,1)-1))

    return splitName, plot_order, perturbLabel, perturbLabel_unique, perturbIndices, wheelType, wheelLabel_unique, wheelIndices
end
