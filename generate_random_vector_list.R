###############################################################################
# Load libraries, init some variables
###############################################################################
library("ggplot2")
library("gridExtra")
setwd(getwd())
# Get functions
if(!exists("generate_a_random_dataset_function", mode="function")) source("./functions.R")
if(!exists("rmsd_function", mode="function")) source("./functions.R")
if(!exists("learning_function", mode="function")) source("./functions.R")
if(!exists("generate_all_possible_combinations", mode="function")) source("./functions.R")
# Configuration of parameters for algorithm
number_of_neurons<-16
init_rate=0.75
init_radi=0.5
number_max_iteration=2
# Inititialization of variables
list_of_random_vector <- list()
list_of_plot <- list()
neuron_label<-list()


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
    #for(i_row in 1:nrow(training_dataset_for_block_a))
    for(i_row in 1:100)
    {
        # Update learn_rate
        learn_rate<-learning_function(init_rate,((current_iteration-1)*nrow(training_dataset_for_block_a))+i_row,training_dataset_for_block_a)
        # Update learn_radius
        learn_radius<-learning_function(init_radi,((current_iteration-1)*nrow(training_dataset_for_block_a))+i_row,training_dataset_for_block_a)
        #Find distance between each vectors of angles of Kohonen Map and the training vector
        best_neuron_for_iter <- rmsd_function(kohonen_matrix,training_dataset_for_block_a)
        print(paste0("best neuron",best_neuron_for_iter))
        #Update of angles of Kohonen Map vectors with the equation (be careful at number of parenthesis)
        for (mylist in 1:number_of_neurons)
        {
            distance<-as.numeric(dist(rbind(best_neuron_for_iter, neuron_label[[mylist]])))
            list_of_random_vector[[mylist]]<-(list_of_random_vector[[mylist]]+ ( training_dataset_for_block_a[i_row,]-list_of_random_vector[[mylist]])* (learn_rate*( exp (- ((distance)^2/(2*((learn_radius)^2)) )) ) ))
        }
        kohonen_matrix<-matrix(list_of_random_vector,sqrt(number_of_neurons),sqrt(number_of_neurons))
    }
}

construct_and_save_plots(number_of_neurons, kohonen_matrix)

