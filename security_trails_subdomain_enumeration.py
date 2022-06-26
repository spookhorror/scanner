
import argparse
from ast import arg
import sys
import requests
import json


def sub_domain(args):
    
        url = "https://api.securitytrails.com/v1/domain/"+args.domain+"/subdomains"
        querystring = {"children_only":"true"}
        headers = {
        'accept': "application/json",
        'apikey': "<your api key>"
                }
        response = requests.request("GET", url, headers=headers, params=querystring)
        result_json=json.loads(response.text)
        sub_domains=[i+'.'+args.domain for i in result_json['subdomains']]
        f=open(args.out,'a+')
        for i in sub_domains:
            f.write(i+'\n')
        f.close()   
        return print("subdomain enumeration done :- security trails")    


if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument('--domain', type=str,
                        help="python3 subdomain.py --domain target.com")
    parser.add_argument('--out', type=str)

    args = parser.parse_args()
    sys.stdout.write(str(sub_domain(args)))
