# Test for 1 pair (seq/ comp seq)

rna_sequence <- gen_rna_seq(100); #rna_complementary_seq <- gen_comp_rna_seq(rna_sequence)
result <- AA_frequencies(rna_sequence); #result_comp <- AA_frequencies(rna_complementary_seq)
print(result$frequencies); #print(result_comp$frequencies)
#cat("Tm values: \n", result$tm_values, "\n"); #print(result_comp$tm_values)
cat("Initial Strand Stop codons:", result$stop_codons, "\n"); #cat("Complementary Strand Stop Codons:", result_comp$stop_codons)

#test_loop
Test <- Loop_AA_data(begin_size = 100, end_size = 100, step = 0, n_repeats = 1)
