# running alphafold on EC2


for installation
```bash
rm project_install -rf
git clone https://github.com/coefficient49/project_install.git
cp project_install/* .

```
```
bash install.sh
```

make sure your AWS CLI is setup correctly

run
```bash
aws configure
```
get your tokens from aws console. or speak with Jeron for setting up environmental variables.

for running MSA on EC2
```bash
source init.profile
```
set up the db
```bash
mkdir db -p
cd db
bash ../setup_db.sh
cd ..
```


deprecated:
```
source init.vmtouch.profile
```

run this directly. vmtouch built in.

```
screen -d -m -L bash search_protocol.sh
```

for running folding on EC2
```bash
source init.profile
screen -d -m -L bash folding_protocol.sh
```






