cd("/Users/adrienpajon/Documents/all.nosync/git_repo/pulse_analysis/2020-11-12 xp pulse all seuil/Julia_analysis")

using DataFrames
using JLD

include("functions/analysisPULSE.jl")

####################################################################
gel=load("results/PULSE_analysis_gel.jld")
pleine=load("results/PULSE_analysis_pleine.jld")
pneu=load("results/PULSE_analysis_pneu.jld")

####################################################################
filenameXsensor=[gel["filenameXsensor"];pleine["filenameXsensor"];pneu["filenameXsensor"]]
Energysignal_Xsensor_seat=merge(gel["Energysignal_Xsensor_seat"],pleine["Energysignal_Xsensor_seat"],pneu["Energysignal_Xsensor_seat"])
rms_Xsensor_seat=merge(gel["rms_Xsensor_seat"],pleine["rms_Xsensor_seat"],pneu["rms_Xsensor_seat"])
vdv_Xsensor_seat=merge(gel["vdv_Xsensor_seat"],pleine["vdv_Xsensor_seat"],pneu["vdv_Xsensor_seat"])
crest_factor_Xsensor_seat=merge(gel["crest_factor_Xsensor_seat"],pleine["crest_factor_Xsensor_seat"],pneu["crest_factor_Xsensor_seat"])
std_Xsensor_seat=merge(gel["std_Xsensor_seat"],pleine["std_Xsensor_seat"],pneu["std_Xsensor_seat"])
min_Xsensor_seat=merge(gel["min_Xsensor_seat"],pleine["min_Xsensor_seat"],pneu["min_Xsensor_seat"])
max_Xsensor_seat=merge(gel["max_Xsensor_seat"],pleine["max_Xsensor_seat"],pneu["max_Xsensor_seat"])
range_Xsensor_seat=merge(gel["range_Xsensor_seat"],pleine["range_Xsensor_seat"],pneu["range_Xsensor_seat"])


splitNameXsensor,
plot_orderXsensor,
perturbLabelXsensor,
perturbLabel_uniqueXsensor,
perturbIndicesXsensor,
wheelTypeXsensor,
wheelLabel_uniqueXsensor,
wheelIndicesXsensor=splitFileName(filenameXsensor)

####################################################################
filenameMTiXsens=[gel["filenameMTiXsens"];pleine["filenameMTiXsens"];pneu["filenameMTiXsens"]]
Energysignal_MTiXsens=merge(gel["Energysignal_MTiXsens"],pleine["Energysignal_MTiXsens"],pneu["Energysignal_MTiXsens"])
rms_MTiXsens=merge(gel["rms_MTiXsens"],pleine["rms_MTiXsens"],pneu["rms_MTiXsens"])
vdv_MTiXsens=merge(gel["vdv_MTiXsens"],pleine["vdv_MTiXsens"],pneu["vdv_MTiXsens"])
crest_factor_MTiXsens=merge(gel["crest_factor_MTiXsens"],pleine["crest_factor_MTiXsens"],pneu["crest_factor_MTiXsens"])
Energysignal_MTiXsens_polar=merge(gel["Energysignal_MTiXsens_polar"],pleine["Energysignal_MTiXsens_polar"],pneu["Energysignal_MTiXsens_polar"])
rms_MTiXsens_polar=merge(gel["rms_MTiXsens_polar"],pleine["rms_MTiXsens_polar"],pneu["rms_MTiXsens_polar"])
vdv_MTiXsens_polar=merge(gel["vdv_MTiXsens_polar"],pleine["vdv_MTiXsens_polar"],pneu["vdv_MTiXsens_polar"])


splitNameMTiXsens,
plot_orderMTiXsens,
perturbLabelMTiXsens,
perturbLabel_uniqueMTiXsens,
perturbIndicesMTiXsens,
wheelTypeMTiXsens,
wheelLabel_uniqueMTiXsens,
wheelIndicesMTiXsens=splitFileName(filenameMTiXsens)

####################################################################
df=DataFrame(ID=[],
test=[],
problem=[],
obstacle_H=[],
vitesse=[],
pneumatique=[])

for k=1:5
    s=Symbol("mtixsens_",k,"_ES_horiz")
    df[!,s] =[]

    s=Symbol("mtixsens_",k,"_ES_vert")
    df[!,s] =[]

    s=Symbol("mtixsens_",k,"_ES_norm")
    df[!,s] =[]

    s=Symbol("mtixsens_",k,"_ES_angl")
    df[!,s] =[]

    s=Symbol("mtixsens_",k,"_VDV_horiz")
    df[!,s] =[]

    s=Symbol("mtixsens_",k,"_VDV_vert")
    df[!,s] =[]

    s=Symbol("mtixsens_",k,"_VDV_norm")
    df[!,s] =[]

    s=Symbol("mtixsens_",k,"_VDV_angl")
    df[!,s] =[]
end

s=Symbol("xsensor_seat_ES_vert")
df[!,s] =[]

