using DataFrames, DataFramesMeta

train = readtable("N\ Brown\ Student\ Challenge/uc_data_train.csv")

womenswear_ticks = sort(unique(train[:size_womenswear]))
brief_ticks = sort(unique(train[:size_corsetry_briefs]))

whiteblueblack = ColorGradient([RGB(1.0,1.0,1.0),RGB(0.3,0.3,0.8),RGB(0.0,0.0,0.0)],[0.0,0.5,1.0])

function hist(df)
    plot(xticks=brief_ticks, yticks=womenswear_ticks, xlab="Brief size", ylab="Womenswear size")
    histogram2d!(df[:size_corsetry_briefs], df[:size_womenswear], color=whiteblueblack, bins=(6:4:50, 6:4:38))
end

function fit_and_plot_lm()
    model = lm(@formula(size_womenswear ~ size_corsetry_briefs), train)
    plot(xticks=brief_ticks, yticks=womenswear_ticks, xlab="Brief size", ylab="Womenswear size")
    histogram2d!(train[:size_corsetry_briefs], train[:size_womenswear], color=whiteblueblack, bins=(6:4:50, 6:4:38))
    lobf(x) = coef(model)[1] + coef(model)[2]*x
    plot!(8:48, lobf, label="Line of best fit")
end

function plot_marginalhist()
    marginalhist(train[:size_corsetry_briefs], train[:size_womenswear],
                 color=whiteblueblack, bins=(6:4:50, 6:4:38), xticks=brief_ticks, yticks=womenswear_ticks,
                 xlab="Brief size", ylab="Womenswear size")
end

nearest_size(x) = convert(Int,4*round(x/4))

function rate_naive(df=train)
    errs = min.(df[:size_corsetry_briefs],36) .- df[:size_womenswear]
    rmse = norm(min.(df[:size_corsetry_briefs],36) .- df[:size_womenswear])^2/size(df,1)

    correct = count(err->err==0, errs)
    accuracy = correct/size(df,1)

    println()
    println("Proportion correct $accuracy, RMSE $rmse")
    println()

    (accuracy, correct)
end

function fit_and_rate_lm(df=train)
    model = lm(@formula(size_womenswear ~ size_corsetry_briefs + size_corsetry_cup), df)
    errs = nearest_size.(predict(model)) .- df[:size_womenswear]
    rmse = norm(predict(model) .- df[:size_womenswear])^2/size(df,1)

    correct = count(err->err==0, errs)
    accuracy = correct/size(df,1)

    println()
    println("Proportion correct $accuracy, RMSE $rmse")
    println()

    (accuracy, correct, model)
end

function fit_and_rate_lm_separate_brands()
    (_, c1, _) = fit_and_rate_lm(@where train :brand .== "Brand 1")
    (_, c2, _) = fit_and_rate_lm(@where train :brand .== "Brand 2")
    (_, c3, _) = fit_and_rate_lm(@where train :brand .== "Brand 3")
    (_, c4, _) = fit_and_rate_lm(@where train :brand .== "other")

    overall_accuracy = (c1+c2+c3+c4)/size(train,1)

    println()
    println("Overall proportion correct $overall_accuracy")
    println()

end
