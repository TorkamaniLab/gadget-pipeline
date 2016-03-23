#! /bin/bash 
# Go into a new patient's dir (already cleaned of headers) 
# and cut the signal into bits and run the analysis on each.

`mkdir breakdown`
`cat data_parsed.cleaned.csv |python ~/Dropbox/Scripps/projects/cutter.py
breakdownk/data.cleaned -t 80`
`cd breakdown`
`ls |parallel -j0 python
~/Dropbox/Scripps/projects/frequency_analyzer/frequency_analyzer.py -i {} -o
{}.analyzed.csv -rne`
