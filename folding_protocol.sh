FILESLEFT=`aws s3 ls jchen-af-storage/msa_new/ | awk 'length($4)>0 {print$4}' | wc -l`

while (($FILESLEFT > 0))
do

## getting file from s3
FILE=`aws s3 ls s3://jchen-af-storage/msa_new/ | awk 'length($4) >0 {print$4}' | head -n 1`

## downloading file from s3
aws s3 cp s3://jchen-af-storage/msa_new/$FILE msas/$FILE

## transfering downloaded file from the _new folder to the _done folder

aws s3 mv s3://jchen-af-storage/msa_new/$FILE s3://jchen-af-storage/msa_done/$FILE

BASENAME=`basename $FILE .a3m`


## run msa geneation
colabfold_batch  --templates --model-type alphafold2_multimer_v3  msas/$FILE msas/$BASENAME


## fix naming issue
mv msas/$BASENAME/0.a3m msas/$BASENAME/$BASENAME.a3m


## upload to s3 for another ec2 instance to process 
aws s3 mv msas/$BASENAME/ s3://jchen-af-storage/pdbs/$BASENAME --recursive


FILESLEFT=`aws s3 ls jchen-af-storage/msa_new/ | awk 'length($4)>0 {print$4}' | wc -l`

done

