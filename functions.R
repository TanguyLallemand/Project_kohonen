verbose<-function(init_rate, initial_radius, number_max_iteration)
{
    print("############Configuration used:############")
    print(paste("Initial learning rate : ",init_rate, sep=""))
    print(paste("Initial radius: ",initial_radius, sep=""))
    print(paste("Number of iterations: ", number_max_iteration, sep=""))
    print("###########################################")
}


# A loop to generate a random dataset
generate_a_random_dataset_function<-function()
{
    list_of_random_vector<-list()
    for (iterator in 1:number_of_neurons)
    {
        # Generate a vector of eight values
        vector_random <- round(runif(8, min=-180, max=180), digits=0)
        # Save it in a list
        list_of_random_vector[iterator]<-list(vector_random)
    }
    return(list_of_random_vector)
}

generate_all_possible_combinations<-function(number_of_neurons)
{
    neuron_label<-list()
    count = 1
    for (x in 1:sqrt(number_of_neurons)) 
    {
        for (y in 1:sqrt(number_of_neurons)) 
        {
            neuron_label[[count]] = c(x,y)
            count = count +1
        }
    }
    return(neuron_label)
}

# Call this function
# rmsd_result<-lapply(list_of_random_vector, rmsd_function, training_dataset_for_block_a=training_dataset_for_block_a[1,])
rmsd_function<-function(training_dataset_for_block_a, kohonen_matrix)
{
    rms<-0
    best_cell <- 0
    count = 1
    for (x in 1:4)
    {
        for (y in 1:4) 
        { 
            difference <- as.numeric(unlist(training_dataset_for_block_a))-as.numeric(unlist(kohonen_matrix[x,y]))
            rmsd <- sqrt(mean(unlist(difference)^2))
            if(count==1)
            {
                highest_rmsd <- rmsd
                # Save position of best neuron
                best_cell <- c(x,y)
            }
            else if(highest_rmsd > rmsd)
            {
                temp_neuron <- vector()
                highest_rmsd <- rmsd
                #efine the best neuron
                best_cell <- c(x,y)
            }
        }
    }
    return(best_cell)
}


learning_function<-function(init_rate,current_iteration,phipsi_angles)
{
    return(init_rate/(1+(current_iteration/nrow(phipsi_angles))))
}

construct_and_save_plots <- function(number_of_neurons, kohonen_matrix)
{
    list_of_plot <- list()
    count_iterations <- 0
    # We go through all columns
    for(i in 1:sqrt(number_of_neurons))
    {
        # We go through all rows
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
    multiple_graph <- grid.arrange(grobs=list_of_plot, ncol=4, nrow=4,  top = "Kohonen map with 16 neurons")
    # Save it in pdf
    ggsave(filename="./results/multiple_graph.png", plot=multiple_graph)
}
