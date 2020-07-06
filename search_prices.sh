#!/bin/bash
# Pegar e comparar preços
cache_dir=~/.cache

# Função pegar preço da Kabum:
#    $1 - url
#    retorna o preco

function kabum_get(){
    item_url=$1
    file_tmp=$cache_dir/file_tmp_kabum
    wget -q -O $file_tmp $item_url
    price=$(cat $file_tmp | grep 'itemprop="price"')
    price=$(echo $price | cut -d" " -f3 | cut -d'"' -f2)
    product_exist=$(cat $file_tmp | grep "indisponivel")
    if [ -n "$product_exist" ];then
        price=0
    fi
    if [ -e $file_tmp ]; then
        rm $file_tmp
    fi
    echo $price
}

# Função pegar preço da Terabyte:
#    $1 - url
#    retorna o preco

function terabyte_get(){
    item_url=$1
    file_tmp=$cache_dir/file_tmp_tera
    wget -q -O $file_tmp $item_url
    price=$(cat $file_tmp | grep 'totalvalue')
    price=$(echo $price | cut -d" " -f2 | cut -d"," -f1)
    product_exist=$(cat $file_tmp | grep "indisponivel")
    if [ -n "$product_exist" ];then
        price=0
    fi
    if [ -e $file_tmp ]; then
        rm $file_tmp
    fi
    echo $price
}

# Função pegar preço da Pichau:
#    $1 - url
#    retorna o preco

function pichau_get(){
    item_url=$1
    file_tmp=$cache_dir/file_tmp_pichau
    wget -q -O $file_tmp $item_url
    price=$(cat $file_tmp | grep 'offers' | sed -e "s/],/\n/g" | grep 'offers' | sed -e 's/,/\n/g' | grep '"price"' | cut -d':' -f2)
    product_exist=$(cat $file_tmp | grep "indispon")
    if [ -n "$product_exist" ];then
        price=0
    fi
    if [ -e $file_tmp ]; then
        rm $file_tmp
    fi
    echo $price
}

# Função escrever resultados
#    $1 - Loja
#    $2 - Preço Processador
#    $3 - Preco Placa Mãe
#    $4 - Preço Fonte
#    $5 - Preço Memória

function write_results(){
    echo -en "Resultados para a pesquisa de peças da loja $1 \n######################################\nProcessador: "
    if [ -n "$2" ];then
        pr2=$(echo "scale=2;$2/1" | bc | sed -e 's/,/./g')
        echo -e $pr2
    else
        pr2=0
        echo -en "preço não encontrado!\n"
    fi
    echo -en "######################################\nPlaca Mãe: "
    if [ -n "$3" ];then
        pr3=$(echo "scale=2;$3/1" | bc | sed -e 's/,/./g')
        echo -e $pr3
    else
        pr3=0
        echo -en "preço não encontrado!\n"
    fi
    echo -en "######################################\nFonte: "
    if [ -n "$4" ];then
        pr4=$(echo "scale=2;$4/1" | bc | sed -e 's/,/./g')
        echo -e $pr4
    else
        pr4=0
        echo -en "preço não encontrado!\n"
    fi
    echo -en "######################################\nMemória: "
    if [ -n "$5" ];then
        pr5=$(echo "scale=2;$5/1" | bc | sed -e 's/,/./g')
        echo -e $pr5
    else
        pr5=0
        echo -en "preço não encontrado!\n"
    fi
    echo -en "######################################\nPreço Total: "
    total=$(echo "scale=2;$pr2+$pr3+$pr4+$pr5/1" | bc)
    echo -en "$total\n"
}

#########################################################
# KABUM
#Pegando preço do processador AMD Ryzen 3 3200g
url_pr_kabum="https://www.kabum.com.br/produto/102248/processador-amd-ryzen-3-3200g-cache-4mb-3-6ghz-4ghz-max-turbo-am4-yd3200c5fhbox"
preco_pr_kabum=$(kabum_get $url_pr_kabum)

