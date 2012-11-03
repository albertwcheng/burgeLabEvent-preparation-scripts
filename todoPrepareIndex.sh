cd ..

if [ ! -e indexed ]; then
	mkdir indexed
fi 

for i in *.gff3; do
bsub index_gff.py --index $i ${i/.gff3/}_indexed/
done