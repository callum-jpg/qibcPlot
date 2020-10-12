### Creating QIBC plots
These plot generating R scripts assume you have an identifiable group within your `Nuclei.csv` defined by the metadata of your images/folders. This should be in the `Metadata_FolderName` column of `Nuclei.csv`.



### Plotting
The qibcPlot R scripts currently include two main types of plotting:
 - 3 variable scatter
 - Dot bar plot

Depending on the variables selected, the 3 variable scatter can be used to sort cells based on their stage in the cell cycle and a 3rd variable can be examined in a cell cycle-dependent manner. 

For example: does your drug lead to a phenotype in a certain stage of the cell cycle?

For staging of cells based on G1, S, or G2 phase, you can use DAPI in combination with EdU, PCNA or cyclin A (and probably others).

Dot bar plots are a pretty visualisation to plot the mean intensities and to show the spread of data for every single individual cell recorded.

### Getting started
First, install RStudio and change the working directory to that which contains the `Nuclei.csv` file you want to analyse. Edit the variables in the R Script as described in the script and run. Plots will be saved in their respective folders in the working directory.

### Testing with some example data
In the `example-data` folder you can find an example dataset (`Nuclei.csv`) to play around with. This is a simple dataset with a +/- DNA damage condition which causes DNA damage in S-phase cells. DAPI and PCNA intensities are used to determine cell cycle stage of the cells.




<!---### **Optional:** Data cleaning

Cleaning of the QIBC data can also be a useful task, but generally outliers (such as mis-identified nuclei [eg. two nuclei identified as one]) can be removed with simple trimming of the x- and y-axes. It's also possible to automatically remove some outliers using the 99th percentile.

You can also adjust intensities to remove any background. This is similar to thresholding - calculating the background from the lowest intensity and subtracting this values from all other values. This won't change your plotting result, but it'll make more sense to if your records start at ~1 rather than starting at some random positive integer.

To see some examples of data filtration or thresholding, check out the `data-processing.R` script. These are not required for plotting. --->
