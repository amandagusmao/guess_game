# Jogo de Adivinhação com Flask

Este é um simples jogo de adivinhação desenvolvido utilizando o framework Flask. O jogador deve adivinhar uma senha criada aleatoriamente, e o sistema fornecerá feedback sobre o número de letras corretas e suas respectivas posições.

## Funcionalidades

- Criação de um novo jogo com uma senha fornecida pelo usuário.
- Adivinhe a senha e receba feedback se as letras estão corretas e/ou em posições corretas.
- As senhas são armazenadas  utilizando base64.
- As adivinhações incorretas retornam uma mensagem com dicas.

## Requisitos

- [Docker](https://www.docker.com/products/docker-desktop)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Um cluster Kubernetes

## Passo 1: Criar o Cluster Kubernetes

### Usando o [Minikube](https://minikube.sigs.k8s.io/docs/) (local)
Se você está usando o Minikube, inicie o cluster com o seguinte comando:

```bash
minikube start
```
### Usando o Docker Desktop
Se você estiver utilizando o Docker Desktop com suporte ao Kubernetes, ative o Kubernetes nas configurações e certifique-se de que o cluster esteja em execução.

### Usando um Cluster Remoto (Exemplo: GKE, EKS, AKS)
Certifique-se de que seu cluster Kubernetes esteja ativo e que você tenha as credenciais de acesso configuradas corretamente.

## Passo 2: Aplicar os Arquivos de Configuração do Kubernetes

### Instalação

1. Clone o repositório:

   ```bash
   git clone https://github.com/amandagusmao/guess_game.git
   cd guess-game
   ```

2. Agora, aplique as configurações de deployment, service, e outros recursos do Kubernetes
    ```
    kubectl apply -f k8s/
    ```
#### Para aplicação do backend, rode os seguintes comandos:
```
kubectl apply -f ./k8s/backend/deployment.yaml
kubectl apply -f ./k8s/backend/hpa.yaml
kubectl apply -f ./k8s/backend/service.yaml
```

#### Para aplicação do frontend, rode os seguintes comandos:
```
kubectl apply -f ./k8s/frontend/deployment.yaml
kubectl apply -f ./k8s/frontend/service.yaml
```

#### Para aplicação do banco de dados, rode os seguintes comandos:
```
kubectl apply -f ./k8s/db/deployment.yaml
kubectl apply -f ./k8s/db/pvc.yaml
kubectl apply -f ./k8s/db/service.yaml
```

## Passo 3: Expor o Frontend

A aplicação frontend está configurada para rodar em um Service do tipo `NodePort`, o que permite acessá-la diretamente pela porta do seu localhost.

### Verifique o Service

Para garantir que o frontend foi exposto corretamente, use o comando:
```
kubectl get svc -n guess-game
```
Você deve ver algo como:
```
NAME        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
frontend    NodePort    10.110.210.140   <none>        80:30080/TCP   10m
```
Isso indica que a aplicação frontend está acessível na porta 30080 do seu localhost.

### Acessar o Frontend

Agora, abra seu navegador e acesse:
```
http://localhost:30080
```
Você deve ser capaz de ver a interface do frontend da aplicação.

## Passo 4: Escalar o Backend com HPA

A Horizontal Pod Autoscaler (HPA) foi configurada para o backend. O HPA ajustará automaticamente o número de réplicas do seu serviço backend com base na carga de CPU.

### Verifique o HPA
Para verificar o HPA, use o comando:
```
kubectl get hpa -n guess-game
```
### Escalar Manualmente
Você também pode escalar manualmente o backend com o comando:
```
kubectl scale deployment backend --replicas=3 -n guess-game
```
## Passo 5: Monitoramento e Logs

Para monitorar o status dos pods no seu cluster Kubernetes, utilize o comando:
```
kubectl get pods -n guess-game
```
Para visualizar os logs de um pod específico (por exemplo, o backend), use o comando:
```
kubectl logs <pod-name> -n guess-game
```

## Passo 6: Parar a Aplicação
Quando você terminar de usar a aplicação, você pode excluir os recursos criados com o comando:
```
kubectl delete -f k8s/
```
## Considerações
Agora a aplicação deve estar rodando no Kubernetes e acessível através do navegador. A arquitetura conta com um frontend em React, backend em Flask e banco de dados PostgreSQL, tudo orquestrado com Kubernetes.

## Como Jogar

### 1. Criar um novo jogo

Acesse a url do frontend http://localhost

Digite uma frase secreta

Envie

Salve o game-id


### 2. Adivinhar a senha

Acesse a url do frontend http://localhost

Vá para o endponint breaker

entre com o game_id que foi gerado pelo Creator

Tente adivinhar

## Estrutura kubernetes

Na pasta k8s, foram criados 3 diferentes serviços:

### backend

Sobe a aplicação flask que serve como backend do jogo

### db

Sobe um banco de dados postgres para armazenar e consultar os dados do jogo

### frontend

Sobe a aplicação react que serve de frontend do jogo


## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
