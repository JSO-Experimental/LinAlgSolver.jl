export LinAlgSolverOutput

SolverCore.solver_output_type(::Type{<: AbstractLinAlgSolver{T, S}}) where {T, S} = LinAlgSolverOutput{T, S}
SolverCore.solver_output_type(::Type{<: AbstractLinAlgSolver}) = LinAlgSolverOutput{Number, Any}

mutable struct LinAlgSolverOutput{T, S} <: AbstractSolverOutput{T, S}
  status::Symbol
  solution::S
  residual::T
  iter::Int
  elapsed_time::Float64
  solver_specific::Dict{Symbol, Any}
end

function LinAlgSolverOutput(status::Symbol, solution::S; kwargs...) where {S}
  LinAlgSolverOutput{eltype(solution)}(status, solution; kwargs...)
end

function LinAlgSolverOutput{T}(
  status::Symbol,
  solution::S;
  residual::T,
  iter::Int = -1,
  elapsed_time::Float64 = Inf,
  solver_specific::Dict = Dict{Symbol, Any}(),
) where {T, S}
  if !(status in keys(SolverCore.STATUSES))
    @error "status $status is not a valid status. Use one of the following: " join(
      keys(STATUSES),
      ", ",
    )
    throw(KeyError(status))
  end
  return LinAlgSolverOutput{T, S}(status, solution, residual, iter, elapsed_time, solver_specific)
end
