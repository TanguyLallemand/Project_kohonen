source("functions.R")
setwd(getwd())

training_dataset_for_block_a <- read.csv("./dataset/training_dataset_for_block_a.phipsi", header=FALSE)
#list_of_random_vector <- read.csv("~/Documents/Master2/Semestre2/bioinfo_structurale/vetrivel/session3/Project_kohonen/random_file.csv", header=FALSE)
number_of_neurons<-16
list_of_random_vector<-list()
# A loop to generate a random dataset
for (iterator in 1:number_of_neurons) 
{
    # Generate a vector of eight values
    vector_rand <- round(runif(8, min=-180, max=180), digits=0)
    # Save it in a list
    list_of_random_vector[iterator]<-list(vector_rand)
}



# Construction of a matrix for Kohonen map
kohonen_matrix<-matrix(list_of_random_vector,ncol=sqrt(number_of_neurons))


for(x in 1:1)
{
    rmsd_result<-lapply(list_of_random_vector, rmsd, training_dataset_for_block_a=training_dataset_for_block_a[1,])
}



