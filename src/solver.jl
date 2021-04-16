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

(::Type{S})(A, b; kwargs...) where {S <: AbstractLinAlgSolver} = S(LinAlgProblem(A, b); kwargs...)
