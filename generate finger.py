#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 6.8.2018 10.12
# @Author  : YINYIN
# @Site    : 
# @File    : keggAPI.py
# @Software: PyCharm


import os
import csv
import gzip
import collections
import re
import io
import json
import xml.etree.ElementTree as ET

import requests
import pandas as pd
import numpy as np
import os
os.chdir('C:\\Users\\yinyin\\Desktop\\herbpair\\14drugbank')
#xml_path = os.path.join('C:\\Users\\yinyin\\Desktop\\herbpair\\14drugbank', 'drugbank_all_full_database.xml.zip')

#with gzip.open(xml_path) as xml_file
tree = ET.parse('full database.xml')
root = tree.getroot()

ns = '{http://www.drugbank.ca}'
inchikey_template = "{ns}calculated-properties/{ns}property[{ns}kind='InChIKey']/{ns}value"
inchi_template = "{ns}calculated-properties/{ns}property[{ns}kind='InChI']/{ns}value"
smiles_template = "{ns}calculated-properties/{ns}property[{ns}kind='SMILES']/{ns}value"

rows = list()
for i, drug in enumerate(root):
    row = collections.OrderedDict()
    assert drug.tag == ns + 'drug'
    row['type'] = drug.get('type')
    row['drugbank_id'] = drug.findtext(ns + "drugbank-id[@primary='true']")
    row['name'] = drug.findtext(ns + "name")
    row['description'] = drug.findtext(ns + "description")
    row['groups'] = [group.text for group in
                     drug.findall("{ns}groups/{ns}group".format(ns=ns))]
    row['atc_codes'] = [code.get('code') for code in
                        drug.findall("{ns}atc-codes/{ns}atc-code".format(ns=ns))]
    row['categories'] = [x.findtext(ns + 'category') for x in
                         drug.findall("{ns}categories/{ns}category".format(ns=ns))]
    row['inchi'] = drug.findtext(inchi_template.format(ns=ns))
    row['inchikey'] = drug.findtext(inchikey_template.format(ns=ns))
    row['smiles'] = drug.findtext(smiles_template.format(ns=ns))

    # Add drug aliases
    aliases = {
        elem.text for elem in
        drug.findall("{ns}international-brands/{ns}international-brand".format(ns=ns)) +
        drug.findall("{ns}synonyms/{ns}synonym[@language='English']".format(ns=ns)) +
        drug.findall("{ns}international-brands/{ns}international-brand".format(ns=ns)) +
        drug.findall("{ns}products/{ns}product/{ns}name".format(ns=ns))

    }
    aliases.add(row['name'])
    row['aliases'] = sorted(aliases)

    rows.append(row)

alias_dict = {row['drugbank_id']: row['aliases'] for row in rows}
with open('aliases.json', 'w') as fp:
    json.dump(alias_dict, fp, indent=2, sort_keys=True)

def collapse_list_values(row):
    for key, value in row.items():
        if isinstance(value, list):
            row[key] = '|'.join(value)
    return row

rows = list(map(collapse_list_values, rows))
columns = ['drugbank_id', 'name', 'type', 'groups', 'atc_codes', 'categories', 'inchikey', 'inchi', 'description','smiles']
drugbank_df = pd.DataFrame.from_dict(rows)[columns]
drugbank_df = drugbank_df.set_index('drugbank_id')

drugbank_slim_df = drugbank_df[
    drugbank_df.groups.map(lambda x: 'approved' in x) &
    drugbank_df.smiles.map(lambda x: x is not None) &
    drugbank_df.type.map(lambda x: x == 'small molecule')
]
drugbank_slim_df.head()

# write drugbank tsv
drugbank_df.to_csv( 'drugbank.tsv')

# write slim drugbank tsv
drugbank_slim_df.to_csv('drugbanksmi.tsv')

##convert to cannosmile
import pybel

