import random
import boto3
import uuid
import csv
import os

###

qtd_linhas = random.randint(1, 100)
nm_arquivo = "relatorio-contabil.csv"
arquivo_existe = os.path.isfile(nm_arquivo)

with open(nm_arquivo, 'a', newline='') as arquivo:
    escritor = csv.writer(arquivo)
    if not arquivo_existe:
        escritor.writerow(["ID_Conta", "Saldo"])
    for n in range(qtd_linhas - 1):
        escritor.writerow([uuid.uuid4(), round(random.random() * 1000, 2)])

###

bucket = input("Insira o nome (único) do seu bucket: ")

client = boto3.client('s3')
client.upload_file(nm_arquivo, bucket, nm_arquivo)

print("Upload para o S3 concluído!")

client.close()

###
