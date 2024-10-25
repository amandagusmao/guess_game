# Jogo de Adivinhação com Flask

Este é um simples jogo de adivinhação desenvolvido utilizando o framework Flask. O jogador deve adivinhar uma senha criada aleatoriamente, e o sistema fornecerá feedback sobre o número de letras corretas e suas respectivas posições.

## Funcionalidades

- Criação de um novo jogo com uma senha fornecida pelo usuário.
- Adivinhe a senha e receba feedback se as letras estão corretas e/ou em posições corretas.
- As senhas são armazenadas  utilizando base64.
- As adivinhações incorretas retornam uma mensagem com dicas.

## Requisitos

- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Instalação

1. Clone o repositório:

   ```bash
   git clone https://github.com/amandagusmao/guess_game.git
   cd guess-game
   ```

2. Usando docker-compose, faça o build de todos os containers e suba-os
    ```
    docker-compose up --build
    ```

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

## Estrutura docker

No docker-compose, foram criados 4 diferentes serviços:

### backend

Sobe a aplicação flask que serve como backend do jogo

### db

Sobe um banco de dados postgres para armazenar e consultar os dados do jogo

### frontend

Sobe a aplicação react que serve de frontend do jogo, e expõe ela através de um proxy reverso usando nginx. Foi usado um nginx próprio para manter o desacoplamento entre o serviço de frontend e backend

### nginx

Sobe um servidor nginx que faz o balanceamento entre as 3 réplicas do backend, e expõe em apenas uma porta, a 5000.

## Decisões

### Desacoplamento

Para manter a facilidade na manutenção e atualização dos serviços, o backend e o frontend não têm nenhuma dependência entre si, podendo ambas as partes serem totalmente substituídas sem quebrar aplicação ou depender de alterar os dois serviços para substituir apenas um.

### Persistência

Foi configurado um volume `db_data` no serviço `db` para que os dados sejam persistidos quando o serviço for reiniciado.

### Balanceamento de carga

O serviço `backend` foi configurado para subir 3 réplicas. Todas as réplicas sobem na porta 5000, e cada uma é especificada como "upstream" na configuração do serviço `nginx`. A distribuição de carga entre as instâncias usa o critério padrão do nginx sem maiores customizações.

### Rede

Por ser a camada pública que o usuário acessa, o serviço `frontend` foi configurado para rodar na porta 80 através do proxy reverso do seu nginx próprio.
Para evitar confusões de portas, os serviços de `backend` não expõem portas, somente o `nginx`, que expõe a porta 5000. Uma outra alternativa para que as portas tanto de `frontend` quanto de `backend` fossem a 80, seria retirar o nginx do `frontend`, colocar ele para subir na porta 3000 e fazer apenas um nginx que fizesse o proxy de todas as requisições para a porta 3000, e no mesmo nginx fazer com que todas as rotas /api fossem redirecionadas para as réplicas de backend. A decisão de fazer separado foi para ter independência entre os serviços e para se manter mais próximo da aplicação original que não usa docker.

### Alterações

Cada parte da aplicação pode ser inteiramente substituída por outra.
O banco de dados do `backend` pode ser substituído especificando um novo serviço e alterando as envs que são passadas para o `backend`.
O `backend` pode ser substituído, e caso necessário, sua porta pode ser alterada no env `REACT_APP_BACKEND_URL`.
O `frontend` pode ser substituído por qualquer outra aplicação frontend que acesse as rotas do `backend`.

Ao fazer uma alteração nos serviços, basta dar build e subir todos containers novamente:
    ```
    docker-compose up --build
    ```


## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
