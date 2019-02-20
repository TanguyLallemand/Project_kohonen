###############################################################################
# Load libraries, import data and init some variables
###############################################################################
library("ggplot2")
library("gridExtra")
setwd(getwd())
# Get functions
if(!exists("generate_a_random_dataset_function", mode="function")) source("./functions.R")
if(!exists("rmsd_function", mode="function")) source("./functions.R")
if(!exists("learning_function", mode="function")) source("./functions.R")
# Import datas
training_dataset_for_block_a <- read.csv("./dataset/training_dataset_for_block_a.phipsi", header=FALSE)
# Init some variables
number_of_neurons<-16
init_rate=0.75
init_radi=2
number_max_iteration=2
list_of_random_vector <- list()
list_of_plot <- list()
neuron_label<-list()
count_iterations <- 0
# Construct random dataset to init kohonen matrix
# Generate a list of random dataset
list_of_random_vector<-generate_a_random_dataset_function()
# Initalize kohonen matrix with random values
kohonen_matrix<-matrix(list_of_random_vector,ncol=sqrt(number_of_neurons),nrow=sqrt(number_of_neurons))
# Give name to every rows and cols to access neurons with dimensions
rownames(kohonen_matrix)<-c('1','2','3','4')
colnames(kohonen_matrix)<-c('1','2','3','4')
# Generate all cells "label" and store them
#neuron_label<-as.list(apply(expand.grid(rownames(kohonen_matrix), colnames(kohonen_matrix)), 1, paste, collapse=""))
count = 1
for (x in 1:sqrt(number_of_neurons)) 
{
    for (y in 1:sqrt(number_of_neurons)) 
    {
        neuron_label[[count]] = c(x,y)
        count = count +1
    }
}
###############################################################################
# Compute Kohonen algorithm
###############################################################################
for(current_iteration in 1:number_max_iteration)
{
    for(i_row in 1:nrow(training_dataset_for_block_a))
    {
        #Update learn_rate and radius at each row of each iteration
        learn_rate<-learning_function(init_rate,((current_iteration-1)*nrow(training_dataset_for_block_a))+i_row,training_dataset_for_block_a)
        learn_radi<-learning_function(init_radi,((current_iteration-1)*nrow(training_dataset_for_block_a))+i_row,training_dataset_for_block_a)
        #Find distance between each vectors of angles of Kohonen Map and the training vector
        rmsd_result<-lapply(list_of_random_vector, rmsd_function, training_dataset_for_block_a=training_dataset_for_block_a[1,])
        #Unlist and create a matrix of distances with dimension of number of neurons
        rmsd_vector<-unlist(rmsd_result)
        rmsd_matrix<-matrix(rmsd_vector,sqrt(number_of_neurons),sqrt(number_of_neurons))
        #Take the index of the winning neuron, it's the neuron that are more similar than the training vector
        win_index<-which(rmsd_matrix==min(rmsd_matrix), arr.ind=TRUE) 
        #Update of angles of Kohonen Map vectors with the equation (be careful at number of parenthesis)
        for (mylist in 1:number_of_neurons)
        {
            distance<-as.numeric(dist(rbind(win_index[1,], neuron_label[[mylist]])))
            print(distance)
            list_of_random_vector[[mylist]]<-(list_of_random_vector[[mylist]]+ ( training_dataset_for_block_a[i_row,]-list_of_random_vector[[mylist]])* (learn_rate*( exp (- ((distance)^2/(2*((learn_radi)^2)) )) ) ))
        }
        kohonen_matrix<-matrix(list_of_random_vector,sqrt(number_of_neurons),sqrt(number_of_neurons))
    }
    
}


# we go through all columns
for(i in 1:sqrt(number_of_neurons))
{
    # we go through all rows
    for(j in 1:sqrt(number_of_neurons))
    {
        # Save current iteration
        count_iterations <- count_iterations+1
        # Get one cell of kohonen matrix
        cell_of_kohonen_matrix<-unlist(kohonen_matrix[i,j])
        # Construct a graph of this cell
        ggplot <- ggplot() + 
            aes(x=seq_along(cell_of_kohonen_matrix), y=cell_of_kohonen_matrix) +
            geom_line(colour="#0072B2")  + geom_hline(yintercept=0, linetype="dashed", color = "red") + 
            ylim(-180, 180) +
            theme(axis.title.x=element_blank(),
                  axis.text.x=element_blank(),
                  axis.ticks.x=element_blank(),
                  axis.title.y=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks.y=element_blank())
        # Save this graph in a list of plot
        list_of_plot[[count_iterations]] <- ggplotGrob(ggplot)
    }
}
# Construct a figure gathering all plots
multiple_graph <- grid.arrange(grobs=list_of_plot, ncol=4, nrow=4)
# Save it in pdf
ggsave(filename="multiple_graph.png", plot=multiple_graph)

