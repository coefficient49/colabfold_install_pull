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
source init.vmtouch.profile
screen -d -m -L bash search_protocol.sh
```

for running folding on EC2
```bash
source init.profile
screen -d -m -L bash folding_protocol.sh
```






