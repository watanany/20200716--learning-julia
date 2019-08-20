# 統計学入門 13章

using Printf: @printf
using Statistics: mean
using CSV

data = CSV.read("./data.csv")

n = size(data, 1)
X = data.前日の福岡の気圧
Y = data.東京の気圧
X̅ = mean(X)
Y̅ = mean(Y)

# @show X, X̅
# @show X .- X̅
# @show Y, Y̅
# @show Y .- Y̅

β̂₂ = sum((X .- X̅) .* (Y .- Y̅)) / sum((X .- X̅).^2)
β̂₁ = Y̅ - β̂₂ * X̅
Ŷ = β̂₁ .+ β̂₂ .* X
ê = Y - Ŷ
s² = sum(ê.^2 ./ (n - 2))
s = sqrt(s²)
η² = 1 - sum(ê.^2) / sum((Y .- Y̅).^2) # = sum((Ŷ - Y̅).^2) / sum((Y - Y̅).^2)
SE_β̂₁ = s * sqrt(sum(X.^2) / (n * sum((X .- X̅).^2)))
SE_β̂₂ = s / sqrt(sum((X .- X̅).^2))

@printf("標本回帰方程式[sample regression equation]\tŶ = %.2f + %.2fX\n", β̂₁, β̂₂)
@printf("推定値の標準誤差[standard error of estimates]\ts.e. = %.2f\n", s)
@printf("β̂₁の標準誤差[standard error of β̂₁]\ts.e.(β̂₁) = %.2f\n", SE_β̂₁)  # あまり使わないらしい
@printf("β̂₂の標準誤差[standard error of β̂₂]\ts.e.(β̂₂) = %.2f\n", SE_β̂₂)
@printf("決定係数[coefficient of determination]\tη² = %.2f\n", η²)
