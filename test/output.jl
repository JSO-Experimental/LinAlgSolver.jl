@testset "LinAlgOutput" begin
  @testset "Show" begin
    output = LinAlgSolverOutput(
      :first_order,
      ones(100),
      residual = 1e-6,
      iter = 10,
      solver_specific = Dict(
        :matvec => 10,
        :dot => 25,
        :empty_vec => [],
        :small_vec => [2.0; 3.0],
        :axpy => 20,
        :ray => -1 ./ (1:100),
      ),
    )

    io = IOBuffer()
    show(io, output)
    @test String(take!(io)) ==
          "Solver output of type LinAlgSolverOutput{Float64, Vector{Float64}}\nStatus: first-order stationary\n"
  end

  @testset "Test throws" begin
    @test_throws Exception LinAlgSolverOutput(:bad, zeros(2))
    @test_throws Exception LinAlgSolverOutput(:unkwown, zeros(2), bad = true)
  end

  @testset "Testing Dummy Solver with multi-precision" begin
    for T in (Float16, Float32, Float64, BigFloat)
      A = rand(T, 5, 5)
      b = rand(T, 5)
      problem = LinAlgProblem(A, b)
      solver = DummySolver(problem)
      output = with_logger(NullLogger()) do
        solve!(solver, problem)
      end
      @test eltype(output.solution) == T
      @test typeof(output.residual) == T
    end
  end
end
