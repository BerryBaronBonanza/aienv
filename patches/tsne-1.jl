function fit(::Type{TSNE}, X::AbstractMatrix{T}; p::Real=30, maxoutdim::Integer=2,
             maxiter::Integer=800, exploreiter::Integer=200,
             exaggeration::Real=12, tol::Real=1e-7, initialize::Symbol=:pca,
             rng::AbstractRNG=default_rng(), nntype=BruteForce) where {T<:Real}

    d, n = size(X)
    k = min(n-1, round(Int, 3p))
    # Construct NN graph
    NN = fit(nntype, X)
    
    # form distance matrix
    D = adjacency_matrix(NN, X, k, symmetric=false)
    D .^= 2 # sq. dists
    I, J, V = findnz(D)
    @show kk = (length(I) ÷ k) * k
    I = I[1:kk]
    J = J[1:kk]
    V = V[1:kk]
    Ds = reshape(V, k, :)

    # calculate perplexities & corresponding conditional probabilities matrix P
    Px, βs = perplexities(Ds, p, tol=tol)
    P = sparse(I, J, reshape(Px,:))
    P .+= P' # symmetrize
    P ./= max(sum(P), eps(T))

    # form initial embedding and optimize it
    Y = if initialize == :pca
        predict(fit(PCA, X, maxoutdim=maxoutdim), X)
    elseif initialize == :random
        randn(rng, T, maxoutdim, n).*T(1e-4)
    else
        error("Uknown initialization method: $initialize")
    end
    dof = max(maxoutdim-1, 1)
    optimize!(Y, P, dof; maxiter=maxiter, exploreiter=exploreiter, tol=tol,
              exaggeration=exaggeration, η=max(n/exaggeration/4, 50))

    return TSNE{nntype, T}(d, p, βs, Y, NN) 
end
