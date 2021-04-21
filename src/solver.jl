export AbstractLinAlgSolver

"""
    AbstractLinAlgSolver{T, S} <: AbstractSolver{T, S}

Base type of JSO-compliant optimization solvers.
Like `AbstractSolver{T, S}`, a solver must have three member:
- `initialized :: Bool`, indicating whether the solver was initialized
- `params :: Dict`, a dictionary of parameters for the solver
- `workspace`, a named tuple with arrays used by the solver.

In addition, a `Solver{T, S} <: AbstractLinAlgSolver{T, S}` must define the `solve!` function
"""
abstract type AbstractLinAlgSolver{T, S} <: AbstractSolver{T, S} end

function (::Type{Solver})(A, b; kwargs...) where {T, S, Solver <: AbstractLinAlgSolver{T, S}}
  Solver(LinAlgProblem{T, S}(A, b); kwargs...)
end

function (::Type{Solver})(A, b::S; kwargs...) where {S, Solver <: AbstractLinAlgSolver}
  T = eltype(b)
  Solver{T, S}(LinAlgProblem{T, S}(A, b); kwargs...)
end

function (::Type{Solver})(problem::LinAlgProblem{T, S}; kwargs...) where {T, S, Solver <: AbstractLinAlgSolver}
  return Solver{T, S}(problem; kwargs...)
end