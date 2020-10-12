library(data.table) # For laoding Nuclei.csv
library(ggplot2) # For creating plots
library(dplyr) # For creating data subsets
library(scales) # For adjusting colour limits on plots
library(RColorBrewer) # For creating nice colour palettes for colouring points

####  VARIABLES ####
# Here, add the name of the file you want to analyse
input_file <- 'Nuclei.csv'

# Metadata column to extract string names from input_file. These will have been extracted
# from the parent folder of the images analysed by CellProfiler
metadata <- 'Metadata_FolderName'

## Axis of choice and appropriate labels
# IntegratedIntensity == Total intensity
# MeanIntensity == Mean intensity
# For 3var, you want to use total DAPI and mean for everything else
x.axis <- 'Intensity_IntegratedIntensity_rescaledapichannel'
y.axis <-  'Intensity_MeanIntensity_rescalecy5channel'
point.colour <- 'Intensity_MeanIntensity_rescalemcherrychannel'

# What would you like the plot labels for each variable to say?
x.axis.label <- 'Total DAPI intensity per nucleus (A.U)'
y.axis.label <- 'Mean PCNA intensity per nucleus (A.U.)'
colour.label <- 'Mean yH2AX'

# Filename
# Select what the output filename will be
file.name <- 'DAPI vs PCNA with yH2AX colour'

# Read the data and count the number of rows
# stringsAsFactors added so that Metadata_FolderName strings can be read by 'levels'
input_data <- fread(input_file, stringsAsFactors = TRUE)
sample_number <- nrow(input_data)

# Gather the condition names as defined by your metadata column
condition_names <- levels(input_data[, get(metadata)])

# Set plot order
# Here, the selected order is based upon the example data set metadata
plot.order <- c('-Treatment', '+Treatment')
# Update metadata levels to dictated plotting order
input_data[[metadata]] <- factor(input_data[,get(metadata)], levels = plot.order)

# Set axis c(min, max) limits
x.mm <- c(2e6, 9e6)
y.mm <- c(70, 1500)
# Point colour c(min, max)
point.mm <- c(0, 5000)

### Dot bar plot setup
# Dot bar plots will add a line on each bar which represents the mean 
# intensity for each condition. The dot bar plot will also plot the
# desired y.axis variable for all conditions in one plot. 

# Plot bar dot plot? TRUE or FALSE
# If true, the values plotted on the bar plot will be filtered to be those
# which are within your limits as defined by the 3var plot x.mm and y.mm
bar_plot <- TRUE

# For bar plots, the x-axis will be condition names and the y axis will
# be whatever you select below
bar.y.axis <- 'Intensity_MeanIntensity_rescalemcherrychannel'
bar.y.axis.label <- 'Mean yH2AX intensity (A.U.)'
bar.y.lim <- c(0, 5000)
bar.file.name <- 'yH2AX dot bar plot'

### AUTOMATED ### 
## Below, the code should hopefully run automatically
# Edit as desired to alter plotting

# Saving directories
dir.create('3var plots')
dir.create('dot bar plots')

# Orange, red, blue, pink, purple, green, gray
colour.palette <- c('#ffb86c', '#ff5555', '#8be9fd', '#ff79c6', '#bd93f9', '#50fa7b', '#ebebeb')
gray.to.red <- colorRampPalette(c(colour.palette[c(7, 1, 2)]))
gray.to.green <- colorRampPalette(c(colour.palette[c(7, 6)]))


for (i in condition_names) {
  print(i)
  plot <- ggplot(input_data[get(metadata) == i], aes_string(x = x.axis, y = y.axis, fill = point.colour)) +
    geom_point(shape = 21, size = 4, colour = "#aaaaaa", stroke = 0.5) +
    scale_fill_gradientn(colours = gray.to.red(3), 
                         values = c(0, 0.3, 1),
                         limits = point.mm, 
                         oob = scales::squish # 'Squishes' values outside of upper limit to be highest value. Delete if required. 
    ) +
    xlim(x.mm) +
    scale_y_log10(limits = y.mm) +
    labs(x = x.axis.label,
         y = y.axis.label,
         fill = colour.label,
         title = i,
         subtitle = paste(nrow(input_data[Metadata_FolderName == i &
                                            get(x.axis) %inrange% x.mm &
                                            get(y.axis) %inrange% y.mm]), "cells")) +
    theme_minimal() +
    theme(text = element_text(size=40),
          axis.text.x = element_text(angle=20, hjust=1),
          # Remove gridlines
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank(),
          axis.line.x = element_line(color="gray70", size = 1),
          axis.line.y = element_line(color="gray70", size = 1),
          legend.text = element_text(size = 20))
  
  ggsave(plot = plot,
         filename = paste0(i, ' - ', file.name, '.png'), # Change name to suit
         path = '3var plots',
         units = "cm",
         height = 30,
         width = 35,
         dpi = 300
  )
}


if (bar_plot == TRUE) {
      # Create a new dataset that filters to cells that are in the 3var plot focus
      data_list <- list()
      for (i in condition_names) {
        #print(i)
        loop_data <- input_data[get(metadata) == i] %>%
          filter(get(x.axis) %inrange% x.mm) %>%
          filter(get(y.axis) %inrange% y.mm) %>%
          filter(get(point.colour) %inrange% point.mm)
        data_list[[i]] <- as.data.table(loop_data)
      }
      input_data_filtered <- do.call(rbind, data_list)
      
      
      ## dot-bar plots
      p1 <- ggplot(input_data_filtered, 
             aes_string(x = metadata, y = point.colour, fill = point.colour)) +
        geom_jitter(shape = 21, width = 0.35) +
        scale_fill_gradientn(colours = gray.to.red(3),
                             #values = c(0, 0.8, 1),
                             #values = scales::rescale(c(-0.5, -0.05, 0, 0.05, 0.5)),
                             values = scales::rescale(c(-1, -0.5, 0, 0.5, 1)),
                             limits = bar.y.lim,
                             oob = scales::squish) +
        ylim(bar.y.lim) +
        labs(title = '',
             x = '',
             y = bar.y.axis.label) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle=90, hjust=1, size = 15),
              axis.text.y = element_text(size = 15),
              axis.title.x = element_text(size = 15),
              axis.title.y = element_text(size = 12.5),
              panel.grid.major.x = element_blank(),
              legend.position = "none") +
        stat_summary(fun = mean, geom = "errorbar", 
                     aes(ymax=..y.., ymin=..y..), width = 0.75, colour = colour.palette[3], size = 1) 
      
      ggsave(plot = p1,
             filename = paste0(bar.file.name, '.png'),
             path = 'dot bar plots',
             units = 'cm',
             width = 10,
             height = 10,
             dpi = 300)
} else {print('No bar plots requested')}






