# 統計学入門 13章

using Printf: @printf
using GLM: @formula, lm, coef, stderror
using CSV

data = CSV.read("./data.csv")
ols = lm(@formula(東京の気圧 ~ 前日の福岡の気圧), data)  # 最小二乗法[Ordinary Least Squares regression](?)

β̂₁, β̂₂ = coef(ols)
SE_β̂₁, SE_β̂₂ = stderror(ols)

@printf("標本回帰方程式[sample regression equation]\tŶ = %.2f + %.2fX\n", β̂₁, β̂₂)
@printf("β̂₁の標準誤差[standard error of β̂₁]\ts.e.(β̂₁) = %.2f\n", SE_β̂₁)
@printf("β̂₂の標準誤差[standard error of β̂₂]\ts.e.(β̂₂) = %.2f\n", SE_β̂₂)
