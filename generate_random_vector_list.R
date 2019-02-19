library("ggplot2")
library("gridExtra")
source("functions.R")
setwd(getwd())

# Import datas
training_dataset_for_block_a <- read.csv("./dataset/training_dataset_for_block_a.phipsi", header=FALSE)
# Init some variables
number_of_neurons<-16
init_rate=0.75
init_radi=2
number_max_iteration=2
list_of_random_vector<-list()
# Generate a list of random dataset
list_of_random_vector<-generate_a_random_dataset_function()
# Initalize kohonen matrix with random values
kohonen_matrix<-matrix(list_of_random_vector,ncol=sqrt(number_of_neurons),nrow=sqrt(number_of_neurons))
dimnames(kohonen_matrix) <- list(rownames(kohonen_matrix, do.NULL = FALSE),
                            colnames(kohonen_matrix, do.NULL = FALSE))

row <- c("row1","row2","row3","row4")
col <- c("col1","col2","col3","col4")
apply(expand.grid(row, col), 1, paste, collapse="")


for(current_iteration in 1:number_max_iteration)
{
    for(i_row in 1:10) #for(i_row in 1:nrow(training_dataset_for_block_a_sampled))
    {
        #Update learn_rate and radius at each row of each iteration
        learn_rate<-learning_function(init_rate,((current_iteration-1)*nrow(training_dataset_for_block_a_sampled))+i_row,training_dataset_for_block_a_sampled)
        learn_radi<-learning_function(init_radi,((current_iteration-1)*nrow(training_dataset_for_block_a_sampled))+i_row,training_dataset_for_block_a_sampled)
        #Find distance between each vectors of angles of Kohonen Map and the training vector
        rmsd_result<-lapply(list_of_random_vector, rmsd_function, training_dataset_for_block_a=training_dataset_for_block_a[1,])
        #Unlist and create a matrix of distances
        rmsd_vector<-unlist(rmsd_result)
        rmsd_matrix<-matrix(rmsd_vector,sqrt(number_of_neurons),sqrt(number_of_neurons))
        #Take the index of the winning neuron, it's the neuron that are more similar than the training vector
        win_index<-which(rmsd_matrix==min(rmsd_matrix), arr.ind=TRUE) 
        #Update of angles of Kohonen Map vectors with the equation (be careful at number of parenthesis)
        for (mylist in 1:number_of_neurons)
        {
            distance<-as.numeric(dist(rbind(win_index[1,], current_index[[mylist]])))
            list_of_random_vector[[mylist]]<-(list_of_random_vector[[mylist]]+ ( training_dataset_for_block_a_sampled[i_row,]-list_of_random_vector[[mylist]])* (learn_rate*( exp (- ((distance)^2/(2*((learn_radi)^2)) )) ) ))
        }
        kohonen_matrix<-matrix(list_of_random_vector,sqrt(number_of_neurons),sqrt(number_of_neurons))
    }
    
}

list_of_plot = list()
count_iterations<-0


for(i in 1:sqrt(number_of_neurons)){ # For each col
    for(j in 1:sqrt(number_of_neurons)){ # Each line
        count_iterations <- count_iterations+1
        cell_of_kohonen_matrix<-unlist(kohonen_matrix[i,j])
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
        list_of_plot[[count_iterations]] <- ggplotGrob(ggplot)
        }
}
multiple_graph <- grid.arrange(grobs=list_of_plot, ncol=4, nrow=4)
