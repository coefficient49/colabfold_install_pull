AWSFOLDER="$1"

echo $AWSFOLDER
# sudo vmtouch -f -w -t -l -d -m 1000G db/*.idx

# echo "parsing database 1"
# sudo vmtouch -ltdwv db/colabfold_envdb_202108_db.idx
# echo "parsing database 2"
# sudo vmtouch -ltdwv db/uniref30_2302_db.idx   



FILESLEFT=`aws s3 ls jchen-af-storage/$AWSFOLDER/fastas_new/ | awk 'length($4)>0 {print$4}' | wc -l`

while (($FILESLEFT > 0))
do

## getting file from s3
FILE=`aws s3 ls s3://jchen-af-storage/$AWSFOLDER/fastas_new/ | awk 'length($4) >0 {print$4}' | head -n 1`

## downloading file from s3
aws s3 cp s3://jchen-af-storage/$AWSFOLDER/fastas_new/$FILE fastas/$FILE

## transfering downloaded file from the _new folder to the _done folder

aws s3 mv s3://jchen-af-storage/$AWSFOLDER/fastas_new/$FILE s3://jchen-af-storage/$AWSFOLDER/fastas_done/$FILE

BASENAME=`basename $FILE .fasta`

## fixing spacing issue in the name
sed -i -e 's/> />/g' fastas/$FILE

## run msa geneation
colabfold_search fastas/$FILE ~/db/ msas/$BASENAME --db1 uniref30_2302_db --db3 colabfold_envdb_202108_db --db-load-mode 2


## fix naming issue
mv msas/$BASENAME/0.a3m msas/$BASENAME/$BASENAME.a3m


## upload to s3 for another ec2 instance to process 
aws s3 mv msas/$BASENAME/$BASENAME.a3m s3://jchen-af-storage/$AWSFOLDER/msa_new/$BASENAME.a3m


FILESLEFT=`aws s3 ls jchen-af-storage/$AWSFOLDER/fastas_new/ | awk 'length($4)>0 {print$4}' | wc -l`

done
