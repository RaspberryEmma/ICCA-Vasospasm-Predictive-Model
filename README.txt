Hiya!

So in terms of the provided code, to re-run the tests, one does the following:
 - Run every "construct" sql file and save the final table of results manually in "Data" (observe existing file names!)
 - Run "ConstructDataSummary.R" in RStudio (saving is automated under "Data", be careful of working directories!)
 - Run "VasospasmGLMModel.R" and/or "VasospasmLogisticModel.R" to see results (which also save automatically under "Graphs")

Some PowerShell scripts are provided to help with automating running SQL files, though automation is non-trivial and would require a fair amount of additional time to implement.
In terms of extension, the SQL and R code are left verbose and easily extensible towards the goal of checking more possible predictors in future.

Lastly, in accordance with NDA, all data is absent.
As such, this model is provided "code only" alongside regression coefficients.
As with the previous work we build from, we invite external researchers to request access to the data via formal research ethics approval.

All the best,
Emma
