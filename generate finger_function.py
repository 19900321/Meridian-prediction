#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 26.8.2018 16.20
# @Author  : YINYIN
# @Site    : 
# @File    : generate finger_function.py
# @Software: PyCharm
import pandas as pd
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