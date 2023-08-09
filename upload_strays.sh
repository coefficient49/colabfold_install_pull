for ff in ./msas/*/
do
  echo $ff
  filename=$(basename -- "$ff")
  echo $filename
  aws s3 mv $ff s3://jchen-af-storage/$filename/ --recursive
done
