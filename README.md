## Tekuchi Contabilidade

- Trocar **email@[]()example.com**, em `sns.tf`, pelo seu e-mail.
- Os comandos - de provisionamento, de instalação de bibliotecas, e de execução - devem ser executados no diretório raiz do projeto.
```
  terraform init
```
```
  terraform plan -out tekuchi-plan
```
```
  terraform apply -auto-approve
```
## Confirmação de Inscrição
- Se o e-mail informado em `sns.tf` existir, deve ser recebido um pedido de confirmação de inscrição.
- Caso opte por receber uma mensagem de notificação por e-mail, após o final da execução do projeto, é necessário confirmar a inscrição.
## Confirmação de que o Banco de Dados Existe
- Foi usado um sistema de banco de dados MySQL, e acessado (opcionalmente) através de máquina local.
- Senha: `tekuchi123`.
- Copiar endpoint da instância de banco de dados provisionada, colar no lugar de `my-db-endpoint` no comando:
```
  mysql -h my-db-endpoint -u admin -P 3306 -p
```
<p align="center">
  <img src="https://github.com/user-attachments/assets/c31caf37-feb1-416a-a3c4-12e4a75aca8f">
</p>

## Criação de Ambiente Virtual Python para Isolamento de Bibliotecas
```
  python3 -m venv .tekuchi-venv
```
```
  source .tekuchi-venv/bin/activate
```
## Instalação de Boto3 - Integração de AWS à Linguagem Python
```
  pip install pip --upgrade
```
```
  pip install boto3
```
## Execução do Arquivo Principal
- O programa cria um arquivo `relatorio-contabil.csv` com dados aleatórios, usando os módulos UUID e Random, e insere esse arquivo em um Bucket S3.
- O nome do Bucket a ser inserido durante a execução do programa deve ser o nome (único) do Bucket criado através do provisionamento realizado com Terraform.
```
  python3 auditoria-fiscal.py
```
- A Lambda Function deve ser ativada automaticamente após a inserção de um novo arquivo no Bucket, e cada linha de `relatorio-contabil.csv` deve ser inserida no banco de dados, e os resultados devem ser enviados, na mensagem final, por e-mail, em formato chave-valor.
## MySQL - Resultado
<p align="center">
  <img src="https://github.com/user-attachments/assets/6e232ede-caa3-45dc-8332-75b74ba5d736">
</p>

## SNS - Mensagem de Notificação por E-mail
<p align="center">
  <img src="https://github.com/user-attachments/assets/1bacde6d-dc06-469e-8b8a-d818e8e91240">
</p>
