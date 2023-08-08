# running alphafold on EC2


for installation
```bash
git clone https://github.com/coefficient49/project_install.git
cp project_install/* .
bash install.sh
```

for running MSA on EC2
```bash
source init.vmtouch.profile
screen -d -m -L bash search_protocol.sh
```

for running folding on EC2
```bash
source init.vmtouch.profile
screen -d -m -L bash search_protocol.sh
```






