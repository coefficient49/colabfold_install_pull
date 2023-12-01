AWSFOLDER="$1"
CYCLES="$2"

rm screenlog.0
echo "$CYCLES cycles"

rm fastas_new -rf
mkdir fastas_new -p

FILESLEFT=`aws s3 ls jchen-af-storage/$AWSFOLDER/fastas_new/ | awk 'length($4)>0 {print$4}' | wc -l`

while (($FILESLEFT > 0))
do

## getting file from s3
FILE=`aws s3 ls s3://jchen-af-storage/$AWSFOLDER/fastas_new/ | awk 'length($4) >0 {print$4}' | head -n 1`

## downloading file from s3
aws s3 cp s3://jchen-af-storage/$AWSFOLDER/fastas_new/$FILE fastas_new/$FILE

## transfering downloaded file from the _new folder to the _done folder

aws s3 mv s3://jchen-af-storage/$AWSFOLDER/fastas_new/$FILE s3://jchen-af-storage/$AWSFOLDER/fastas_done/$FILE

BASENAME=`basename $FILE .fasta`


## run msa geneation
# colabfold_batch  --templates --num-seeds 2 --model-type alphafold2_multimer_v3  msas/$FILE msas/$BASENAME
colabfold_batch  \
    --templates \
    --num-seeds 1 \
    --model-type alphafold2_multimer_v3  \
    --save-recycles \
    --num-recycle $CYCLES  \
    fastas_new/$FILE \
    fastas_new/$BASENAME  \
    --host-url http://172.16.100.86:8502

## fix naming issue
# mv fastas_new/$BASENAME/$BASENAME.a3m fastas_new/$BASENAME/$BASENAME.a3m


## upload to s3 for another ec2 instance to process 
aws s3 mv fastas_new/$BASENAME/ s3://jchen-af-storage/$AWSFOLDER/pdbs/$BASENAME --recursive


FILESLEFT=`aws s3 ls jchen-af-storage/$AWSFOLDER/msa_new/ | awk 'length($4)>0 {print$4}' | wc -l`

done