s=Symbol("xsensor_seat_VDV_vert")
df[!,s] =[]

s=Symbol("xsensor_seat_std_fwd")
df[!,s] =[]
s=Symbol("xsensor_seat_std_lat")
df[!,s] =[]

s=Symbol("xsensor_seat_range_fwd")
df[!,s] =[]
s=Symbol("xsensor_seat_range_lat")
df[!,s] =[]

####################################################################
sensorXsensNames=collect(keys(Energysignal_MTiXsens[filenameMTiXsens[1,1]]))

varToNumber=Dict()

varToNumber["gel"]=1
varToNumber["pleine"]=2
varToNumber["pneu"]=3

varToNumber["1cm"]=1
varToNumber["2cm"]=2
varToNumber["3cm"]=3
varToNumber["4cm"]=4

varToNumber["v1"]=1
varToNumber["v2"]=2
varToNumber["v3"]=3

####################################################################
kMTiXsens=1
kXsensor=1
while (kXsensor<=length(filenameXsensor)) & (kMTiXsens<=length(filenameMTiXsens))
    XsensorName=splitNameXsensor[kXsensor]
    if XsensorName[4]=="dda"
        global kXsensor+=1
        continue
    end
    MTiXsensName=splitNameMTiXsens[kMTiXsens]
    @info string("kMTiXsens : ",kMTiXsens," kXsensor : ",kXsensor)

    sameName=(XsensorName[3]==MTiXsensName[3]) &
                (XsensorName[4]==MTiXsensName[4]) &
                (XsensorName[5]==MTiXsensName[5]) &
                (parse(Int,XsensorName[6])==parse(Int,MTiXsensName[6][1:end-4]))

    if sameName
        ID=length(df.ID)
        test=parse(Int,XsensorName[6])
        problem=missing
        obstacle_H=varToNumber[XsensorName[4]]
        vitesse=varToNumber[XsensorName[5]]
        pneumatique=varToNumber[XsensorName[3]]

        xsens=[]
        for k in sensorXsensNames
            push!(xsens,
                    Energysignal_MTiXsens[filenameMTiXsens[kMTiXsens,1]][k][1],
                    Energysignal_MTiXsens[filenameMTiXsens[kMTiXsens,1]][k][2],
                    Energysignal_MTiXsens_polar[filenameMTiXsens[kMTiXsens,1]][k][1],
                    Energysignal_MTiXsens_polar[filenameMTiXsens[kMTiXsens,1]][k][2],
                    vdv_MTiXsens[filenameMTiXsens[kMTiXsens,1]][k][1],
                    vdv_MTiXsens[filenameMTiXsens[kMTiXsens,1]][k][2],
                    vdv_MTiXsens_polar[filenameMTiXsens[kMTiXsens,1]][k][1],
                    vdv_MTiXsens_polar[filenameMTiXsens[kMTiXsens,1]][k][2])
        end

        xsensor=[]
        push!(xsensor,Energysignal_Xsensor_seat[filenameXsensor[kXsensor]][1])
        push!(xsensor,vdv_Xsensor_seat[filenameXsensor[kXsensor]][1])
        push!(xsensor,
                std_Xsensor_seat[filenameXsensor[kXsensor]][1],
                std_Xsensor_seat[filenameXsensor[kXsensor]][2])
        push!(xsensor,
                range_Xsensor_seat[filenameXsensor[kXsensor]][1],
                range_Xsensor_seat[filenameXsensor[kXsensor]][2])

        global kMTiXsens+=1
        global kXsensor+=1
    else
        sameWheel=varToNumber[XsensorName[3]]-varToNumber[MTiXsensName[3]]
        samePerturb=varToNumber[XsensorName[4]]-varToNumber[MTiXsensName[4]]
        sameVit=varToNumber[XsensorName[5]]-varToNumber[MTiXsensName[5]]
        sameTest=parse(Int,XsensorName[6])-parse(Int,MTiXsensName[6][1:end-4])

        #sensorChoose >0 : xsensor is missing
        #sensorChoose <0 : xsens is missing
        if sameWheel!=0
            sensorChoose=samewheel/abs(samewheel)
        elseif samePerturb!=0
            sensorChoose=samePerturb/abs(samePerturb)
        elseif sameVit!=0
            sensorChoose=sameVit/abs(sameVit)
        elseif sameTest!=0
            sensorChoose=sameTest/abs(sameTest)
        end

        if sensorChoose>0
            ID=length(df.ID)
            test=parse(Int,MTiXsensName[6][1:end-4])
            problem=missing
            obstacle_H=varToNumber[MTiXsensName[4]]
            vitesse=varToNumber[MTiXsensName[5]]
            pneumatique=varToNumber[MTiXsensName[3]]

            xsens=[]
            for k in sensorXsensNames
                push!(xsens,
                        Energysignal_MTiXsens[filenameMTiXsens[kMTiXsens,1]][k][1],
                        Energysignal_MTiXsens[filenameMTiXsens[kMTiXsens,1]][k][2],
                        Energysignal_MTiXsens_polar[filenameMTiXsens[kMTiXsens,1]][k][1],
                        Energysignal_MTiXsens_polar[filenameMTiXsens[kMTiXsens,1]][k][2],
                        vdv_MTiXsens[filenameMTiXsens[kMTiXsens,1]][k][1],
                        vdv_MTiXsens[filenameMTiXsens[kMTiXsens,1]][k][2],
                        vdv_MTiXsens_polar[filenameMTiXsens[kMTiXsens,1]][k][1],
                        vdv_MTiXsens_polar[filenameMTiXsens[kMTiXsens,1]][k][2])
            end

            xsensor=[]
            for k=1:6
                push!(xsensor,missing)
            end

            global kMTiXsens+=1
        else
            ID=length(df.ID)
            test=parse(Int,XsensorName[6])
            problem=missing
            obstacle_H=varToNumber[XsensorName[4]]
            vitesse=varToNumber[XsensorName[5]]
            pneumatique=varToNumber[XsensorName[3]]

            xsens=[]
            for k=1:40
                push!(xsens,missing)
            end

            xsensor=[]
            push!(xsensor,Energysignal_Xsensor_seat[filenameXsensor[kXsensor]][1])
            push!(xsensor,vdv_Xsensor_seat[filenameXsensor[kXsensor]][1])
            push!(xsensor,
                    std_Xsensor_seat[filenameXsensor[kXsensor]][1],
                    std_Xsensor_seat[filenameXsensor[kXsensor]][2])
            push!(xsensor,
                    range_Xsensor_seat[filenameXsensor[kXsensor]][1],
                    range_Xsensor_seat[filenameXsensor[kXsensor]][2])

            global kXsensor+=1
        end
    end

    # ID=min(kXsensor,kMTiXsens)
    # problem=missing
    # obstacle_H=missing
    # vitesse=missing
    # pneumatique=missing
    #

    row=[]
    push!(row,ID)
    push!(row,test)
    push!(row,problem)
    push!(row,obstacle_H)
    push!(row,vitesse)
    push!(row,pneumatique)

    row=[row; xsens]
    row=[row; xsensor]

    push!(df,row)
