# PrimerDesign
Support programs for primer design and picking
## Prerequisites
* Debian or Ubuntu compatible operating system
* Perl and Python execution environment
* Internet connection and wget
* Compilers, headers and libraries
## Assumption of directory structure
* home directory (~)
  * bin (command installation path if installPROGRAMS.sh is used)
  * blastdb (BLAST database installation path)
  * taxonomy (NCBI Taxonomy dump installation path)
  * work (working directory containing support scripts)
## How to install
### Install required programs
 sh installPROGRAMS.sh
This will install ecoPCR, Claident, Phylogears2, VSEARCH, EMBOSS, BLAST+ and R.
### Install required data
 sh installDB.sh
This will install NCBI nt and NCBI Taxonomy dump files.
## Enabling installed commands
Above installer installs commands into ~/bin. Therefore, you need to add this path to PATH environment variable like below.
 export PATH=/home/username/bin:$PATH
