all: $(patsubst %.fasta, %.png, $(wildcard *.fasta))

clean:
	rm *.aln *.phy* *.png RAxML* *.new

#make the alignment, in FASTA format
%.fasta.aln: %.fasta
	muscle -in $< -out $@
#%: wildcard
#$< : the first dependency
#$@ : the target

#convert the FASTA alignmnet to Phylip format
%.phy: %.fasta.aln
	python -c "import Bio.AlignIO; Bio.AlignIO.convert('$<', 'fasta', '$@', 'phylip-relaxed')"

%.new: %.phy
	rm -f RAxML*
	raxmlHPC -m GTRCAT -n $@ -p 10000 -s $<
	mv RAxML_result.$@ $@

# Notice the two dependencies
%.png: %.new draw_tree.py
	python draw_tree.py $< $@
