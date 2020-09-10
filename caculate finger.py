#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 10.8.2018 21.13
# @Author  : YINYIN
# @Site    : 
# @File    : caculate finger.py
# @Software: PyCharm

import re
import cookielib, urllib2, urllib
import requests
import poster
import sys
import os
import time
import pandas as pd
import numpy as np
#read file
os.chdir('C:\\Users\\yinyin\\Desktop\\herbpair\\14drugbank')
adme_1 = pd.read_csv('molecule\drug.smi',header=None)
adme_1.columns=['smiles']
adme_2 = pd.DataFrame(adme_1)

drug_id = pd.read_csv('drug_adme.csv',header=None)
drug_id.columns=['drugbank_id','smiles']
drug_id = pd.DataFrame(drug_id)
drug_id.set_index('drugbank_id')

##parameter
cj = cookielib.CookieJar()
opener = poster.streaminghttp.register_openers()
opener.add_handler(urllib2.HTTPCookieProcessor(cookielib.CookieJar()))

##active the website with the input file

##prpare the format
adme_canosmiel = adme_2['canosmile']
adme_canosmie_2 = adme_canosmiel.tolist()
genesStr = '\r\n'.join(adme_canosmie_2)
#list_admet = []
# for smilerow in drugbank_slim_df_2.index:
#     smiles_row_col = drugbank_slim_df_2.loc[smilerow, 'canosmile']
#     list_admet.append(smiles_row_col)

##test
#list_admet = []
#list_admet.append('OC(=O)CCCC[C@@H]1SC[C@H]2[C@@H]1NC(=O)N2'+'\t'+'drug1')
#list_admet.append('N[C@H](C(=O)O)Cc1ccccc1'+'\t'+'drug2')
#genesStr = '\r\n'.join(list_admet)
##
params = {'smiles':genesStr}
datagen, headers = poster.encode.multipart_encode(params)
url = "http://www.swissadme.ch/index.php"
request = urllib2.Request(url,datagen,headers)
x = urllib2.urlopen(request)
responseStr = x.read()
f=open('basic_web.txt','a')
f.write(responseStr)

##
# cj = CookieJar()
# opener = poster.streaminghttp.register_openers()
# opener.add_handler(urllib.request.HTTPCookieProcessor(cj))
#
# genesStr='OC(=O)CCCC[C@@H]1SC[C@H]2[C@@H]1NC(=O)N2'
# params = {'smiles':genesStr}
# datagen, headers = poster.encode.multipart_encode(params)
#
# request = urllib.request.Request(url,datagen,headers)
# x = urllib.request.urlopen(request).read()
# responseStr = request.read()


##find the download web
regex11=r'a href="results/(.+?)/swissadme.csv'
pat1=re.compile(regex11)
downloadfile = re.findall(pat1,responseStr)
downloadfile_websit = "http://www.swissadme.ch/results/" + downloadfile[0]+'/swissadme.csv'
#content = requests.get(downloadfile_websit)

##download
request_download = urllib2.Request(downloadfile_websit)
x_dowwnload = urllib2.urlopen(request_download)
responseSt_download = x_dowwnload.read()
with open("admet.csv", "wb") as code:
    code.write(responseSt_download )

##combine finger and adme
finger_downloaded = pd.read_csv('fourfinger.csv')
finger_downloaded = pd.DataFrame(finger_downloaded )
colnames_get = colnames(finger_downloaded)
finger_downloaded.set_index(colnames_get[0])
adme_downloaded = pd.read_csv('admet.csv')
adme_downloaded = pd.DataFrame(adme_downloaded )
adme_downloaded.reindex(finger_downloaded.index)

adme_downloaded.replace({'Yes':1,'NO':0,'High':1,'Low':0})
adme_downloaded.drop(['ESOL Class','Ali Class','Silicos-IT class'], axis=1)

drug_feature = pd.concat([adme_downloaded,finger_downloaded],axis=1)
drug_feature.to_csv('prepared_file_for_R.csv',index=True)

