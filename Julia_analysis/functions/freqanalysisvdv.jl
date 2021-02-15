function freqanalysisvdv(signal,Ts,iweight)
include("weight_factors_mod.jl")
include("Butterworth_filter_function_alt.jl")
(fwl,fw,fwu,wk,wd,wf,wc,we,wj,wb,www)=weight_factors_mod(iweight);
aw=zeros(length(signal),1);
iband=3;  # bandpass filtering
iphase=1; # refiltering for phase correction
for i=1:44
    fh=fwl[i];  # highpass filter frequency
    fl=fwu[i];  # lowpass filter frequency
    sr=1/Ts;
    if(fl<(sr/2.1))
        (y,mu,sd,rms)=Butterworth_filter_function_alt(signal,Ts,iband,fl,fh,iphase);
        aw=aw+y*www[i];
    end
end
n=length(aw);
AW=std(aw);
VDV=0;
for i=1:n
    VDV=VDV+aw[i]^4;
end
VDV=(VDV*Ts)^0.25;

# max, rms_a, rms_aw, vdv, crest
maxv=maximum(abs.(signal));
rms_a=std(signal);
rms_aw=AW;
# VDV;
crest=maximum(abs.(aw))/std(signal);

return (maxv=maxv,rms_a=rms_a,rms_aw=rms_aw,VDV=VDV,crest=crest)

# aa=[signal,aw];

# test=1;
end
