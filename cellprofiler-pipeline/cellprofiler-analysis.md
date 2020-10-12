# Image Analysis
### Using CellProfiler to quantitatively measure microscopy images

The [CellProfiler website offers an immense trove of resources](https://cellprofiler.org/home) for the creation of your own analysis pipelines. For the understanding of individual modules and workflow of CellProfiler, the aforementioned resource is invaluable.

Here, the aim is to introduce a simple pipeline for the identification of DAPI stained nuclei using Otsu thresholding and the recording of intensity values for 4 fluorophore channels (eg. DAPI, GFP, mCherry, and Cy5).

### Initial considerations at the microscope
Ensure that the acquisition of images is unbiased and exposures are consistent on your microscope of choice. While an automated stage is not necessary, it helps immensely. Exposures should be adjusted so that the maxinum bit depth of your microscope detector is not saturated, but is comfortably close (eg. 80-90% of maximum) so you can get the most out of your images.

Furthermore, it's a good idea to ensure you have >1,000 cells imaged per condition (particularly important for 3var plots). For example, a workflow with U2OS cells at ~70-80% confluency required approximately 50 images per condition at 20x magnification for 1,000-2,000 images. Generally, it's better to record more cells than you need since you can trim the data later so you have a similar number of cells for each condition.

This also plays into the CellProfiler philosophy: **Measure everything, ask questions later.** As in, later you can trim out cells you don't need.

### File sorting with metadata
This pipeline and subsequent plotting with R relies on the presence of metadata to automatically subset different imaging conditions within one imaging dataset. To do so, place your images sets for each condition into individual folders with an appropriate name - it's this folder name (Metadata_FolderName in `Nuclei.csv`) which will be extracted using REGEX and used later when plotting.

Once images are arranged, drop the folders containing the microscopy images into CellProfiler.

### Pipeline considerations
Import the pipeline `qibc-pipeline.cppipe` into CellProfiler.

First, ensure in the `NamesAndTypes` section that the channel identifying words in your filename are correctly being read to identify the different channels of your IF experiment. For example, an image name with `DAPI` in it should be recognised by CellProfiler as the `dapichannel`.

In the `IdentifyPrimaryObjects ` module, run a test and make sure that the object sites captures your nuclei accurately and adjust accordingly.

This pipeline also uses `RescaleIntensity` to adjust the intensity of images from 12-bit to 16-bit. If you don't require this, remove these modules.

The `MeasureObjectIntensity` module will measure the intensity for the other image channels identified by `NamesAndTypes`. Remove or add any additional channels that you require.

Finally, in `ExportToSpreadsheet` change the path you wish to save the analysis output to.

For analysis, we will use the `Nuclei.csv` file.







### References
McQuin C, Goodman A, Chernyshev V, Kamentsky L, Cimini BA, Karhohs KW, Doan M, Ding L, Rafelski SM, Thirstrup D, Wiegraebe W, Singh S, Becker T, Caicedo JC, Carpenter AE (2018). CellProfiler 3.0: Next-generation image processing for biology. PLoS Biol. 16(7):e2005970 / doi. PMID: 29969450 (Research article)
