mutable struct DummySolver{T, S} <: AbstractLinAlgSolver{T, S}
  initialized::Bool
  params::Dict
  workspace
end

function SolverCore.parameters(::Type{DummySolver{T, S}}) where {T, S}
  NamedTuple()
end

function SolverCore.are_valid_parameters(::Type{DummySolver})
  return true
end

function DummySolver(problem::LinAlgProblem{T, S}; kwargs...) where {T, S}
  m, n = size(problem.A)
  solver = DummySolver{T, S}(true, Dict{Symbol, Any}(), (x = S(undef, n), r = S(undef, m)))
  return solver
end

function SolverCore.solve!(
  solver::DummySolver{T, S},
  problem::LinAlgProblem{T, S};
  kwargs...,
) where {T, S}
  solver.initialized || error("Solver not initialized.")
  x = solver.workspace.x .= zero(T)
  r = solver.workspace.r .= problem.b

  return LinAlgSolverOutput(:unknown, x, residual = norm(r))
end
