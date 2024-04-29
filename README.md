# Identifying_Orthologues

This document outlines the workflow used to identify orthologues between two different genomes and to analyze specific query sequences from one genome in the context of another. The main tools used in this process are OrthoFinder for identifying orthologous genes and BLAST for sequence similarity searching. The idea is that Orthofinder finds orthologues genes based on their peptide sequence and then using Blastn with a more stringent parameter, we can narrow some of those to their similarity based on their coding sequence and by using both strategies we reduce the amount of false positive orthologues in our analysis. 

## Workflow Overview

1. **Orthologue Identification with OrthoFinder:**
   - **Purpose:** Identify orthologous genes between two genomes using peptide sequnece to maintain hierarchical biological significance.
   - **Input:** Peptide sequences from both genomes.
   - **Process:** Run OrthoFinder on the input sequences to generate orthogroups representing orthologues across the genomes.
   - **Output:** Orthogroups file listing the identified orthologues.

2. **BLASTn Searching:**
   - **Purpose:** Search for specific gene coding squenes (CDS) as query from Genome A within Genome B.
   - **Input:** Set of query gene CDS sequences from Genome A.
   - **Process:** Perform BLAST searches of these query sequences against the CDS sequences of Genome B.
   - **Output:** BLAST result files containing matches and their details (e.g., alignment scores, E-values).

3. **Integration and Analysis:**
   - **Purpose:** Determine if the query sequences and their corresponding BLAST hits in Genome B are part of the same orthogroups.
   - **Process:** 
       - Cross-reference the BLAST results with the OrthoFinder orthogroups.
       - Check if both the query and the subject IDs from the BLAST results are located in the same orthogroup.
   - **Output:** A table containing the orthogroup number, the relevant BLAST results for matches where both sequences are in the same group from Orthofinder and Functional annotation identifier.
     file outputs:
        1. GOI_in_genome_b_results.csv - Table with all information from gene in genome A to gene in genome b, Orthogroup , BLASTn results and Functional annotation
        2. Final_GOI_in_Genome_b.csv -  Table with just the loci idenfified in genome b to be ortologues to the GOIs
        3. Genome_A_GOIs_in_Genome_B_with_OGs.csv - Table with GOIs in genome A, GOIs in genome B, and Blastn results 

## Directory Structure

- `Home/ortho-genomes` - Directory containing inout files for orthofinder for both genomes. Files should be:
1.   Genes_of_interest.fa = fasta file containing all sequences from genome A interested in finding in genome B
2.   Peptides_genome_a.fa = peptide sequences of all genes (proteome) from Genome A
- `Home/` - Directory containing remaining input files for pipeline: 
3.  Peptides_genome_b.fa = peptide sequences of all genes (proteome) from Genome B
4.  CDS_genome_b.fa= Gene coding seuqnece (CDS) from Genome B
5.  Gene_annotation.txt=  Text file that has one column with GOI_ID and a functional annotation on a different column ; Column name for this identifier should replace <'TF_ID'> in line 59 of this code  



## Requirements

- **OrthoFinder:** [Installation guide and documentation](https://github.com/davidemms/OrthoFinder)
- **BLAST:** [Installation guide and documentation](https://blast.ncbi.nlm.nih.gov/Blast.cgi)

## Usage

To run this workflow, follow these steps:

1. Prepare your peptide and CDS sequence files in FASTA format and place them in the `/Home/` and `Home/ortho-genomes`  directories .
2. Run Orthofinder+Blastn_Orthology.sh 
3. Analyze results from final table: GOI_in_genome_b_results.csv

## Contact

For further questions or troubleshooting, please contact gih0004@vt.edu.

