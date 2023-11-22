AWSFOLDER="$1"

echo $AWSFOLDER
# sudo vmtouch -f -w -t -l -d -m 1000G db/*.idx
mkdir fastas_new -p

# echo "parsing database 1"
# sudo vmtouch -ltdwv db/colabfold_envdb_202108_db.idx
# echo "parsing database 2"
# sudo vmtouch -ltdwv db/uniref30_2302_db.idx   

# echo "parsing database 1"
# screen -d -m -L sudo vmtouch -ltd db/colabfold_envdb_202108_db.idx
# echo "parsing database 2"
# screen -d -m -L sudo vmtouch -ltd db/uniref30_2302_db.idx   


FILESLEFT=`aws s3 ls jchen-af-storage/$AWSFOLDER/fastas_new/ | awk 'length($4)>0 {print$4}' | wc -l`

while (($FILESLEFT > 0))
do
echo $FILESLEFT left
## getting first file from s3
FILE=`aws s3 ls s3://jchen-af-storage/$AWSFOLDER/fastas_new/ | awk 'length($4) >0 {print$4}' | head -n 1`

## downloading the first file from s3
aws s3 cp s3://jchen-af-storage/$AWSFOLDER/fastas_new/$FILE fastas_new/$FILE


## transfering downloaded file from the _new folder to the _done folder
aws s3 mv s3://jchen-af-storage/$AWSFOLDER/fastas_new/$FILE s3://jchen-af-storage/$AWSFOLDER/fastas_done/$FILE


## fixing spacing issue in the name
sed -i -e 's/> />/g' fastas_new/$FILE

## run msa geneation
docker run  --gpus all -v ./:/workdir/inputs/ unicorns unicorns  ./inputs/fastas_new/$FILE

BASENAME=`basename $FILE .fasta`
## fix naming issue
mkdir pdbs/$BASENAME -p
sudo chgrp $USER fastas_new/$BASENAME -R
sudo chown $USER fastas_new/$BASENAME -R

mv fastas_new/"$BASENAME"/multimer.unifold.pt_97923.pdb pdbs/"$BASENAME"/"$BASENAME"_unrelaxed_rank_001_unicorn_multimer_v3_model.pdb

# ## upload to s3 for another ec2 instance to process 
aws s3 cp pdbs/"$BASENAME"/"$BASENAME"_unrelaxed_rank_001_unicorn_multimer_v3_model.pdb s3://jchen-af-storage/$AWSFOLDER/pdbs/"$BASENAME"/


done
