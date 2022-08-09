# README.md

Apresentação realizada no meetup Zabbix Rio em 23/07/2022

`Esse documento não serve para colocar um ambiente em PRODUÇÃO, é apenas um material guiado para iniciar os estudos para fazer o deploy do Zabbix em Kubernetes`


## Requisitos

- Docker
- Kind

## Kind

- Criar arquivo do config do Kid

```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: monitoring
nodes:
- role: control-plane
- role: worker
- role: worker
```

```
cd kind
kind create cluster --config kind/config.yaml
```

- Alterar contexto 

```
kubectl cluster-info --context kind-monitoring
```

- Deploy


```
kubectl apply -f mysql/deployment.yaml
kubectl apply -f mysql/service.yaml
kubectl apply -f zabbix-server-mysql/deployment.yaml
kubectl apply -f zabbix-server-mysql/service.yaml
kubectl apply -f zabbix-web-mysql/deployment.yaml
kubectl apply -f zabbix-web-mysql/service.yaml
```

- Para acessar o serviço

    - **Opção 1:**

    ```
    kubectl port-forward deployment/zbx-web-mysql 9000:8080
    ```
    `NOTA: Se encerrar o terminal, o acesso fica indisponível`

    - **Opção 2:**

    Acessando o IP de um dos nós

    ```
    kubectl get nodes -o wide
    ```

    Pegue o IP e acesso via navegador.

    - Deletar cluster Kind

    ```
    kind delete cluster --name monitoring
    ```

## Agilizar o deploy

`NOTA: Este passo é opcional, eu fiz apenas para agilizar a apresentação do meetup`

- Baixar imagens

```
docker pull mysql
docker load docker-image mysql --name monitoring
docker pull zabbix/zabbix-server-mysql:ol-6.0.6
kind load docker-image zabbix/zabbix-server-mysql:ol-6.0.6 --name meetup
docker pull zabbix/zabbix-web-nginx-mysql
kind load docker-image zabbix/zabbix-web-nginx-mysql:ol-6.0.6 --name meetup
```

## Deploy com helm

### zabbix-server

O helm encontra-se na pasta [helm](./zabbix-server-mysql/helm)

```
helm install zabbix-server-mysql ./zabbix-server-mysql/helm
```

Ou

```
helm upgrade --install zabbix-server-mysql ./zabbix-server-mysql/helm
```


## Próximos passos

- Compartilhar mais sobre o deploy utilizando Helm.

