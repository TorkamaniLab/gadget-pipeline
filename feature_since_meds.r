# Given a feature_data set called *.clean.csv, do lin_mod analysis on it.
suppressPackageStartupMessages(library("argparse"))

main = function() {
    parser = ArgumentParser()
    
    parser$add_argument("input", 
        help="A data set of the values and time since any medications taken by a given user.")
    parser$add_argument("-f", "--feature", 
        help="The feature name being analyzed. This is used in the graph legend.")
    parser$add_argument("-g", "--graph-name", 
        help="The desired graph output names", default="plots")
    args = parser$parse_args()

    file = dir()[grep(args$input, dir())]
    feature_data = read.csv(file, header=TRUE)    
    
    times = as.numeric(feature_data$time)     
    since_med = feature_data$time_since_med     
    
    # Consider the bins independent.
    lin_mod.et = lm(feature_data$X3.125.6.25Hz ~ times + since_med, data=feature_data)
    lin_mod.pd = lm(feature_data$X6.25.12.5Hz ~ times + since_med, data=feature_data)

    min_axis = min(feature_data$X3.125.6.25Hz, feature_data$X6.25.12.5Hz)
    max_axis = max(feature_data$X3.125.6.25Hz, feature_data$X6.25.12.5Hz)
    # Graph results
    title = paste(args$feature, "3.125-6.25Hz by Time since medication")
    print(title)
    print(summary(lin_mod.et))
    png(paste(args$graph_name, "3.125.6.25Hz.png", sep="_"))
    plot(feature_data$X3.125.6.25Hz ~ times + since_med, data=feature_data,
            main=title, ylim=c(min_axis, max_axis),
            xlab="Time since medication", 
            ylab=args$feature)
    dev.off()

    title = paste(args$feature, "6.25-12.5Hz by Time since medication")
    print(title)
    print(summary(lin_mod.pd))
    png(paste(args$graph_name, "6.25.12.5Hz.png", sep="_"))
    plot(feature_data$X6.25.12.5Hz ~ times + since_med, data=feature_data,
            main=title, ylim=c(min_axis, max_axis),
            xlab="Time since medication", 
            ylab=args$feature)
    dev.off()
}

main()

