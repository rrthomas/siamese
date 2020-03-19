#!/usr/bin/env julia
# Calculate siamese words (after Jérémie Wenger)
# Reuben Thomas 10th July 2019

using Printf
using ArgParse
using DelimitedFiles


# Command-line arguments
function parse_commandline()
    s = ArgParseSettings(description="Find Siamese words.",
                         add_version=true,
                         version="siamese (10 Jul 2019) 0.1 by Reuben Thomas <rrt@sc3d.org>")

    @add_arg_table s begin
        "--word-regex"
            help = "another option with an argument"
            default = r"^[\p{Ll}]{4,10}$"
        "--min-common"
            arg_type = Int
            default = 2
        "dictionary"
            required = false
            default = "/usr/share/dict/words"
    end

    return parse_args(s)
end

args = parse_commandline()


# Get wordlist
raw_words = readdlm(args["dictionary"], String)
println("Total words $(length(raw_words))")


# Find qualifying words
word_regex = args["word-regex"]
words = filter((w)->occursin(word_regex, w), raw_words)
println("Filtered words $(length(words))")

# Find siamese pairs
let prefix = ""
    pairs = []
    min_common = args["min-common"]
    for a in words
        for b in words
            if a < b
                new_prefix = a[1:2]
                if new_prefix != prefix
                    println(new_prefix, " ", length(pairs))
                    prefix = new_prefix
                end
                if length(intersect(Set(a), Set(b))) >= min_common
                    # println(a, " ", b)
                    push!(pairs, (a, b))
                end
            end
        end
    end
end
print("Pairs $(length(pairs))")