smiles_used = drugbank_slim_df['smiles']
cans_2 = [pybel.readstring("smi", smile).write("can") for smile in smiles_used]
cans =[i.strip('\r').replace('\n','') for i in cans_2]
cans_pd = pd.DataFrame(cans,index= drugbank_slim_df.index,columns =['canosmile'])
#,columns =('canosmile')
drugbank_slim_df_2 = pd.concat([drugbank_slim_df, cans_pd], axis=1)
drugbank_slim_df_2.to_csv( 'drugbank_slim_df_cano_real.csv')
cans_pd.to_csv( 'cans_pd.csv')

#delete not caculable smiles
list3=[]
list4=[]
for smilerow in drugbank_slim_df_2.index:
    smiles_row_col = drugbank_slim_df_2.loc[smilerow, 'canosmile']
    list3.append('no') if '.' in smiles_row_col else list3.append('YES')
    list4.append('no') if len(smiles_row_col)<12 else list4.append('YES')
drugbank_slim_df_2['caculable'] = list3
drugbank_slim_df_2['length'] = list4
drugbank_slim_df_2 = drugbank_slim_df_2.loc[drugbank_slim_df_2['caculable'] == 'YES']
drugbank_slim_df_2 = drugbank_slim_df_2.loc[drugbank_slim_df_2['length'] == 'YES']
drugbank_slim_df_2.to_csv('cans_pd_delete.csv')
drugbank_slim_df_3 = drugbank_slim_df_2['canosmile']
drugbank_slim_df_3.to_csv('molecule\drug.smi',index = False)
drugbank_slim_df_3.to_csv('drug_adme.csv',index = True)

##fenger
import os,csv,shutil
fptitles={'FP':['FP%d' %i for i in range(1,1025)],
         'EStateFP':['EStateFP%d'%i for i in range(1,80)],
         'MACCSFP':['MACCSFP%d'%i for i in range(1,167)],
         'PubchemFP':['PubchemFP%d'%i for i in range(881)],
         'SubFP':['SubFP%d'%i for i in range(1,308)],
         'ExtFP':['ExtFP%d'%i for i in range(1,1025)]
         }
debug_mod = False
padelpath = 'C:\\Users\\yinyin\\Downloads\\PaDEL-Descriptor\\PaDEL-Descriptor.jar'

def prepareInputDir(filename):
    shutil.copyfile('molecule/%s.smi'%filename,'padelinput/input.smi')

def get_prefixes():
    files = os.listdir('molecule/')
    outfilenames = []
    for filename in files:
        try:
            if filename[-4:]=='.smi':
                outfilenames.append(filename[:-4])
        except:
            continue
    return outfilenames

def splitFingerprint(filename,prefix):
    global fptitles
    fieldname = []
    for i in fptitles:
        fieldname+=fptitles[i]
    #set write file
    fs={}
    for fptitle in fptitles:
        fs[fptitle]=open('des/'+prefix+"_"+fptitle+'.tab','wb')
    #add write file
    feature = {}
    #add description
    allfenger = pd.read_csv('des.csv')

    for f in fs:
        selectfea = fptitles[f]
        feature[f] = allfenger[selectfea]
        allfenger_2 = allfenger[selectfea]
        allfenger_2.to_csv(fs[f].name)
    #close the file
    for f in fs:
        fs[f].close()
    ##combine finger
    drug_feature = pd.concat([feature['ExtFP'], feature['PubchemFP'], feature['SubFP'], feature['MACCSFP']], axis=1)
    drug_feature.to_csv('fourfinger_indic.csv', index=True)
    return feature

def shellPadel():

    #TODO set fingerprint
    output = os.system('java -jar '+padelpath+' -help >nul 2>nul')
    if output!=0:
        print('Cannot open PaDEL-Descriptor, please check the path')
        return 0
    debug = ' ' if debug_mod else ' >nul'
    os.system('java -jar %s -descriptortypes padel-des.xml -file des.csv -dir padelinput -fingerprints -removesalt -standardizenitro -detectaromaticity%s' % (padelpath,debug))

datasets = get_prefixes()
for dataset in datasets:
    prepareInputDir(dataset)
    shellPadel()
    splitFingerprint('des.csv', dataset)
    if not debug_mod:
        os.remove('des.csv')



