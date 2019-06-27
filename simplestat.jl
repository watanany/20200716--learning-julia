using Printf: @printf
using RDatasets: dataset
using StatsBase: sample
using Statistics: mean, var, std
using DataFrames: axes


function describe_population(ω)
  μ = mean(ω)
  σ² = var(ω; corrected = false)
  @printf("(μ, σ²) = (%.2f, %.2f)\n", μ, σ²)
end


function describe_sample(ω, xs)
  μ = mean(ω)
  n = length(xs)
  x̄ = mean(xs)
  s² = var(xs)
  s = std(xs)
  se = s / √(n)
  t = (x̄ - μ) / se
  @printf("(n, x̄, s², 2SD, 2SE, x̄ - 2SE, x̄ + 2SE) = (%2d, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f)\n", n, x̄, s², 2s, 2se, x̄ - 2se, x̄ + 2se)
end


function samples(ω, n_samples; sample_size = 10)
  [sample(ω, sample_size, replace = false) for i in 1:n_samples]
end


function tstat(xs, μ)
  n = length(xs)
  x̄ = mean(xs)
  s = std(xs)
  se = s / √(n)
  (x̄ - μ) / se
end


function main()
  iris = dataset("datasets", "iris")

  setosa = iris[iris.Species .== "setosa", :]
  virginica = iris[iris.Species .== "virginica", :]
  versicolor = iris[iris.Species .== "versicolor", :]

  ω = virginica[:SepalLength]
  describe_population(ω)

  for xs in samples(ω, 30)
    describe_sample(ω, xs)
  end

  μ = mean(ω)
  ts = [tstat(xs, μ) for xs in samples(ω, 300)]
  @printf("(mean(ts), std(ts)) = (%.2f, %.2f)\n", mean(ts), std(ts))
end


main()
