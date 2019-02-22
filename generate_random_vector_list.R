#!/home/storm/anaconda3/envs/rstudio/bin/Rscript

###############################################################################
# Load libraries
###############################################################################
# Library to build more beautiful graphs, if not installed please run install.packages("ggplot2")
library("ggplot2")
# Library to construct a multiple graph object, if not installed please run run install.packages("gridExtra")
library("gridExtra")
# Get argument using this parser if not installed please run run install.packages("optparse")
library("optparse")

###############################################################################
# Setup argument parser
###############################################################################
option_list <- list(
    make_option(c("-r", "--rate"), action="store_true", type="numeric", default=0.75,
                help="give initial learn rate"),
    make_option(c("-t", "--radius"), action="store_true", type="numeric", default=2.0,
                help="give initial learn radius"),
    make_option(c("-n", "--number_iteration"), action="store_true", type="integer", default=2, 
                help="give number of iterations")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);
print(opt$rate)

###############################################################################
# Load functions, init some variables
###############################################################################
# Library to build more beautiful graphs, if not installed please run install.packages("ggplot2")
library("ggplot2")
# Library to construct a multiple graph object, if not installed please run run install.packages("gridExtra")
library("gridExtra")
# Set current path
setwd(getwd())
# Get functions from library file
if(!exists("generate_a_random_dataset_function", mode="function")) source("./functions.R")
if(!exists("rmsd_function", mode="function")) source("./functions.R")
if(!exists("learning_function", mode="function")) source("./functions.R")
if(!exists("generate_all_possible_combinations", mode="function")) source("./functions.R")
if(!exists("construct_and_save_plots", mode="function")) source("./functions.R")

# Configuration of parameters for algorithm, using passed informations by argument
number_of_neurons<-16
init_rate=opt$rate
initial_radius=opt$radius
number_max_iteration=opt$number_iteration
# Construct name of output file using those variables
paste(s1, s2, sep = "")
###############################################################################
# Import datas, generate a random datatset
###############################################################################
# Import datas
training_dataset_for_block_a <- read.csv("./dataset/training_dataset_for_block_a.phipsi", header=FALSE)
# Construct random dataset to init kohonen matrix
# Generate a list of random dataset
list_of_random_vector<-generate_a_random_dataset_function()
# Initalize kohonen matrix with random values
kohonen_matrix<-matrix(list_of_random_vector,ncol=sqrt(number_of_neurons),nrow=sqrt(number_of_neurons))
# Give name to every rows and cols to access neurons with dimensions
rownames(kohonen_matrix)<-c('1','2','3','4')
colnames(kohonen_matrix)<-c('1','2','3','4')
# Generate all cells "label" and store them
neuron_label<- generate_all_possible_combinations(number_of_neurons)

###############################################################################
# Compute Kohonen algorithm
###############################################################################
for(current_iteration in 1:number_max_iteration)
{
    for(i_row in 1:nrow(training_dataset_for_block_a))
    #for(i_row in 1:100)
    {
        print(i_row)
        # Update learn_rate, based on the degree of progress of the algorithm, this allows to strengthen the solutions and thus allow a better convergence
        learn_rate<-learning_function(init_rate,((current_iteration-1)*nrow(training_dataset_for_block_a))+i_row,training_dataset_for_block_a)
        # Update learn_radius
        learn_radius<-learning_function(initial_radius,((current_iteration-1)*nrow(training_dataset_for_block_a))+i_row,training_dataset_for_block_a)
        # Find distance between each vectors of angles from Kohonen Map and current vector from the training dataset
        closest_cell <- rmsd_function(kohonen_matrix,training_dataset_for_block_a)
        # For every neurons, reconstruct a new matrix based on learning function
        for (mylist in 1:number_of_neurons)
        {
            # Get distance of best neuron from current neuron
            distance<-as.numeric(dist(rbind(closest_cell, neuron_label[[mylist]])))
            # Reconstruct a new matrix
            list_of_random_vector[[mylist]]<-(list_of_random_vector[[mylist]]+ ( training_dataset_for_block_a[i_row,]-list_of_random_vector[[mylist]])* (learn_rate*( exp (- ((distance)^2/(2*((learn_radius)^2)) )) ) ))
        }
        # Update kohonen map with new matrix juste generated
        kohonen_matrix<-matrix(list_of_random_vector,sqrt(number_of_neurons),sqrt(number_of_neurons))
    }
}
# save results
construct_and_save_plots(number_of_neurons, kohonen_matrix)

