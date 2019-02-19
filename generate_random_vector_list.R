source("functions.R")
setwd(getwd())

# Import datas
training_dataset_for_block_a <- read.csv("./dataset/training_dataset_for_block_a.phipsi", header=FALSE)
# Init some variables
number_of_neurons<-16
init_rate=0.75 # Decrease with training time
init_radi=2 # Decrease with training time
iteration=3
# Generate a list of random dataset
list_of_random_vector<-generate_a_random_dataset_function()

# Construction of a matrix for Kohonen map
kohonen_matrix<-matrix(list_of_random_vector,ncol=sqrt(number_of_neurons))

for(x in 1:1)
{
    rmsd_result<-lapply(list_of_random_vector, rmsd_function, training_dataset_for_block_a=training_dataset_for_block_a[1,])
}

#Unlist and create a matrix of distances
rmsda_vector<-unlist(rmsda_phipsi_A)
rmsda_matrix<-matrix(rmsda_vector,sqrt(borne),sqrt(borne))
#Take the index of the winning neuron, it's the neuron that are more similar than the training vector
win_index<-which(rmsda_matrix==min(rmsda_matrix), arr.ind=TRUE) 


