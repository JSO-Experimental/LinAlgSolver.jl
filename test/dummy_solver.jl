mutable struct DummySolver{T, S} <: AbstractLinAlgSolver{T, S}
  initialized::Bool
  params::Dict
  workspace
end

function SolverCore.parameters(::Type{DummySolver{T, S}}) where {T, S}
  (
    α = (default = one(T), type = T, scale = :log, min = √√eps(T), max = 1 / √√eps(T)),
    σ = (default = T(0.9), type = T, min = zero(T), max = one(T)),
  )
end

function SolverCore.are_valid_parameters(::Type{DummySolver}, α, σ)
  return (0 < σ ≤ 1) && (α > 0)
end

function DummySolver{T, S}(problem::LinAlgProblem{T, S}; kwargs...) where {T, S}
  m, n = size(problem.A)
  solver = DummySolver{T, S}(
    true,
    Dict{Symbol, Any}(:α => one(T), :σ => T(0.9)),
    (x = S(undef, n), r = S(undef, m), Aᵀr = S(undef, n))
  )
  for (k, v) in kwargs
    solver.params[k] = v
  end
  return solver
end

function SolverCore.solve!(
  solver::DummySolver{T, S},
  problem::LinAlgProblem{T, S};
  atol = 1e-6,
  rtol = 1e-6,
  max_iter = 1000,
  max_time = 5.0,
  kwargs...,
) where {T, S}
  solver.initialized || error("Solver not initialized.")
  t₀ = time()
  A, b = problem.A, problem.b
  x = solver.workspace.x .= zero(T)
  r = solver.workspace.r .= b
  Aᵀr = solver.workspace.Aᵀr .= A' * r
  for (k, v) in kwargs
    if haskey(solver.params, k)
      solver.params[k] = v
    end
  end

  α = solver.params[:α]
  σ = solver.params[:σ]

  ϵ = atol + rtol * norm(r)
  solved = norm(Aᵀr) < ϵ
  iter = 0
  Δt = time() - t₀
  tired = iter ≥ max_iter > 0|| Δt ≥ max_time > 0

  @info log_header([:iter, :resid, :Aresid], [Int, Float64])
  @info log_row(Any[iter, norm(r), norm(Aᵀr)])

  while !(solved || tired)
    x .+= α * Aᵀr
    α *= σ

    r .= b - A * x
    Aᵀr .= A' * r
    solved = norm(Aᵀr) < ϵ
    iter += 1
    Δt = time() - t₀
    tired = iter ≥ max_iter > 0|| Δt ≥ max_time > 0
    @info log_row(Any[iter, norm(r), norm(Aᵀr)])
  end

  status = :unknown
  if solved
    status = :first_order
  elseif tired
    if Δt ≥ max_time > 0
      status = :max_time
    elseif iter ≥ max_iter > 0
      status = :max_iter
    end
  end

  return LinAlgSolverOutput(status, x, residual = norm(Aᵀr), elapsed_time = Δt, iter = iter)
end