end

####################################################################
# using CSV
# CSV.write("results/results_compile.csv", df)

####################################################################
using Gadfly, Statistics
# df[:,:vitesse][findall(x->x==1,df[:,:vitesse]),:]="low"
# df[:,:vitesse][findall(x->x==2,df[:,:vitesse]),:]="medium"
# df[:,:vitesse][findall(x->x==3,df[:,:vitesse]),:]="high"
toto=Array(df[:,:vitesse])
toto[findall(x->x==1,toto),:].="low"
toto[findall(x->x==2,toto),:].="medium"
toto[findall(x->x==3,toto),:].="high"
s=Symbol("toto")
df2=DataFrame()
df2[!,s]=toto
df2[!,:mtixsens_1_ES_horiz]=Array(df[:,:mtixsens_1_ES_horiz])

tata=Array(df[:,:mtixsens_1_ES_horiz])
tata[findall(x->x!=1,Array(df[:,:obstacle_H])),:].=missing
df2[!,:mtixsens_1_ES_horiz_1cm]=tata

tata=Array(df[:,:mtixsens_1_ES_horiz])
tata[findall(x->x!=2,Array(df[:,:obstacle_H])),:].=missing
df2[!,:mtixsens_1_ES_horiz_2cm]=tata

tata=Array(df[:,:mtixsens_1_ES_horiz])
tata[findall(x->x!=3,Array(df[:,:obstacle_H])),:].=missing
df2[!,:mtixsens_1_ES_horiz_3cm]=tata

tata=Array(df[:,:mtixsens_1_ES_horiz])
tata[findall(x->x!=4,Array(df[:,:obstacle_H])),:].=missing
df2[!,:mtixsens_1_ES_horiz_4cm]=tata

p1 = plot(df, x=:vitesse, y=:mtixsens_1_ES_horiz, Geom.point, Stat.dodge(axis=:y));
p2 = plot(df,
            x=:toto, y=:mtixsens_1_ES_horiz,
            Scale.x_discrete(levels=["low", "medium", "high"]),
            Geom.point,
            Stat.dodge(axis=:x));
p3 = plot(df,
            x=:toto, y=:mtixsens_1_ES_horiz,
            Scale.x_discrete(levels=["low", "medium", "high"]),
            Geom.beeswarm,
            Stat.dodge(axis=:x));

p4= plot(df2,
            layer(x=:toto, y=:mtixsens_1_ES_horiz_1cm,Theme(default_color="blue")),
            layer(x=:toto, y=:mtixsens_1_ES_horiz_2cm,Theme(default_color="red")),
            layer(x=:toto, y=:mtixsens_1_ES_horiz_3cm,Theme(default_color="green")),
            layer(x=:toto, y=:mtixsens_1_ES_horiz_4cm,Theme(default_color="orange")),
            Geom.point)
