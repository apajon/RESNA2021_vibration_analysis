function lowpassf(u,Ts,filt)

# vf=zeros(size(u,1),size(u,2));
# vf[1] = u[1];

vf=copy(u);
vf[2:end].=0;

for k=2:max(size(u,1),size(u,2))
    vf[k]=vf[k-1]*(1-Ts/filt)+u[k]*Ts/filt;
end

return vf

# t=0:0.01:10;x=10*sin(2*pi*25*t);out=lowpassf(x,0.01,0.011);
# plot(t,x,'b');hold on; plot(t,out,'--r');

end
