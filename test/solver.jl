@testset "Solver" begin
  mutable struct LinAlgNoSolver{T, S} <: AbstractLinAlgSolver{T, S} end
  solver = LinAlgNoSolver{Float64, Vector{Float64}}()

  function solve!(::LinAlgNoSolver{T, S}, problem::LinAlgProblem) where {T, S}
    x = S(undef, size(problem.A, 2))
    x .= 0
    return LinAlgSolverOutput(:unknown, x, residual = norm(problem.b))
  end

  A = rand(5, 5)
  b = rand(5)
  problem = LinAlgProblem(A, b)
  output = solve!(solver, problem)
  @test output.status == :unknown
  @test output.solution == zeros(5)
  @test output.residual == norm(b)
end
