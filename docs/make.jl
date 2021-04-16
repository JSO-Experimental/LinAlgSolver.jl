using Documenter, LinAlgSolver

makedocs(
  modules = [LinAlgSolver],
  doctest = true,
  linkcheck = true,
  strict = true,
  format = Documenter.HTML(
    assets = ["assets/style.css"],
    prettyurls = get(ENV, "CI", nothing) == "true",
  ),
  sitename = "LinAlgSolver.jl",
  pages = ["Home" => "index.md", "API" => "api.md", "Reference" => "reference.md"],
)

deploydocs(
  repo = "github.com/JuliaSmoothOptimizers/LinAlgSolver.jl.git",
  push_preview = true,
  devbranch = "main",
)
