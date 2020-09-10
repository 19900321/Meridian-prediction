import os,csv,shutil
from setting import *

#set fingerprint title
fptitles={'FP':['FP%d' %i for i in range(1,1025)],
         'EStateFP':['EStateFP%d'%i for i in range(1,80)],
         'MACCSFP':['MACCSFP%d'%i for i in range(1,167)],
         'PubchemFP':['PubchemFP%d'%i for i in range(881)],
         'SubFP':['SubFP%d'%i for i in range(1,308)]
         }

def shellPadel():

    #TODO set fingerprint
    output = os.system('java -jar '+padelpath+' -help >nul 2>nul')
    if output!=0:
        print 'Cannot open PaDEL-Descriptor, please check the path'
        return 0
    debug = '' if debug_mod else ' >nul'
    os.system('java -jar %s -descriptortypes padel-des.xml -file des.csv -dir padelinput -fingerprints -removesalt -standardizenitro -detectaromaticity%s' % (padelpath,debug))

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
    for f in fs:
        fs[f].write('Class\t'+'\t'.join(fptitles[f])+'\n')
        fs[f].write('d\t'*len(fptitles[f])+'d\n')
        fs[f].write('class'+'\t'*len(fptitles[f])+'\t\n')
    #add description
    with open(filename,'rb') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            for f in fs:
                fs[f].write(row['Name']+'\t'+'\t'.join([row[x] for x in fptitles[f]])+'\n')
    #close the file
    for f in fs:
        fs[f].close()

def main():
    datasets = get_prefixes()
    for dataset in datasets:
        prepareInputDir(dataset)
        shellPadel()
        splitFingerprint('des.csv',dataset)
        if not debug_mod:
            os.remove('des.csv')
    return datasets,fptitles.keys()
