# N Brown data science challenge

Repo contains short script exploring the data provided by [N
Brown](http://www.nbrown.co.uk/) for the Manchester SIAM-IMA Student Chapter
industry problem solving
[event](http://www.maths.manchester.ac.uk/~siam/nbrown18/).

`explore.jl` mainly just plots womenswear size against brief size and tries to
fit some simple models.
One potentially interesting finding is that adding more features to the model
decreases the mean squared error but increases the probability of guessing the
correct size.
The naive approach of picking the correct size appears to have the highest
probability of the methods we tried
```julia
womenswear_size = min.(size_corsetry_briefs,36)
```
