#!/usr/bin/awk -f
#
# NAME
#     seqlen.awk - Generate sequence ID & sequence length from FASTA sequence(s)
#
# SYNOPSIS
#     seqlen.awk [fasta_file...]
#
# DESCRIPTION
#     Generates sequence ID, sequence length pairs from FASTA sequences.
#
# OPERANDS
#     fasta_file
#         A FASTA file containing one or more sequences.
# STDIN
#     Standard input will be used if no input file is specified, or if a file
#     is '-'.
#         
# STDOUT
#     Output format is two columns separated by a space:
#     <sequence_id> <length>
#
# EXAMPLES
#     1. Given the file Fosmid.fasta containing sequences:
#         >FFOF1000 3432432 FFOF
#         ACTG
#         >FFOF1001 3432433 FFOF
#         >FFOF1002 3432434 FFOF
#         ACTG
#         ACTG
#
#        $ seqlen.awk Fosmid.fasta
#        FFOF1000 4
#        FFOF1001 0
#        FFOF1002 8
#
#     2. Generate a GFF file from a FASTA file
#        $ seqlen.awk scaffolds.fasta |
#              awk -v OFS='\t' '
#                  BEGIN { print "##gff-version 3" }
#                  {print $1,".","supercontig","1",$2,".",".",".","ID="$1}' \
#        > scaffolds.gff
#
# 
#
# AUTHOR
#     Nathan Weeks <nathan.weeks@ars.usda.gov>

/^>/ { 
    # Print results for any previous sequence
    if (sequence_id)
        print sequence_id, sequence_length

    # Initialize seqid & seqlen for new sequence
    sequence_id  = substr($1, 2)
    sequence_length = 0
}

/^[^>]/ { sequence_length += length($0) }

# Print results for last sequence
END { print sequence_id, sequence_length }
