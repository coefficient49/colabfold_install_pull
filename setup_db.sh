export MMSEQS_FORCE_MERGE=1

if [ ! -f UNIREF30_READY ]; then
  aws s3 cp s3://jchen-bucket/uniref30_2302.tar.gz .
  tar xzvf "uniref30_2302.tar.gz"
  mmseqs tsv2exprofiledb "uniref30_2302" "uniref30_2302_db"
  mmseqs createindex "uniref30_2302_db" tmp1 --remove-tmp-files 1
  if [ -e uniref30_2302_db_mapping ]; then
    ln -sf uniref30_2302_db_mapping uniref30_2302_db.idx_mapping
  fi
  if [ -e uniref30_2302_db_taxonomy ]; then
    ln -sf uniref30_2302_db_taxonomy uniref30_2302_db.idx_taxonomy
  fi
  touch UNIREF30_READY
fi

if [ ! -f COLABDB_READY ]; then
  # downloadFile "https://wwwuser.gwdg.de/~compbiol/colabfold/colabfold_envdb_202108.tar.gz" "colabfold_envdb_202108.tar.gz"
  aws s3 cp s3://jchen-bucket/colabfold_envdb_202108.tar.gz .
  tar xzvf "colabfold_envdb_202108.tar.gz"
  mmseqs tsv2exprofiledb "colabfold_envdb_202108" "colabfold_envdb_202108_db"
  # TODO: split memory value for createindex?
  mmseqs createindex "colabfold_envdb_202108_db" tmp2 --remove-tmp-files 1
  touch COLABDB_READY
fi
