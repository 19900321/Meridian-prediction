#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 3.9.2018 23.55
# @Author  : YINYIN
# @Site    : 
# @File    : Mesh.py
# @Software: PyCharm

import pandas as pd
import numpy as np
import os
from functools import reduce
os.chdir('C:\\Users\\yinyin\\Desktop\\herbpair\\14drugbank\\Mesh')
#disease_fiel = pd.read_csv('')
mesh_dataframe=pd.DataFrame(columns=[])
meshFile = 'd2018.bin'
with open(meshFile, mode='rb') as file:
    mesh = file.read().decode('utf-8')
meshterm=mesh.split('*NEWRECORD')
num=0
for term in meshterm:
    num = num+1
    print(num)
    term_properties=term.split('\n')
    RECTYPE = [i[10:] for i in term_properties if i.startswith('RECTYPE =')]
    MH = [i[5:] for i in term_properties if i.startswith('MH =')]
    AQ = [i[5:] for i in term_properties if i.startswith('AQ =')]
    ENTRY = [i[8:] for i in term_properties if i.startswith('ENTRY =')]
    MN = [i[5:] for i in term_properties if i.startswith('MN =')]
    PA = [i[5:] for i in term_properties if i.startswith('PA =')]
    MH_TH = [i[8:] for i in term_properties if i.startswith('MH_TH =')]
    ST = [i[5:] for i in term_properties if i.startswith('ST =')]
    N1 = [i[5:] for i in term_properties if i.startswith('N1 =')]
    RN = [i[5:] for i in term_properties if i.startswith('RN =')]
    RR = [i[5:] for i in term_properties if i.startswith('RR =')]
    AN = [i[5:] for i in term_properties if i.startswith('AN =')]
    PI = [i[5:] for i in term_properties if i.startswith('PI =')]
    MS = [i[5:] for i in term_properties if i.startswith('MS =')]
    PM = [i[5:] for i in term_properties if i.startswith('PM =')]
    HN = [i[5:] for i in term_properties if i.startswith('HN =')]
    MR = [i[5:] for i in term_properties if i.startswith('MR =')]
    DA = [i[5:] for i in term_properties if i.startswith('DA =')]
    DC = [i[5:] for i in term_properties if i.startswith('DC =')]
    DX = [i[5:] for i in term_properties if i.startswith('DX =')]
    UI = [i[5:] for i in term_properties if i.startswith('UI =')]
    Mesh_list = [[RECTYPE] + [MH] + [AQ] + [ENTRY] + [MN] + [PA] +[MH_TH] + [ST] + [N1] + [RN] + [RR] + [AN] + [PI] + [MS] + [PM] + [HN] + [MR] + [DA] + [DC] + [DX] + [UI]]
    print(Mesh_list)
    #Mesh_list = RECTYPE
    #Mesh_list.append(MH).append(AQ).append(ENTRY).append(MN).append(PA).append(MH_TH).append(ST).append(N1).append(RN).append(RR)
    #Mesh_list.append(AN).append(PI).append(MS).append(PM).append(HN).append(MR).append(DA).append(DC).append(DX).append(UI)
    mesh_dataframe = mesh_dataframe.append(Mesh_list, ignore_index=True)
mesh_dataframe.to_csv('MESH.CSV')


with open('mtrees2018.bin',mode='rb') as mtrees:
     trees= mtrees.read().decode('utf-8')
     trees = trees.split('\n')

tree_term_dic = {}
tree_number_dic={}
num2=0
for tree in trees:
    num2 = num2+1
    print(num2)
    treelist=tree.split(';')
    term = treelist[0]
    treenumber = treelist[1]
    tree_number_dic[treenumber] = term
    if term not in tree_term_dic:
        tree_term_dic[term] = [treenumber]
    else:
        tree_term_dic[term] = tree_term_dic[term]+[treenumber]

tree_term_dic_pd = pd.DataFrame.from_dict(tree_term_dic,orient='index')
tree_term_dic_pd.to_csv('tree_term_dic_pd.csv')
tree_number_di_pd = pd.DataFrame.from_dict(tree_number_dic,orient='index')
tree_number_di_pd.to_csv('tree_number_di_pd.csv')


