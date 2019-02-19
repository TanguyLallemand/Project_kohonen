# Compute RMSD
rmsd<-function(training_dataset_for_block_a, kohonen_matrix)
{
    difference<-as.numeric(training_dataset_for_block_a)-as.numeric(kohonen_matrix)
    distance=sqrt(mean(difference^2))
    distance=distance/ncol(training_dataset_for_block_a[1])
    print(distance)
    return(distance)
}

#rmsd_result<-lapply(list_of_random_vector, rmsd_function, training_dataset_for_block_a=training_dataset_for_block_a[1,])
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
