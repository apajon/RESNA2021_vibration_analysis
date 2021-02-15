# RESNA2021_vibration_analysis
measures and vibration analysis

In **`Julia_analysis/`** folder you will find the code to extract datas:

-  **`Main_search_filename.jl`** is used to get file names of measure filenames in **`measures/`** folder
-  **`Main_search_synchro.jl`** is used to get the synchronization time based on shock detection with prony's method, figures are generated and stored in **`save_figure/figure_prony/`** to verify the wellness of shock detection
-  **`Main.jl`** is used to load and readjust them with the time synchronization
-  **`Mais-transferToCSV.jl`** is used to export the analysis results into CSV in **`results/`** folder for statistical analysis

In **`Julia_analysis/script_analysis`** folder you will find the code to analyze data:

- **`analysisPULSE_MTiXsens.jl`** is used to get the ES, RMS and VDV analysis of measures from IMUs
- **`analysisPULSE_Xensor.jl`** is used to get the std and range analysis of CoP
- the generated and savec figure from **`analysisPULSE`** are stored in **`save_figure/figure_SE_RMS_VDV/`** folder

In **`measures/`** folder are stored the measures files from sensors.

In **`results/`** folder are stored the whole ES, RMS, VDV, std and range analysis figures and the statistical **`RankFD`** method analysis results
