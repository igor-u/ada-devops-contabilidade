## Tekuchi Contabilidade

- Trocar **email@[]()example.com**, em `sns.tf`, pelo seu e-mail.

```
  terraform init
```
```
  terraform plan -out tekuchi-plan
```
```
  terraform apply -auto-approve
```
## Confirmação de que o Banco de Dados Existe
- Senha: tekuchi123
- Copiar endpoint da instância de banco de dados criada, colar no lugar de `my-db-endpoint` no comando:
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
```
  python3 auditoria-fiscal.py
```
## MySQL - Resultado
<p align="center">
  <img src="https://github.com/user-attachments/assets/6e232ede-caa3-45dc-8332-75b74ba5d736">
</p>

## SNS - Mensagem de Notificação por E-mail
<p align="center">
  <img src="https://github.com/user-attachments/assets/1bacde6d-dc06-469e-8b8a-d818e8e91240">
</p>
