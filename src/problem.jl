export LinAlgProblem

mutable struct LinAlgProblem{T, S}
  A
  b::S
end

function LinAlgProblem(A, b)
  T = eltype(b)
  S = typeof(b)
  LinAlgProblem{T, S}(A, b)
end
