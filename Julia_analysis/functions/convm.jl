function convm(x, p)
    """Generates a convolution matrix

    Usage: X = convm(x,p)
    Given a vector x of length N, an N+p-1 by p convolution matrix is
    generated of the following form:
              |  x(0)  0      0     ...      0    |
              |  x(1) x(0)    0     ...      0    |
              |  x(2) x(1)   x(0)   ...      0    |
         X =  |   .    .      .              .    |
              |   .    .      .              .    |
              |   .    .      .              .    |
              |  x(N) x(N-1) x(N-2) ...  x(N-p+1) |
              |   0   x(N)   x(N-1) ...  x(N-p+2) |
              |   .    .      .              .    |
              |   .    .      .              .    |
              |   0    0      0     ...    x(N)   |

    That is, x is assumed to be causal, and zero-valued after N.
    """
    N = length(x) + 2 * p - 2
    xpad = [zeros(p - 1); x; zeros(p - 1)]
    X = zeros(length(x) + p - 1, p)
    # Construct X column by column
    for i = 0:p-1
        X[:, i+1] = xpad[p-i:N-i]
    end

    return X
end
