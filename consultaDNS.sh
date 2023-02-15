#!/bin/bash

# Define o nome do arquivo contendo os domínios
filename="dominios.txt"

# Define o nome do arquivo de saída
output_file="resultado.txt"

# Cria o arquivo de saída ou o sobrescreve se já existir
> $output_file

# Itera pelo arquivo de domínios
while read domain; do
    # Consulta o registro A do domínio
    a_records=$(dig +short $domain A)

    if [ -n "$a_records" ]; then
        echo "Registros A para $domain:" >> $output_file
        echo "$a_records" | sed 's/.$//' >> $output_file
    else
        echo "Não foi possível encontrar registros A para $domain" >> $output_file
    fi

    # Consulta o whois do domínio
    whois_data=$(whois $domain | grep -E 'Name Server:|Creation Date:|Updated Date:|Domain Status:')

    if [ -n "$whois_data" ]; then
        echo "Dados de whois para $domain:" >> $output_file
        echo "$whois_data" >> $output_file
    else
        echo "Não foi possível encontrar dados de whois para $domain" >> $output_file
    fi

    echo "" >> $output_file

done < "$filename"

