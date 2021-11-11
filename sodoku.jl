## Sodoku Creation Code ##
# File Reading through Julia is easier, though with Arrays the challenge
# came from forming an Array without vcat functions and readcvs or readdlm
# readcvs and readdlm didn't not work with the current function, and despite
# vcat being ideal, filling in an empty array worked fine.
function arraytexts(file, point, array)
        open(file) do f
                ## Read Each Line inside of File
                for (index, line) in enumerate(eachline(f))
                        ## Reach Chosen Array inside of File
                        if index > (point * 10) && index < (point * 10) + 10
                                ## Split Numbers into Array of Strings
                                board = split(line," ")
                                ## Convert Array of Strings to Array of Ints
                                board = parse.(Int, board)
                                ## Move Throughout Empty Array to fill out files from Line
                                for i = 1:9
                                        array[CartesianIndex.(index - (point * 10),i)] = board[i]
                                end
                        end
                end
        end
        return array
end
## Sodoku Solver Code ##
# Backtracking is the General Algorithm for finding Solutions to a problem
# which builds various Solutions to the Problem. Once the Solution is proven
# to not work, it then Backtracks, returning to Previous State. This then
# repeats until One Solution works or No Solution works.
function arraysolve(array)
        ## Check for Next Zero
        zero = findfirst(iszero, array)
        if zero == nothing return true end
        ## Loop through Possible Values
        for i in 1:9
                ## Check whether Last Recursive Change is Valid
                if arraycheck(array, zero, i)
                        ## Increase Tests Counter
                        global tests = tests + 1
                        ## Change Zero to Possible Value
                        array[zero] = i
                        ## Print Updated Array with Next Number
                        arrayprint(array)
                        ## Pause for Viewing of Printed Array
                        sleep(0.10)
                        ## Recursive Call with Next Number
                        if arraysolve(array)
                                return true
                        else
                                array[zero] = 0
                        end
                end
        end
        return false
end
## Sodoku Checker Code ##
# Solving Sodoku requires all Elements in the Same Row and Column and Sub Matrix
# to be filled with Various Numbers between One and Nine. Cartesian Index functions
# through the Matrix which will need to be checked against the Matrix under these
# conditions to determine whether these numbers are Valid Answers.
function arraycheck(array, zero, i)
        ## Check Vertical Values
        if i in array[zero[1],:]
                return false
        end
        ## Check Horizontal Values
        if i in array[:,zero[2]]
                return false
        end
        ## Check SubArray Values
        for x2 = 1:3, y2 = 1:3
                if i in array[CartesianIndex.((zero[1] - 1) - trunc(Int, (zero[1] - 1) % sqrt(9)) + x2, (zero[2] - 1) - trunc(Int, (zero[2] - 1) % sqrt(9)) + y2)]
                        return false
                end
        end
        return true
end
## Sodoku Print Code ##
# Arrays inside of Julia seem to function without Traditional Rows and Columns.
# Attempting to print [2][4] will be [14], Starting from Left going Down.
function arrayprint(array)
        for i = 1:9
                ## Cannot Lie about this One, Don't Understand it
                println(array[i:i,:])
        end
        println(" - - - - - - - - - ")
end
## Sodoku Driver Code ##
# Driver Code uses Boolean Values to determine if the Solved Sudoku Puzzle
# contained a Solution or did not contain a Solution. Driver Code creates
# Empty Array of Nine by Nine Sudoku Board then uses the read file function
# to assign values to each undefined value inside the Array.
tests = 0;
println("Reading...")
array = arraytexts("puzzle.txt", 9, Array{Int64}(undef, 9, 9))
sleep(1)
println("Original Array")
arrayprint(array)
sleep(3)
println("Solving...")
sleep(1)
if arraysolve(array)
        println("Found Solution")
        println(tests, " total test")
else
        println("No Solution")
        println(tests, " total test")
end
## Finished 11/9/2021 at 9:20pm