def num_parent__term(num,tree_number_dic):
    num=num.strip()
    parent_items= {num[:-4]: tree_number_dic[num[:-4]]}
    # brunchs_num = num[:-4]
    # term_parent = tree_number_dic[brunchs_num]
    # parent_items = [brunchs_num]+[term_parent]
    return parent_items
def term_parent__num(term,tree_term_dic):
    term=term.strip()
    nums = tree_term_dic[term]
    parent_items = {num[:-4]: tree_number_dic[num[:-4]] for num in nums}
    # term_parents_2 = [{num[:-4]:tree_number_dic[num[:-4]}] for num in nums]
    # nums_parents = [num[:-4] for num in nums]
    # parent_items = [nums_parents] + [term_parents]
    return parent_items
def term_parent_level_1__num(term,tree_term_dic):
    term=term.strip()
    nums = tree_term_dic[term]
    parent_items = {num[:3] for num in nums}
    parent_items=list(parent_items)
    # term_parents_2 = [{num[:-4]:tree_number_dic[num[:-4]}] for num in nums]
    # nums_parents = [num[:-4] for num in nums]
    # parent_items = [nums_parents] + [term_parents]
    return parent_items

def num_parent__term_level(num,tree_number_dic,level):
    num = num.strip()
    index =4*level-1
    parent_items = {num[:index]: tree_number_dic[num[:index]]}
    # brunchs_num = num[:index]
    # term_parent = tree_number_dic[brunchs_num]
    # parent_items = [brunchs_num]+[term_parent]
    return parent_items
def term_parent__num_level(term,tree_term_dic,level):
    term = term.strip()
    nums = tree_term_dic[term]
    index = 4 * level - 1
    parent_items = {num[:index]: tree_number_dic[num[:index]] for num in nums}
    # term_parents = [tree_number_dic[num[:index]] for num in nums]
    # parent_items = [nums] + [term_parents]
    return parent_items

def num_child_term_level(num,tree_number_dic,level):
    num_node = len(num.split('.'))
    num_node_child = num_node+level
    parent_items ={i:tree_number_di_pd.loc[i,].tolist() for i in tree_number_di_pd.index if len(i.split('.'))==num_node_child and i.startswith(num)}
    return parent_items
def term_child__num_level(term,tree_term_dic,level):
    term = term.strip()
    nums = tree_term_dic[term]
    parent_items = {num: {i: tree_number_di_pd.loc[i,].tolist() for i in tree_number_di_pd.index if len(i.split('.')) == (len(num.split('.')) + level) and i.startswith(num)} for num in nums}
    return parent_items

MESH_dic = pd.read_csv('MESH.CSV')
MESH_dic = pd.DataFrame(MESH_dic)

drug = pd.read_csv('result.csv')
drug_df = pd.DataFrame(drug)

num=0
dic_com_treenum = {}
dic_com_term = {}
pd_com_all_entries = pd.DataFrame()
pd_com_term = pd.DataFrame( )
pd_term_type = pd.DataFrame( )
pd_compound_type = pd.DataFrame( )
for_dupli_list = []
for col in drug_df.index:
    num+=1
    print(num)
    drug_item = drug_df.loc[col]
    mesh_ids = drug_df.loc[col,'mesh_id']
    com_name = drug_df.loc[col,'name']
    mesh_id = mesh_ids.replace('\'', '').replace('[', '').replace(']', '').split(',')
    mesh_id_list = [j.strip() for j in mesh_id]
    mesh_tree_list = [MESH_dic[MESH_dic['UI']==i]['MN'].tolist() for i in mesh_id_list]
    mesh_term_list = [MESH_dic[MESH_dic['UI'] == i]['MH'].tolist() for i in mesh_id_list]
    mesh_tree_list_2 = [tree_term_dic[term[0]] for term in mesh_term_list]
    branch = set([node[:3] for node in reduce(lambda x, y: x + y, mesh_tree_list_2)])
    branch_2 = list(branch)
    drug_all_entries =[drug_item.tolist()+[mesh_tree_list]+[mesh_term_list]+[branch_2]]
    pd_com_all_entries = pd_com_all_entries.append(drug_all_entries)

    for term in mesh_term_list:
        term=term[0]
        list_1=[com_name]+[term]+['compound_term']
        pd_com_term=pd_com_term.append([list_1],ignore_index=True)
        if term not in for_dupli_list:
            mesh_tree_list_term= tree_term_dic[term]
            branch_term = set([node[:3] for node in mesh_tree_list_term])
            branch_term_2 = list(branch_term)
            for m in branch_term_2:
                list_2 = [term]+[m]+['term_type']
                pd_term_type = pd_term_type.append([list_2])
        for_dupli_list = for_dupli_list+[term]
    for j in branch_2:
        list_3= [com_name] + [j]+['compound_type']
        pd_compound_type=pd_compound_type.append([list_3])
