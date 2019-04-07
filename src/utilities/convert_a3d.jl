# convert_a3d

# Method that allows federation by setting the `output_format`  in the Stanmodel().

"""

# convert_a3d

Convert the output file created by cmdstan to the shape of choice.

### Method
```julia
convert_a3d(a3d_array, cnames, ::Val{Symbol})
```
### Required arguments
```julia
* `a3d_array::Array{Float64}(n_draws, n_variables, n_chains`      : Read in from output files created by cmdstan                                   
* `cnames::Vector{AbstractString}`                                                 : Monitored variable names
```

### Optional arguments
```julia
* `::Val{Symbol} = :array`                                                                             : Output format
```
Method called is based on the output_format defined in the stanmodel, e.g.:

   stanmodel = Stanmodel(num/_samples=1200, thin=2, name="bernoulli", 
     model=bernoullimodel, output_format=:mcmcchains);

Current formats supported are:

1. :array (a3d_array format, the default for CmdStan)
2. :namedarray (NamedArrays object)
3. :dataframe (DataFrames object)
4. :mambachains (Mamba.Chains object)
5. :mcmcchains (TuringLang/MCMCChains.Chains object)

Options 3 through 5 are respectively provided by the packages StanDataFrames, 
StanMamba, StanMCMCChains and StanMCMCChains.
```

### Return values
```julia
* `res`                       : Draws converted to the specified format.
```
"""
convert_a3d(a3d_array, cnames, ::Val{:array}) = a3d_array

convert_a3d(a3d_array, cnames, ::Val{:namedarray}) = 
  [NamedArray(a3d_array[:,:,i], (collect(1:size(a3d_array, 1)), Symbol.(cnames))) 
    for i in 1:size(a3d_array, 3)]

function convert_a3d(a3d_array, cnames, ::Val{:mcmcchains})
  pi = filter(p -> length(p) > 2 && p[end-1:end] == "__", cnames)
  p = filter(p -> !(p in  pi), cnames)

  MCMCChains.Chains(a3d_array,
    cnames,
    Dict(
      :parameters => p,
      :internals => pi
    )
  )
end