#Pegando preco da placa mãe AsRock A320M da Kabum
url_pl_kabum="https://www.kabum.com.br/produto/94927/placa-m-e-asrock-a320m-hd-amd-am4-matx-ddr4"
preco_pl_kabum=$(kabum_get $url_pl_kabum)

#Pegando preço da fonte Aerocool 500W 80 Plus Bronze KCAS-500W da Kabum
url_fonte_kabum="https://www.kabum.com.br/produto/57437/fonte-aerocool-500w-80-plus-bronze-kcas-500w-en53367"
preco_fonte_kabum=$(kabum_get $url_fonte_kabum)

#Pegando preço da memória Corsair Vengeance lpx 8gb 2400mhz
url_mem_kabum="https://www.kabum.com.br/produto/84471/mem-ria-corsair-vengeance-lpx-8gb-2400mhz-ddr4-cl16-preto-cmk8gx4m1a2400c16"
preco_mem_kabum=$(kabum_get $url_mem_kabum)

write_results "Kabum" $preco_pr_kabum $preco_pl_kabum $preco_fonte_kabum $preco_mem_kabum

#########################################################
# Terabyte
#Pegando preço do processador da Terabyte AMD Ryzen 3 3200g
url_pr_tera="https://www.terabyteshop.com.br/produto/11543/processador-amd-ryzen-3-3200g-36ghz-40ghz-turbo-4-core-4-thread-cooler-wraith-stealth-am4"
preco_pr_tera=$(terabyte_get $url_pr_tera)

#Pegando preco da placa mãe AsRock A320M da Terabyte
url_pl_tera="https://www.terabyteshop.com.br/produto/10100/placa-mae-asrock-a320m-hd-ddr4-amd-am4"
preco_pl_tera=$(terabyte_get $url_pl_tera)

#Pegando preço da fonte Aerocool 400W 80 Plus Bronze KCAS-400W da Terabyte (500W Não tinha)
url_fonte_tera="https://www.terabyteshop.com.br/produto/11106/fonte-aerocool-kcas-full-range-400w-80-plus-white-pfc-ativo"
preco_fonte_tera=$(terabyte_get $url_fonte_tera)

#Pegando preço da memória Corsair Vengeance lpx 8gb 2400mhz
url_mem_tera="https://www.terabyteshop.com.br/produto/6647/memoria-ddr4-corsair-vengeance-lpx-cmk8gx4m1a2400c14-8gb-2400mhz"
preco_mem_tera=$(terabyte_get $url_mem_tera)

write_results "Terabyte" $preco_pr_tera $preco_pl_tera $preco_fonte_tera $preco_mem_tera

#########################################################
# Pichau
#Pegando preço do processador da Pichau AMD Ryzen 3 3200g
url_pr_pichau="https://www.pichau.com.br/hardware/processador-amd-ryzen-3-3200g-quad-core-3-6ghz-4ghz-turbo-6mb-cache-am4-yd3200c5fhbox"
preco_pr_pichau=$(pichau_get $url_pr_pichau)

#Pegando preco da placa mãe AsRock A320M da Pichau
url_pl_pichau="https://www.pichau.com.br/asrock/placa-mae-asrock-a320m-hd-ddr4-socket-am4-chipset-amd-a320-1"
preco_pl_pichau=$(pichau_get $url_pl_pichau)

#Pegando preço da fonte Aerocool 500W 80 Plus Bronze KCAS-500W da Pichau
url_fonte_pichau="https://www.pichau.com.br/hardware/fonte-aerocool-kcas-500w-en53367"
preco_fonte_pichau=$(pichau_get $url_fonte_pichau)

#Pegando preço da memória Corsair Vengeance lpx 8gb 2400mhz
url_mem_pichau="https://www.pichau.com.br/corsair/memoria-corsair-vengeance-lpx-preto-8gb-1x8-2400mhz-ddr4-cmk8gx4m1a2400c16"
preco_mem_pichau=$(pichau_get $url_mem_pichau)

write_results "Pichau" $preco_pr_pichau $preco_pl_pichau $preco_fonte_pichau $preco_mem_pichau
