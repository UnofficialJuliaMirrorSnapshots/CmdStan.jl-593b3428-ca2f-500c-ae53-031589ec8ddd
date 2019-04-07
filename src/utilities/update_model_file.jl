"""

# Method `update_model_file`

Update Stan language model file if necessary 

### Method
```julia
CmdStan.update_model_file(
  file::String, 
  str::String
)
```
### Required arguments
```julia
* `file::AbstractString`                : File holding existing Stan model
* `str::AbstractString`                 : Stan model string
```

### Related help
```julia
?CmdStan.Stanmodel                 : Create a StanModel
```
"""
function update_model_file(file::AbstractString, str::AbstractString)
  str2 = ""
  if isfile(file)
    resfile = open(file, "r")
    str2 = read(resfile, String)
    str != str2 && rm(file)
  end
  if str != str2
    println("\nFile $(file) will be updated.\n")
    strmout = open(file, "w")
    write(strmout, str)
    close(strmout)
  end
end

