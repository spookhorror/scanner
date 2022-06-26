#!/bin/bash


#Colour Output
NC='\033[0m'       
Red='\033[0;31m'   
Green='\033[0;32m' 
Yellow='\033[0;33m'
Blue='\033[0;34m'


sublister(){
    #---- subdomain finder ----#
    
    sublist3r -d $target -o output/$target/$target-subdomain.txt
    clear
    subfinder -d $target -o output/$target/subdomain_2.txt
    clear
    cat  output/$target/subdomain_2.txt | tee -a output/$target/$target-subdomain.txt
    rm output/$target/subdomain_2.txt
    curl -s "https://dns.bufferover.run/dns?q=.$target" | jq -r .FDNS_A[] | cut -d',' -f2 | sort -u | tee -a output/$target/$target-subdomain.txt
    clear
    curl -s "https://crt.sh/?q=%25.$target&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee -a output/$target/$target-subdomain.txt
    clear
    curl -s "https://certspotter.com/api/v1/issuances?domain=$target&include_subdomains=true&expand=dns_names" | jq .[].dns_names | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u  | tee -a output/$target/$target-subdomain.txt
    clear
    amass enum -passive -d $target -src |  awk '{print$2}' | tee -a output/$target/$target-subdomain.txt
    clear
    findomain --quiet --target $target | tee -a output/$target/$target-subdomain.txt
    clear
    python3 security_trails_subdomain_enumeration.py --domain $target --out output/$target/$target
    cat output/$target/$target-subdomain.txt | sort -u > output/$target/$target-test.txt
    cat output/$target/$target-test.txt > output/$target/$target-subdomain.txt
    rm output/$target/$target-test.txt
    clear
}


whois_(){
        whois $target > output/$target/$target-whois.txt
}

subdomain_takeover(){
    #----------------------------subdomain takeover----------------------------#
    subzy --targets output/$target/$target-subdomain.txt > output/$target/report_for_subdomain_takeover.txt
}




live_website(){
    #-------------------- checking for live subdomain --------------------#
    cat output/$target/$target-subdomain.txt | httpx -status-code --no-color -cname --output output/$target/httpx.txt
    clear
    cat output/$target/httpx.txt | cut -d"/" -f3 > output/$target/CODE.txt
    # rm output/$target/output.txt
    cat output/$target/CODE.txt | grep 20 | awk '{print$1}' >  output/$target/live_website.txt
    cat output/$target/CODE.txt | grep 30 | awk '{print$1}' >  output/$target/30x_website.txt
    cat output/$target/CODE.txt | grep 40 | awk '{print$1}' >  output/$target/40X_website.txt
    cat output/$target/CODE.txt | grep 50 | awk '{print$1}' >  output/$target/50X_website.txt
    rm output/$target/CODE.txt
}


waybackurls(){
#-------------------------------URL enumeration-----------------------------#
    echo "$target" | waybackurl > output/$target/waybackurl.txt
}

waybackurlsforsingletarget(){
        #-------------------------------URL enumeration-----------------------------#
    echo "$target" | waybackurl -no-subs > output/$target/waybackurl.txt
}


live_url_enumeration(){
 
#------------------------------live-url-enumerate----------------------------#

httpx -l output/$target/waybackurl.txt -status-code --no-color -o output/$target/output_1.txt
cat output/$target/output_1.txt | grep 20 | cut -d" " -f1 > output/$target/live_url.txt
cat output/$target/output_1.txt | grep 30 | cut -d" " -f1 > output/$target/redirect_url.txt
cat output/$target/output_1.txt | grep 40 | cut -d" " -f1 > output/$target/40X_url.txt
cat output/$target/output_1.txt | grep 50 | cut -d" " -f1 > output/$target/50X_url.txt
rm output/$target/output_1.txt
sleep 10
}

file_enumeration(){
    #------------------------------Gf-Patterns----------------------------------#
mkdir output/$target/endpoint/

for i in $(gf -list)
do
    cat  output/$target/live_url.txt | gf $i > output/$target/endpoint/$i.txt
done
}

nmap_for_domain(){
    nmap -iL output/$target/live_website.txt -sV --script vuln -oA output/$target/nmap.txt
}
nmap_for_single_target(){
    nmap $target -sV --script vuln -oA output/$target/nmap_for_$target.txt
}



    domain(){
echo -e "scan started on ${target}" | notify > /dev/null 2>&1
echo -e "\t${Green}scan started ON${NC} ${Yellow}`date`${NC}"
echo -e "${Green}1.Whois Lookup${NC}"
whois_ > /dev/null 2>&1
sleep 5
echo -e "${Green}2.Subdomain Enumeration Started${NC}"
sleep 1
sublister > /dev/null 2>&1
sleep 2
echo -e "${Green}3.Subdomain Enumeration is finished${NC}"
sleep 2
echo -e "${Green}4.Subdomain Takeover started${NC}"
subdomain_takeover > /dev/null 2>&1
sleep 5
echo -e "${Green}5.Live website enumeration${NC}"
sleep 5
live_website > /dev/null 2>&1
sleep 2
echo -e "${Green}6.URL enumeration started${NC}"
waybackurls > /dev/null 2>&1
sleep 2
echo -e "${Green}7.Live URL enumeration${NC}"
sleep 5
live_url_enumeration > /dev/null 2>&1
sleep 2
echo -e "${Green}8.Separating different endpoint for different vulnerabilities${NC}"
sleep 5
file_enumeration > /dev/null 2>&1
sleep 2
echo -e "${Green}9.Nmap scan Started==================${NC}"
echo -e "${Green}It will so much time so please wait${NC}"
nmap_for_domain > /dev/null 2>&1
echo "scan finished on ${target}" | notify /dev/null 2>&1
}


    single_target(){
echo "scan started on ${target}" | notify > /dev/null 2>&1
echo -e "${Green}1.URL enumeration started${NC}"
waybackurlsforsingletarget > /dev/null 2>&1
echo -e "${Green}2.Live URL enumeration started${NC}"
live_url_enumeration > /dev/null 2>&1
echo -e "${Green}3.File enumeration started${NC}"
file_enumeration > /dev/null 2>&1
# vulnerability > /dev/null 2>&1
nmap_for_single_target > /dev/null 2>&1
echo "scan finished on ${target}" | notify /dev/null 2>&1
    }



    Help(){
            echo -e "   commands                                       usage\n"
    echo -e "-d for Full scan Note:only domain              bash scanner.sh -d target.com"
    echo -e "-s for single target                           bash scanner.sh -s domain , subdomain or IP"
    echo -e "-S for subdomain enumeration only              bash scanner.sh -S target.com "
    }

    while getopts :d:s:i:I:S:h flag
    do
        case "${flag}" in
            d) target=${OPTARG}
                mkdir output > /dev/null 2>&1
                mkdir output/$target > /dev/null 2>&1
                domain;;
            s) target=${OPTARG}
                mkdir output > /dev/null 2>&1
                mkdir output/$target > /dev/null 2>&1
                single_target;;
            S) target=${OPTARG}
                mkdir output > /dev/null 2>&1
                mkdir output/$target > /dev/null 2>&1
                sublister
                live_website;;                
            h)  Help;;
                  \?) # Invalid option
                    echo "Error: Invalid option"
                    exit;
        esac
    done

