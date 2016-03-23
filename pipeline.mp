# Pipeline for Gadget PD trial.
# - Built using metapipe.
# 
# author: Brian Schrader
# since 2016-03-22

[COMMANDS]
##################################################
##################################################

# Retrieve the sample data
sh $API $SAMPLE 'Pebble Accelerometer' > {o.zip}
zcat {1.1} > {o.data.raw.csv}

# Clean the data
sed '1d' {2.1} > {o}
sh $CLEAN {3.1} {o.data.cleaned.csv}

##################################################

# Preliminary Analysis
mkdir breakdown analysis
python $CUTTER -t 80 -i {4.1} -o breakdown/data.cut #{o:breakdown}
cd {6.1}; ls | parallel -I [] python $FREQ_ANALYZER -i [] -o [].analyzed.csv -rne #{o:breakdown/*.analyzed.csv}

# Energy Analysis
bash $ENERGY_EXTRACT {7.1} > {o.extracted.energies.csv}
bash $CONVERT {8.1} {o.extracted.energies.cleaned.csv}
Rscript $args$feature_TIME --feature Energy --graph-name energy_per_time {9.1} > {o.energy_per_day.txt}

# Average Amp Analysis
bash $AVGAMP_EXTRACT {7.1} > {o.extracted.avg_amp.csv}
bash $CONVERT {11.1} {o.extracted.avg_amp.cleaned.csv}
Rscript $args$feature_TIME --feature Average_Amplitude --graph-name avgamp_per_time {12.1} > {o.avgamp_per_day.txt}

# Max Amp Analysis
bash $MAXAMP_EXTRACT {7.1} > {o.extracted.max_amp.csv}
bash $CONVERT {14.1} {o.extracted.max_amp.cleaned.csv}
Rscript $args$feature_TIME --feature Max_Amplitude --graph-name maxamp_per_time {15.1} > {o.maxamp_per_day.txt}

##################################################

# Comparison with Medications
bash $API $SAMPLE 'Took Medication' | zcat > {o}
bash $CLEAN {17.1} {o.medication.cleaned.csv}
bash $FORMAT_MEDS {18.1} > {o.medication.formatted.csv}

bash $COMPARE_MEDS {19.1} {9.1} > {o.energy_and_meds.csv}
bash $COMPARE_MEDS {19.1} {12.1} > {o.avg_amp_and_meds.csv}
bash $COMPARE_MEDS {19.1} {15.1} > {o.max_amp_and_meds.csv}

Rscript $args$feature_SINCE_MEDS --feature Energy --graph-name energy_since_meds {20.1} > {o.energy_since_meds.txt}
Rscript $args$feature_SINCE_MEDS --feature Average_Amplitude --graph-name avgamp_since_meds {21.1} > {o.avgamp_since_meds.txt}
Rscript $args$feature_SINCE_MEDS --feature Max_Amplitude --graph-name maxamp_since_meds {22.1} > {o.maxamp_since_meds.txt}

##################################################
##################################################
## CHANGE THE SAMPLE NAME
[PATHS]
$SAMPLE __sample_id__

$API bin/raw_req.sh
$CLEAN bin/fix_intel_data.sh
$CUTTER ~/Dropbox/Scripps/projects/cutter.py
$FREQ_ANALYZER ~/Dropbox/Scripps/projects/pd_predict/frequency_analyzer/frequency_analyzer.py
$CONVERT bin/convert_times.sh

$ENERGY_EXTRACT bin/extract_energy.sh
$MAXAMP_EXTRACT bin/extract_maxamp.sh
$AVGAMP_EXTRACT bin/extract_avgamp.sh

$FORMAT_MEDS bin/format_meds.sh
$COMPARE_MEDS bin/compare_meds.sh
$args$feature_TIME bin/feature_per_time.r
$args$feature_SINCE_MEDS bin/feature_since_meds.r
