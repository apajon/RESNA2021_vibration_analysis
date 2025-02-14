#
#    Butterworth_filter_function_alt.m
#    ver 2.3   January 27, 2012
#    by Tom Irvine  Email: tomirvine@aol.com
#
#    Butterworth filter, sixth-order, infinite impulse response,
#    cascade with refiltering option for phase correction
#
#
#    iband:   1=lowpass  2=highpass  3=bandpass
#
#    iphase=1  for refiltering for phase correction
#          =2  for no refiltering
#
function Butterworth_filter_function_alt(y,dt,iband,fl,fh,iphase)
#
include("th_weighted_filter_coefficients.jl")
include("th_weighted_apply_filter.jl")
#
sr=1/dt;
n=length(y);
ns = n;
#
#
if(iband == 1)  # lowpass
          f=fl;
end
if(iband == 2)  # highpass
          f=fh;
end
#
iflag=1;
#
if(iband==1 || iband==2)
    if( f > 0.5*sr)
	    println("  error: cutoff frequency must be < Nyquist frequency ");
	    iflag=999;
    end
end
if(iband == 3)  # bandpass
          f=fh;
#
    if( fl > 0.5*sr || fh > 0.5*sr)
	    println("  error: cutoff frequency must be < Nyquist frequency ");
	    iflag=999;
    end
#
end
#
freq=f;
#
#****** calculate coefficients *******
#
if(iflag != 999 && iband !=3)
#
    (a,b,iflag) = th_weighted_filter_coefficients(f,dt,iband,iflag);
#
end
#
if(iflag < 900 )
#
    if(iband == 1 || iband ==2)  # lowpass or highpass
#
         if(iphase==1)   # refiltering
			y_temp=th_weighted_apply_filter(y,iphase,a,b);
			y_temp=th_weighted_apply_filter(y_temp,iphase,a,b);
	      else
			y_temp=th_weighted_apply_filter(y,iphase,a,b);
          end
#
    end
#
    if(iband == 3)  # bandpass
 #
		 f=fh;
		 freq=f;
#
##		 disp(" Step 1");
		 iband=2;
         (a,b,iflag) =th_weighted_filter_coefficients(f,dt,iband,iflag);
 #
         if(iphase==1) # refiltering
			y_temp=th_weighted_apply_filter(y,iphase,a,b);
			y_temp=th_weighted_apply_filter(y_temp,iphase,a,b);
	      else
			y_temp=th_weighted_apply_filter(y,iphase,a,b);
          end
#
		 f=fl;
		 freq=f;
#
##		 disp(" Step 2");
		 iband=1;
         (a,b,iflag) = th_weighted_filter_coefficients(f,dt,iband,iflag);
#
         if(iphase==1) # refiltering
			y_temp=th_weighted_apply_filter(y_temp,iphase,a,b);
			y_temp=th_weighted_apply_filter(y_temp,iphase,a,b);
	      else
			y_temp=th_weighted_apply_filter(y_temp,iphase,a,b);
          end
#
    end
#
    mu=mean(y_temp);
    sd=std(y_temp);
    mx=maximum(y_temp);
    mi=minimum(y_temp);
    rms=sqrt(sd^2+mu^2);
#    out1 = sprintf("\n Filtered Signal:  mean = #8.4g    std = #8.4g    rms = #8.4g ",mu,sd,rms);
#    disp(out1);
#
#
else
    println(" ")
    println("  Abnormal termination.  No output file generated. ");
end

return (y_temp,mu,sd,rms)
end
