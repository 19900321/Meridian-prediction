w1=open('1.txt').readlines()
w2=open('2.txt').readlines()
w3=open('3.txt').readlines()
w4=open('4.txt').readlines()
f1=open('try10180109.txt','w')
listpro=[]
listmeri=[]

for i1 in w2:
    a1=i1.strip().upper().replace('\n','')
    listpro=listpro+[a1]
print listpro

for i2 in w3:
    a2=i2.strip().upper().replace('\n','')
    listmeri=listmeri+[a2]
print listmeri


listall=listpro+listmeri
print listall

for k in w1:
    j=k.strip().upper().replace('\n','').split('\t')
    
    property12=j[6].strip().split(',')
    print property12
    
    meridians12=j[7].strip().replace('\n','').split(',')
    print meridians12
    
    list1=[]
    for i in listall:
        if i.strip().upper()in  property12 or i.strip().upper()in meridians12:
            list1=list1+['1']
        else:
            list1=list1+['0']
    print list1
    f1.write('\t'.join(j[0:9]+list1)+'\n')
f1.close()

