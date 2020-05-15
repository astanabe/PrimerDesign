export PREFIX=`dirname ~`/`basename ~` || exit $?
# Make directories
mkdir -p $PREFIX/bin || exit $?
cp -R ./work $PREFIX/ || exit $?
# Install ecoPCR
tar -xzf ecoPCR-0.8.0.tar.gz || exit $?
cd ecoPCR-0.8.0/src || exit $?
make -j4 || exit $?
make ecoisundertaxon || exit $?
cp ecofind ecogrep ecoisundertaxon ecoPCR $PREFIX/bin/ || exit $?
cd ../tools || exit $?
cp *.py $PREFIX/work/ || exit $?
cd ../.. || exit $?
rm -rf ecoPCR-0.8.0 || exit $?
# Install Claident
wget -c https://github.com/astanabe/Claident/archive/v0.2.2019.05.10.tar.gz -O Claident-0.2.2019.05.10.tar.gz || exit $?
tar -xzf Claident-0.2.2019.05.10.tar.gz || exit $?
cd Claident-0.2.2019.05.10 || exit $?
make PREFIX=$PREFIX || exit $?
make PREFIX=$PREFIX install || exit $?
cp $PREFIX/share/claident/.claident ~/.claident || exit $?
cd .. || exit $?
rm -rf Claident-0.2.2019.05.10 || exit $?
# Install Phylogears2
wget -c https://github.com/astanabe/Phylogears/archive/v2.0.2020.05.06.tar.gz -O Phylogears-2.0.2020.05.06.tar.gz || exit $?
tar -xzf Phylogears-2.0.2020.05.06.tar.gz || exit $?
cd Phylogears-2.0.2020.05.06 || exit $?
make PREFIX=$PREFIX || exit $?
make PREFIX=$PREFIX install || exit $?
cd .. || exit $?
rm -rf Phylogears-2.0.2020.05.06 || exit $?
# Install MAFFT
wget -c http://mafft.cbrc.jp/alignment/software/mafft-7.464-without-extensions-src.tgz || exit $?
tar -xzf mafft-7.464-without-extensions-src.tgz || exit $?
cd mafft-7.464-without-extensions/core || exit $?
perl -i -npe "s/^PREFIX = \\S+/PREFIX = \$ENV{\"PREFIX\"}/" Makefile || exit $?
make -j4 || exit $?
make install || exit $?
cd ../.. || exit $?
rm -rf mafft-7.464-without-extensions || exit $?
# Install Primer3
wget -c -O primer3-2.4.0.tar.gz https://sourceforge.net/projects/primer3/files/primer3/2.4.0/primer3-2.4.0.tar.gz/download || exit $?
tar -xzf primer3-2.4.0.tar.gz || exit $?
cd primer3-2.4.0/src || exit $?
perl -i -npe "s/\\/opt\\/primer3_config/\$ENV{\"PREFIX\"}\\/bin\\/primer3_config/" primer3_boulder_main.c || exit $?
perl -i -npe "s/\\/opt\\/primer3_config/\$ENV{\"PREFIX\"}\\/bin\\/primer3_config/" thal_main.c || exit $?
make -j4 || exit $?
cp long_seq_tm_test ntdpal ntthal oligotm primer3_core $PREFIX/bin/ || exit $?
cp -R primer3_config $PREFIX/bin/ || exit $?
cd ../.. || exit $?
rm -rf primer3-2.4.0 || exit $?
# Install VSEARCH
wget -c https://github.com/torognes/vsearch/releases/download/v2.14.2/vsearch-2.14.2-linux-x86_64.tar.gz || exit $?
tar -xzf vsearch-2.14.2-linux-x86_64.tar.gz || exit $?
cd vsearch-2.14.2-linux-x86_64/bin || exit $?
cp vsearch $PREFIX/bin/ || exit $?
cd ../.. || exit $?
rm -rf vsearch-2.14.2-linux-x86_64 || exit $?
# Install EMBOSS
wget -c ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.6.0.tar.gz || exit $?
tar -xzf EMBOSS-6.6.0.tar.gz || exit $?
cd EMBOSS-6.6.0 || exit $?
./configure --prefix=$PREFIX --without-x --without-java --disable-shared --disable-static || exit $?
make -j4 || exit $?
make install || exit $?
cd .. || exit $?
rm -rf EMBOSS-6.6.0 || exit $?
# Install NCBI BLAST+
wget -c ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.9.0/ncbi-blast-2.9.0+-x64-linux.tar.gz || exit $?
tar -xzf ncbi-blast-2.9.0+-x64-linux.tar.gz || exit $?
cd ncbi-blast-2.9.0+/bin || exit $?
cp * $PREFIX/bin/ || exit $?
cd ../.. || exit $?
rm -rf ncbi-blast-2.9.0+ || exit $?
# Install R
wget -c https://cran.r-project.org/src/base/R-3/R-3.6.3.tar.gz || exit $?
tar -xzf R-3.6.3.tar.gz || exit $?
cd R-3.6.3 || exit $?
./configure --prefix=$PREFIX --without-x || exit $?
make -j4 || exit $?
make install || exit $?
cd .. || exit $?
rm -rf R-3.6.3 || exit $?
