# NCBI Taxonomy
mkdir -p ~/taxonomy || exit $?
cd ~/taxonomy || exit $?
wget -c ftp://ftp.ncbi.nih.gov/pub/taxonomy/gi_taxid_nucl.dmp.gz || exit $?
wget -c ftp://ftp.ncbi.nih.gov/pub/taxonomy/gi_taxid_nucl.dmp.gz.md5 || exit $?
md5sum -c gi_taxid_nucl.dmp.gz.md5 || exit $?
rm gi_taxid_nucl.dmp.gz.md5 || exit $?
gzip -d gi_taxid_nucl.dmp.gz || exit $?
wget -c ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz || exit $?
wget -c ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz.md5 || exit $?
md5sum -c taxdump.tar.gz.md5 || exit $?
tar -xzf taxdump.tar.gz || exit $?
chmod 644 taxdump.tar.gz || exit $?
rm taxdump.tar.gz || exit $?
# NCBI nt
mkdir -p ~/blastdb || exit $?
cd ~/blastdb || exit $?
wget -c ftp://ftp.ncbi.nih.gov/blast/db/v4/nt_v4.??.tar.gz || exit $?
wget -c ftp://ftp.ncbi.nih.gov/blast/db/v4/nt_v4.??.tar.gz.md5 || exit $?
ls nt_v4.??.tar.gz.md5 | xargs -L 1 -P 4 md5sum -c || exit $?
rm nt_v4.??.tar.gz.md5 || exit $?
wget -c ftp://ftp.ncbi.nih.gov/blast/db/v4/taxdb.tar.gz || exit $?
wget -c ftp://ftp.ncbi.nih.gov/blast/db/v4/taxdb.tar.gz.md5 || exit $?
md5sum -c taxdb.tar.gz.md5 || exit $?
rm taxdb.tar.gz.md5 || exit $?
ls *.tar.gz | xargs -L 1 -P 4 tar -xzf || exit $?
chmod 644 *.tar.gz || exit $?
rm *.tar.gz || exit $?
