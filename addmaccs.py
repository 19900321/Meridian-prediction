w1=open('1.txt').readlines()
w2=open('2.txt').readlines()
f1=open('maccs fingerprint.txt','w')
dic2={}

for i2 in w2:
    a12=i2.strip().replace('\n','').split('\t')
    a22=a12[0].strip()
    a32=a12[1:]
    dic2[a22]=a32
for i1 in w1:
    print(i1)
    a1=i1.strip().replace('\n','').split('\t')
    a2=a1[0].strip()
    a3=a1[1].strip()
    if a3 in dic2:
        a4=a1+dic2[a3]
        f1.write('\t'.join(a4)+'\n')
f1.close()