pd_term_type.columns =['term','type','type_node_pair']
pd_compound_type.columns =['compound','type','type_node_pair']
pd_com_term.columns =['compound','term','type_node_pair']

def node_type_collection(node_name,pd_node_type):
    node_type_set=list(set(pd_node_type[node_name].tolist()))
    pd_node_set = pd.DataFrame()
    pd_node_set['node']=node_type_set
    pd_node_set['node_type']=[node_name]*len(node_type_set)
    return pd_node_set
term_node = node_type_collection('term',pd_term_type)
type_node = node_type_collection('type',pd_term_type)
compound_node = node_type_collection('compound',pd_compound_type)

#
def organ_pf(oragnname):
    pd_liver = drug_df[drug_df[oragnname]==1][[oragnname,'name']]
    pd_liver_2 = pd_liver.replace(1,oragnname)
    pd_liver_2.columns =['compound','organ']
    return pd_liver_2
allcom_organ = reduce(lambda x, y:  pd.concat([x, y], axis=0,ignore_index=True), [organ_pf(organ) for organ in ['Liver','Lung','Stomach','Heart','Spleen','Kidney','LargeIntestine']])
allcom_organ_2 =allcom_organ.copy()
allcom_organ_2['node_type']=['organ_compound']*len(allcom_organ.index)
allcom_organ_2.to_csv('allcom_organ_2.csv')

pd_term_type.columns =['node1','node2','node_type']
pd_com_term.columns =['node1','node2','node_type']
allcom_organ_2.columns =['node1','node2','node_type']

all_input_pd = pd.concat([allcom_organ_2,pd_term_type,pd_com_term],axis=0,ignore_index=True)
all_input_pd.to_csv('all_input_pd.csv')

organ_node = node_type_collection('organ',allcom_organ_2)
node_identify = pd.concat([organ_node,type_node,term_node,compound_node],axis=0,ignore_index=True)
node_identify.to_csv('node_identify.csv')

##statistic
compound_type = pd.read_csv('pd_compound_type.csv')
compound_type = pd.DataFrame(compound_type)
pd_compound_type_organ=pd.DataFrame()
def com_type_organ_fun(oragnname,drug_df,compound_type):
    pd_liver_names = drug_df[drug_df[oragnname]==1]['name'].tolist()
    pd_compound_type_organ=compound_type.loc[compound_type['compound'].isin(pd_liver_names)]
    pd_compound_type_organ['organ']=[oragnname]*len(pd_compound_type_organ.index)
    return pd_compound_type_organ
compound_type_all_organ = reduce(lambda x, y:  pd.concat([x, y], axis=0,ignore_index=True), [com_type_organ_fun(organ,drug_df,compound_type) for organ in ['Liver','Lung','Stomach','Heart','Spleen','Kidney','LargeIntestine']])
compound_type_all_organ.to_csv('compound_type_all_organ.csv')
statistics = compound_type_all_organ.groupby(by=['organ','type'])
newdf = statistics.size()
newdf = newdf.reset_index(name='number')
newdf.to_csv('statistic_bar')

##correct
input = pd.read_csv('pd_compound_type.csv')
compound_type = pd.DataFrame(compound_type)
pd_compound_type_organ=pd.DataFrame()

import datetime
now = datetime.datetime.now()
today_data=now.strftime("%Y-%m-%d")
if str(today_data)=='2018-09-20':
    print('Happy birthday to you, Jing!')
else:
    print('Have a nice day!')