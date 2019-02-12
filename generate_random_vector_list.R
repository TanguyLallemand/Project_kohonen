
# A loop to generate a random dataset
for (iterator in 1:16) 
{
  # Generate a vector of eight values
  vector_rand <- round(runif(8, min=-180, max=180), digits=0)
  # Save it in a list
  list_of_random_vector[iterator] <- list(vector_rand)
}
