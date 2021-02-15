include("../functions/analysisPULSE.jl")

####################################################################
step_max_perturb_Xsensor=step_max_perturb÷(Ts_Xsensor/Ts_MTiXsens)

# Energysignal_Xsensor_back,
# rms_Xsensor_back,
# vdv_Xsensor_back,
# crest_factor_Xsensor_back=analysisPULSE_All(
#                         Xsensor_reduce_sync_perturb,
#                         filenameXsensor,
#                         Ts_Xsensor,
#                         step_max_perturb_Xsensor,
#                         10)
#
# plotAnalysisPULSE_All(
#             Energysignal_Xsensor_back,
#             rms_Xsensor_back,
#             vdv_Xsensor_back,
#             crest_factor_Xsensor_back,
#             filenameXsensor,
#             "Xsensor_back",
#             ["Planche 1" "Planche 2"],
#             [1 1 1 2 2 2 3 3 3]',
#             [:blue :red],
#             [:circle :utriangle])

Energysignal_Xsensor_seat,
rms_Xsensor_seat,
vdv_Xsensor_seat,
crest_factor_Xsensor_seat,
null_,
null_,
null_=analysisPULSE_All(
                    Xsensor_reduce_sync_perturb,
                    filenameXsensor,
                    Ts_Xsensor,
                    step_max_perturb_Xsensor,
                    4)

null_,
null_,
null_,
null_,
std_Xsensor_seat_x,
min_Xsensor_seat_x,
max_Xsensor_seat_x,
range_Xsensor_seat_x=analysisPULSE_All(
                    Xsensor_reduce_sync_perturb,
                    filenameXsensor,
                    Ts_Xsensor,
                    step_max_perturb_Xsensor,
                    5)

null_,
null_,
null_,
null_,
std_Xsensor_seat_y,
min_Xsensor_seat_y,
max_Xsensor_seat_y,
range_Xsensor_seat_y=analysisPULSE_All(
                    Xsensor_reduce_sync_perturb,
                    filenameXsensor,
                    Ts_Xsensor,
                    step_max_perturb_Xsensor,
                    6)

min_Xsensor_seat=Dict()
max_Xsensor_seat=Dict()
range_Xsensor_seat=Dict()
std_Xsensor_seat=Dict()
for k in collect(keys(min_Xsensor_seat_x))
    std_Xsensor_seat[k]=[std_Xsensor_seat_x[k] std_Xsensor_seat_y[k]]
    min_Xsensor_seat[k]=[min_Xsensor_seat_x[k] min_Xsensor_seat_y[k]]
    max_Xsensor_seat[k]=[max_Xsensor_seat_x[k] max_Xsensor_seat_y[k]]
    range_Xsensor_seat[k]=[range_Xsensor_seat_x[k] range_Xsensor_seat_y[k]]
end

# plotAnalysisPULSE_All(
#         Energysignal_Xsensor_seat,
#         rms_Xsensor_seat,
#         vdv_Xsensor_seat,
#         crest_factor_Xsensor_seat,
#         filenameXsensor[1:end-1,:],
#         "Xsensor_seat",
#         ["Planche 1"],
#         [ones(1,10) ones(1,10).*3]',
#         [:blue],
#         [:circle])

# using JLD
#
# jldopen("results/PULSE_analysis_gel.jld", "r+") do file
#     write(file,
#     "filenameXsensor",filenameXsensor)
#     write(file,
#     "step_max_perturb_Xsensor",step_max_perturb_Xsensor)
#     write(file,
#     "Energysignal_Xsensor_seat",Energysignal_Xsensor_seat)
#     write(file,
#     "rms_Xsensor_seat",rms_Xsensor_seat)
#     write(file,
#     "vdv_Xsensor_seat",vdv_Xsensor_seat)
#     write(file,
#     "crest_factor_Xsensor_seat",crest_factor_Xsensor_seat )
#     write(file,
#     "std_Xsensor_seat",std_Xsensor_seat)
# end

## #
toto=load("results/PULSE_analysis_gel.jld")

toto["filenameXsensor"]=filenameXsensor
toto["step_max_perturb_Xsensor"]=step_max_perturb_Xsensor
toto["Energysignal_Xsensor_seat"]=Energysignal_Xsensor_seat
toto["rms_Xsensor_seat"]=rms_Xsensor_seat
toto["vdv_Xsensor_seat"]=vdv_Xsensor_seat
toto["crest_factor_Xsensor_seat"]=crest_factor_Xsensor_seat
toto["std_Xsensor_seat"]=std_Xsensor_seat
toto["min_Xsensor_seat"]=min_Xsensor_seat
toto["max_Xsensor_seat"]=max_Xsensor_seat
toto["range_Xsensor_seat"]=range_Xsensor_seat

jldopen("results/PULSE_analysis_gel.jld", "w") do file
    toto_key=collect(keys(toto))
    for k in toto_key
        write(file,k,toto[k])
    end
end

toto=load("results/PULSE_analysis_gel.jld")

# ## #
# for k in collect(keys(titi))
#     print(k)
#     print(" : ")
#     println(haskey(toto,k))
# end
