training_dataset_for_block_a <- read.csv("~/Documents/Master2/Semestre2/bioinfo_structurale/vetrivel/session3/Project_kohonen/dataset/training_dataset_for_block_a.phipsi", header=FALSE)
number_of_neurons<-16
list_of_random_vector<-list()
# A loop to generate a random dataset
for (iterator in 1:number_of_neurons) 
{
  # Generate a vector of eight values
  vector_rand <- round(runif(8, min=-180, max=180), digits=0)
  # Save it in a list
  list_of_random_vector[iterator] <- list(vector_rand)
}

# Construction of a matrix for Kohonen map
kohonen_matrix<-matrix(list_of_random_vector,ncol=sqrt(number_of_neurons))
# Compute RMSD
rmsd<-function(training_dataset_for_block_a, kohonen_matrix)
{
    difference<-training_dataset_for_block_a-kohonen_matrix 
    for(j in 1:length(difference))
    {
        if (difference[j]< -180) {difference[j]=difference[j]+360}
        if (difference[j]> +180) {difference[j]=difference[j]-360}
    }
     distance=sqrt(mean(difference^2))
     print(distance)
     return(distance) 
}

for(x in 1:4)
{
    for (y in 1:4)
    {
        if(x==y)
        {
            break;
        }
        rmsd_test<-rmsd(as.numeric(training_dataset_for_block_a[x,]), as.numeric(vector_rand[x]))
    }
}

