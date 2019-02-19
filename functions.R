# A loop to generate a random dataset
generate_a_random_dataset_function<-function()
{
    list_of_random_vector<-list()
    for (iterator in 1:number_of_neurons) 
    {
        # Generate a vector of eight values
        vector_rand <- round(runif(8, min=-180, max=180), digits=0)
        # Save it in a list
        list_of_random_vector[iterator]<-list(vector_rand)
    }
    return(list_of_random_vector)
}

# Call this function
# rmsd_result<-lapply(list_of_random_vector, rmsd_function, training_dataset_for_block_a=training_dataset_for_block_a[1,])
rmsd_function<-function(training_dataset_for_block_a, kohonen_matrix)
{
    rms<-0
    for (i in 1:ncol(training_dataset_for_block_a[1]))
    {
        difference <- as.numeric(kohonen_matrix[i])-as.numeric(training_dataset_for_block_a[i])
        rms <- sqrt(mean(difference^2))
    }
    print(rms)
    return(rms)
}

learning_function<-function(init_rate,iterations,prot_phipsi)
{
    return(init_rate/(1+(iterations/nrow(prot_phipsi))))
}

