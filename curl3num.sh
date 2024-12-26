#!/bin/bash

if [ "$2" == "" ]; then
    echo "Enum com CURL"
    echo "Modo de uso: $0 IP ou URL e path da wordlist"
    echo "Exemplo: $0 172.16.1 /usr/share/wordlists/rockyou.txt"
else
    # Total de linhas no arquivo (wordlist)
    total=$(wc -l < "$2")
    # Linha atual começa em 0
    current=0

    # Configura o IFS para separar apenas por quebras de linha
    IFS=$'\n'

    # Loop para processar cada linha da wordlist
    for palavra in $(<"$2"); do
        # Incrementa a linha atual
        ((current++))

        # Calcula o progresso em porcentagem
        progresso=$((current * 100 / total))

        # Calcula a quantidade de barras para a barra de progresso
        barras=$((progresso / 2))

        # Imprime a barra de progresso (sem quebrar a linha)
        printf "\r[%s%s] %d%% - Analisando linha %d de %d" \
            "$(printf "#%.0s" $(seq 1 $barras))" \
            "$(printf " %.0s" $(seq $barras 49))" \
            $progresso $current $total

        # Realiza o curl para verificar a resposta
        resposta=$(curl -H "user-Agent: tester" -s -o /dev/null -w "%{http_code}" "$1/$palavra/")
        
        # Se o status da resposta for 200, imprime o diretório encontrado
        if [ "$resposta" == "200" ]; then
            echo -e "\nDiretório encontrado: $1/$palavra"
        fi
    done
    echo  # Quebra a linha após o loop para garantir que o prompt fique em nova linha
fi
