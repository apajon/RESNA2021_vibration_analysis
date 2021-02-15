#!/usr/bin/env python
# vim: set fileencoding=utf-8
""" This file is a Julia translation of the MATLAB file prony.m

 Julia version by Adrien Pajon 28 Sept 2020
 Copyright notice from prony.m:
 copyright 1996, by M.H. Hayes.  For use with the book
 "Statistical Digital Signal Processing and Modeling"
 (John Wiley & Sons, 1996).
"""

include("convm.jl")

function prony(x, p, q)
    # Model a signal using Prony's method
    #
    # Usage: [b,a,err] = prony(x,p,q)
    #
    # The input sequence x is modeled as the unit sample response of
    # a filter having a system function of the form
    #     H(z) = B(z)/A(z)
    # The polynomials B(z) and A(z) are formed from the vectors
    #     b=[b(0), b(1), ... b(q)]
    #     a=[1   , a(1), ... a(p)]
    # The input q defines the number of zeros in the model
    # and p defines the number of poles. The modeling error is
    # returned in err.
    #
    # This comes from Hayes, p. 149, 153, etc


    # x = x[:]
    # N = length(x)
    # if p + q >= length(x)
    #     print("ERROR: model order too large")
    #     print(
    #         "p q length(x) " +
    #         convert(String, p) +
    #         " " +
    #         convert(String, q) +
    #         " " +
    #         convert(String, length(x)),
    #     )
    #     return false
    # end
    #
    # # This formulation uses eq. 4.50, p. 153
    # # Set up the convolution matrices
    # X = convm(x, p + 1)
    # Xq = X[q+1:N+p-1, 1:p]
    # xq1 = -X[q+2:N+p, 1]
    # # Solve for denominator coefficients
    # a = []
    # if p > 0
    #     a = (Xq \ xq1)
    #     a = [1; a] # a(1) is 1
    # end
    #
    # # Solve for the model error
    # err = Array(conj(x[q+2:N])') * X[q+2:N, 1:p+1]
    # err = err * a
    #
    # # Solve for numerator coefficients
    # if q > 0
    #     # (This is the same as for Pad?)
    #     b = X[1:q+1, 1:p+1] * a
    # else
    #     # all-pole model
    #     # b(0) is x(0), but a better solution is to match energy
    #     b = sqrt(err)
    # end

    x   = x[:];

    N   = length(x);

    if p+q>=length(x)
        error("Model order too large")
        print(
            "p q length(x) " +
            convert(String, p) +
            " " +
            convert(String, q) +
            " " +
            convert(String, length(x))
        )
    end

    X   = convm(x,p+1);

    Xq  = X[q+1:N+p-1,1:p];

    a   = [1;-Xq\X[q+2:N+p,1]];

    b   = X[1:q+1,1:p+1]*a;

    err = x[q+2:N]'*X[q+2:N,1:p+1]*a;

    return (b, a, err)
end

####################################################################
# Example of code to use prony()

# function main()
#     # Test driver
#     # From pp. 149-150
#     x = ones(21)
#     p = q = 1
#     b, a, err = prony(x, p, q)
#     print("a: ")
#     println(a)
#     print("b: ")
#     println(b)
#     print("err: ")
#     println(err)
#
#     # From pp. 152-153
#     # Note that these results don't match the book, but they do match the
#     # MATLAB version. So I'm either setting things up wrong or this is an
#     # errata in the book.
#     p = q = 5
#     nd = 5
#     n = 0:11
#     i = sinc.((n .- nd) ./ 2) ./ 2
#     b, a, err = prony(i, p, q)
#     print("a: ")
#     println(a)
#     print("b: ")
#     println(b)
#     print("err: ")
#     println(err)
# end
# main()
