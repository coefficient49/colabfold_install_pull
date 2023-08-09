CURRENTPATH=`pwd`
COLABFOLDDIR="${CURRENTPATH}/localcolabfold"
#. "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
export PATH="${COLABFOLDDIR}/conda/condabin:${PATH}"
export PATH="${COLABFOLDDIR}/colabfold-conda/bin:$PATH"
