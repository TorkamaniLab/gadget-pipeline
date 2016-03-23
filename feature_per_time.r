# Given a feature_data set called *.clean.csv, do ANOVA analysis on it.
suppressPackageStartupMessages(library("argparse"))

main = function() {
    parser = ArgumentParser()
    
    parser$add_argument("input", help="A cleaned collected energies file.")
    parser$add_argument("-f", "--feature", help="The feature name being analyzed. This is used in the graph legend.")
    parser$add_argument("-g", "--graph-name", help="The desired graph output names", 
        default="plots.pdf")
    args = parser$parse_args()

    file = dir()[grep(args$input, dir())]
    feature_data = read.csv(file, header=TRUE)    
    times = as.numeric(feature_data$time_of_day)     
    
    # Consider the bins independent.
    anova.et = aov(feature_data$X3.125.6.25Hz ~ times, data=feature_data)
    anova.pd = aov(feature_data$X6.25.12.5Hz ~ times, data=feature_data)

    min_axis = min(feature_data$X3.125.6.25Hz, feature_data$X6.25.12.5Hz)
    max_axis = max(feature_data$X3.125.6.25Hz, feature_data$X6.25.12.5Hz)
    # Graph results
    title = "3.125-6.25Hz by Time Period"
    print(title)
    print(summary(anova.et))
    png(paste(args$graph_name, "3.125.6.25Hz.png", sep="_"))
    boxplot(feature_data$X3.125.6.25Hz ~ times, data=feature_data,
            xlab="Morning, Afternoon, Evening", ylab=args$feature, 
            main=title, ylim=c(min_axis, max_axis))
    dev.off()
    title = "6.25-12.5Hz by Time Period"
    print(title)
    print(summary(anova.pd))
    png(paste(args$graph_name, "6.25.12.5Hz.png", sep="_"))
    boxplot(feature_data$X6.25.12.5Hz ~ times, data=feature_data,
            xlab="Morning, Afternoon, Evening", ylab=args$feature, 
            main=title, ylim=c(min_axis, max_axis))
    dev.off()
}

main()

