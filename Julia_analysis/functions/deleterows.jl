deleterows(df::Array,x::Int) =  df[(1:size(df,1))[(1:size(df,1)).!=x],:]
deleterows(df::Array,x::Array) =  df[(1:size(df,1))[sum((1:size(df,1)).!=x,dims=2)[:,1].!=(size(x,2)-1)],:]
