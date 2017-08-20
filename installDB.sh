# NCBI Taxonomy
mkdir -p ~/taxonomy
cd ~/taxonomy
wget -c ftp://ftp.ncbi.nih.gov/pub/taxonomy/gi_taxid_nucl.dmp.gz
wget -c ftp://ftp.ncbi.nih.gov/pub/taxonomy/gi_taxid_nucl.dmp.gz.md5
md5sum -c gi_taxid_nucl.dmp.gz.md5
rm gi_taxid_nucl.dmp.gz.md5
gzip -d gi_taxid_nucl.dmp.gz
wget -c ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
wget -c ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz.md5
tar -xzf taxdump.tar.gz
chmod 644 taxdump.tar.gz
rm taxdump.tar.gz
# NCBI nt
mkdir -p ~/blastdb
cd ~/blastdb
wget -c ftp://ftp.ncbi.nih.gov/blast/db/nt.??.tar.gz
wget -c ftp://ftp.ncbi.nih.gov/blast/db/nt.??.tar.gz.md5
md5sum -c nt.??.tar.gz.md5
rm nt.??.tar.gz.md5
wget -c ftp://ftp.ncbi.nih.gov/blast/db/taxdb.tar.gz
wget -c ftp://ftp.ncbi.nih.gov/blast/db/taxdb.tar.gz.md5
md5sum -c taxdb.tar.gz.md5
rm taxdb.tar.gz.md5
for f in *.tar.gz; do tar -xzf $f; done
chmod 644 *.tar.gz
rm *.tar.gz
