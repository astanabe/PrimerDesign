export PREFIX=`dirname ~`/`basename ~`
# Make directories
mkdir -p $PREFIX/bin
cp -R ./work $PREFIX/
# Install ecoPCR
tar -xzf ecoPCR-0.8.0.tar.gz
cd ecoPCR-0.8.0/src
make -j4
cp ecofind ecogrep ecoisundertaxon ecoPCR $PREFIX/bin/
make clean
cd ../tools
cp *.py $PREFIX/work/
# Install Claident
wget -c https://github.com/astanabe/Claident/archive/v0.2.2017.05.22.tar.gz -O Claident-0.2.2017.05.22.tar.gz
tar -xzf Claident-0.2.2017.05.22.tar.gz
cd Claident-0.2.2017.05.22
sh install_on_Debian.sh
cd ..
rm -rf Claident-0.2.2017.05.22
# Install Phylogears2
wget -c https://github.com/astanabe/Phylogears/archive/v2.0.2016.09.06.tar.gz -O Phylogears-2.0.2016.09.06.tar.gz
tar -xzf Phylogears-2.0.2016.09.06.tar.gz
cd Phylogears-2.0.2016.09.06
make PREFIX=$PREFIX
make PREFIX=$PREFIX install
cd ..
rm -rf Phylogears-2.0.2016.09.06
# Install MAFFT
wget -c http://mafft.cbrc.jp/alignment/software/mafft-7.310-without-extensions-src.tgz
tar -xzf mafft-7.310-without-extensions-src.tgz
cd mafft-7.310-without-extensions/core
perl -i -npe "s/^PREFIX = \\S+/PREFIX = \$ENV{\"PREFIX\"}/" Makefile
make -j4
make install
cd ../..
rm -rf mafft-7.310-without-extensions
# Install Primer3
wget -c -O primer3-2.3.7.tar.gz https://sourceforge.net/projects/primer3/files/primer3/2.3.7/primer3-2.3.7.tar.gz/download
tar -xzf primer3-2.3.7.tar.gz
cd primer3-2.3.7/src
perl -i -npe "s/\\/opt\\/primer3_config/\$ENV{\"PREFIX\"}\\/bin\\/primer3_config/" primer3_boulder_main.c
perl -i -npe "s/\\/opt\\/primer3_config/\$ENV{\"PREFIX\"}\\/bin\\/primer3_config/" thal_main.c
make -j4
cp long_seq_tm_test ntdpal ntthal oligotm primer3_core $PREFIX/bin/
cp -R primer3_config $PREFIX/bin/
cd ../..
rm -rf primer3-2.3.7
# Install VSEARCH
wget -c https://github.com/torognes/vsearch/releases/download/v2.4.3/vsearch-2.4.3-linux-x86_64.tar.gz
tar -xzf vsearch-2.4.3-linux-x86_64.tar.gz
cd vsearch-2.4.3-linux-x86_64/bin
cp vsearch $PREFIX/bin/
cd ../..
rm -rf vsearch-2.4.3-linux-x86_64
# Install EMBOSS
wget -c ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.6.0.tar.gz
tar -xzf EMBOSS-6.6.0.tar.gz
cd EMBOSS-6.6.0
./configure --prefix=$PREFIX --without-x --without-java --disable-shared --disable-static
make -j4
make install
cd ..
rm -rf EMBOSS-6.6.0
# Install NCBI BLAST+
wget -c ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.6.0/ncbi-blast-2.6.0+-x64-linux.tar.gz
tar -xzf ncbi-blast-2.6.0+-x64-linux.tar.gz
cd ncbi-blast-2.6.0+/bin
cp * $PREFIX/bin/
cd ../..
rm -rf ncbi-blast-2.6.0+
# Install R
wget -c https://cran.r-project.org/src/base/R-3/R-3.4.1.tar.gz
tar -xzf R-3.4.1.tar.gz
cd R-3.4.1
./configure --prefix=$PREFIX
make -j4
make install
cd ..
rm -rf R-3.4.1
