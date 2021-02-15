# function MTiXsens_FillMissing(data)
# #fill MTiXsens missing datas with linear interpolation
#
#     # MTiXsens_temp=MTiXsens[filenameMTiXsens[1,1]][sensorXsensNames[1]][:,[1,6,7,8]]
#     MTiXsens_temp=data[:,:]
#     #search missing packet
#     MTiXsens_temp_missing=MTiXsens_temp.PacketCounter[2:end]-MTiXsens_temp.PacketCounter[1:end-1].-1
#
#     # as the Packcounter is coded on 16bits, the max value is 65535 ans return to 0 when reaching over
#     # we have to add 2^16=65536 to all PacketCounter after each 0 to code the PacketCounter with more bits
#     negative_row=findall(MTiXsens_temp_missing.<0)
#     if size(negative_row,1)!=0
#         for negative in negative_row
#             MTiXsens_temp.PacketCounter[negative+1:end]=MTiXsens_temp.PacketCounter[negative+1:end].+2^16
#         end
#         MTiXsens_temp_missing=MTiXsens_temp.PacketCounter[2:end]-MTiXsens_temp.PacketCounter[1:end-1].-1
#     end
#
#     #Loop to fill missing datas
#     while isnothing(findfirst(MTiXsens_temp_missing.!=0))==false
#         row_missing=findfirst(MTiXsens_temp_missing.!=0)
#         nb_missing=MTiXsens_temp_missing[row_missing]
#
#         #save temporary datas before and after missing datas
#         MTiXsens_temp_down=MTiXsens_temp[row_missing:row_missing,:]
#         MTiXsens_temp_up=MTiXsens_temp[row_missing+1:row_missing+1,:]
#
#         #linear coefficient to interpolate missing datas
#         MTiXsens_temp_frac=(MTiXsens_temp_up.-MTiXsens_temp_down)./(nb_missing+1)
#
#         #add missing datas row by row with interpolation
#         for k=1:nb_missing
#             MTiXsens_temp_final=MTiXsens_temp_down.+(MTiXsens_temp_frac).*k
#             MTiXsens_temp_final.PacketCounter=MTiXsens_temp_down.PacketCounter.+k
#
#             insert!.(eachcol(MTiXsens_temp),row_missing+k,
#                 [MTiXsens_temp_final[1,1],
#                 MTiXsens_temp_final[1,2],
#                 MTiXsens_temp_final[1,3],
#                 MTiXsens_temp_final[1,4]]
#                 );
#         end
#
#         # insert!.(eachcol(MTiXsens_temp),2,[5,6,7,8,9]);
#
#         MTiXsens_temp_missing=MTiXsens_temp.PacketCounter[2:end]-MTiXsens_temp.PacketCounter[1:end-1].-1
#     end
#
#     return MTiXsens_temp
#
# end

function MTiXsens_FillMissing(data)
#fill MTiXsens missing datas with linear interpolation

    # MTiXsens_temp=MTiXsens[filenameMTiXsens[1,1]][sensorXsensNames[1]][:,[1,6,7,8]]
    MTiXsens_temp=data[:,:]
    #search missing packet
    MTiXsens_temp_missing=MTiXsens_temp.PacketCounter[2:end]-MTiXsens_temp.PacketCounter[1:end-1].-1

    # as the Packcounter is coded on 16bits, the max value is 65535 ans return to 0 when reaching over
    # we have to add 2^16=65536 to all PacketCounter after each 0 to code the PacketCounter with more bits
    negative_row=findall(MTiXsens_temp_missing.<0)
    if size(negative_row,1)!=0
        for negative in negative_row
            MTiXsens_temp.PacketCounter[negative+1:end]=MTiXsens_temp.PacketCounter[negative+1:end].+2^16
        end
        MTiXsens_temp_missing=MTiXsens_temp.PacketCounter[2:end]-MTiXsens_temp.PacketCounter[1:end-1].-1
    end

    #Loop to fill missing datas
    while isnothing(findfirst(MTiXsens_temp_missing.!=0))==false
        row_missing=findfirst(MTiXsens_temp_missing.!=0)
        nb_missing=MTiXsens_temp_missing[row_missing]

        #save temporary datas before and after missing datas
        MTiXsens_temp_down=MTiXsens_temp[row_missing:row_missing,:]
        if row_missing+1==size(MTiXsens_temp,1)
            MTiXsens_temp_up=MTiXsens_temp[row_missing+1:row_missing+1,:]
        else
            MTiXsens_temp_up=MTiXsens_temp[row_missing+2:row_missing+2,:]
        end

        #linear coefficient to interpolate missing datas
        MTiXsens_temp_frac=(MTiXsens_temp_up.-MTiXsens_temp_down)./(nb_missing+2)

        #add missing datas row by row with interpolation
        for k=1:nb_missing
            MTiXsens_temp_final=MTiXsens_temp_down.+(MTiXsens_temp_frac).*k
            MTiXsens_temp_final.PacketCounter=MTiXsens_temp_down.PacketCounter.+k

            insert!.(eachcol(MTiXsens_temp),row_missing+k,
                convert(Array,MTiXsens_temp_final[1,:])
                # [MTiXsens_temp_final[1,1],
                # MTiXsens_temp_final[1,2]]
                );
        end
        MTiXsens_temp_final=MTiXsens_temp_down.+(MTiXsens_temp_frac).*(nb_missing+1)
        MTiXsens_temp_final.PacketCounter=MTiXsens_temp_down.PacketCounter.+(nb_missing+1)
        MTiXsens_temp[row_missing+nb_missing+1,:]=convert(Array,MTiXsens_temp_final[1,:])

        MTiXsens_temp_missing=MTiXsens_temp.PacketCounter[2:end]-MTiXsens_temp.PacketCounter[1:end-1].-1
    end

    return MTiXsens_temp

end
