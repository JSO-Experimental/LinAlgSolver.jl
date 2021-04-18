@testset "Solver" begin
  @testset "Basic tests" begin
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
    @test reset_problem!(problem) === nothing
  end

  @testset "Grid search" begin
    problems = LinAlgProblem[]
    for α = 0.5:0.5:2.0, m = 5:5:20
      x = collect(range(0, 1, length=m))
      y = 1 .+ α * x + cos.(2π * x)
      push!(problems, LinAlgProblem([ones(m) x], y))
    end
    grid_output = grid_search_tune(DummySolver, problems)
    grid_output = grid_output[:]
    sort!(grid_output, by = x -> x[2])
    @test grid_output[1][2][2] == 0 # Solved all problem
    @test grid_output[end][2][2] == length(problems) # Solved no problems
  end
end
