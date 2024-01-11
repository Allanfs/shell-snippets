# Credenciais K8S

```bash
# SOUTH AMERICA
gcloud container clusters get-credentials cluster-app-dev-sa-brbroker --region southamerica-east1 --project prj-avn-corretorasbr-dev-01

# US EAST
gcloud container clusters get-credentials cluster-app-dev-e4-brbroker --region us-east4 --project prj-avn-corretorasbr-dev-01
```

# Buildar imagem e atualizar no cluster

```bash
# certamente só basta fazer uma vez:
gcloud --quiet auth configure-docker
CGO_ENABLED=0 GOOS=linux go build -o bin/bridgeitau github.com/avenuesec/brbroker/cmd/bridgeitau/

# prj-avn-corretorasbr-dev-01 ambiente DEV
# service
# tag
hash=`md5sum ./bin/bridgeitau | cut -d' ' -f 1 | head -c 7` \
service=CBR-832 \
tag=${service}_${hash} 

make build-docker-ci project=prj-avn-corretorasbr-dev-01 service=bridgeitau tag=${tag}

kubectl -n dev set image deployment/bridge-itau bridge-itau=us.gcr.io/prj-avn-corretorasbr-dev-01/brbroker-bridgeitau:$tag

# depois de fazer o push vá no serviço desejado:
# - editar Yaml
# - alterar a tag da imagem para a tag usada aqui
```

# Executar o intranet

`avenue cli` inicia os containers necessários para a infra.

```bash
avenue infra up
task build:intranet run:intranet
```

# Rodar serviço com o kind

```bash
# vai iniciar um container de registry
# é preciso fazer o push da sua imagem para este registry
# !atenção com o espaço em disco, principalmente se for iniciar vários serviços
# tentei usar o dev-registry no compose mas na hora só estava falhando.
# tentar novamente criando o cluster do zero.
./kind-with-registry.sh

cd git/avenuesec/brbroker

# Necessário o timeout para evitar do comando ficar para sempre.
# O values local deve ter o registry apontando para o nosso registry local.
# Todo values-local dos serviço deverão apontar para esse registry para evitar
# de fazer o pull do GCP (pois exige configurações de credenciais especificas).
helm upgrade conciliation-cabine \
    ./deployments/helm/conciliation-cabine \
    -f ./deployments/helm/conciliation-cabine/values-local.yaml \
    --namespace=development \
    --install \
    --create-namespace \
    --wait \
    --atomic \
    --timeout 1m0s
```

https://github.com/avenuesec/brbroker/blob/66f6c828e1262056da15ce6cbaecb49351c36fcc/Makefile

O Makefile atual está desatualizado, pois referencia comandos do make que não estão
mais presentes lá.

https://kubernetes.io/docs/reference/kubectl/cheatsheet
https://kind.sigs.k8s.io/docs/user/local-registry/
https://k3d.io/v5.2.1/usage/commands/k3d_image_import/
https://stackoverflow.com/questions/71599858/upgrade-failed-another-operation-install-upgrade-rollback-is-in-progress
https://stackoverflow.com/questions/65006907/kubernetes-helm-stuck-with-an-update-in-progress

# TODO
- [ ] utilizar o k3s para fazer a configuração. Parece ser mais facil que via kind.