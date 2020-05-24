import os
import pprint
from datetime import datetime
from os import listdir, path 
from os.path import isfile, join

pp=pprint.pprint

base_dir = path.dirname(path.realpath(__file__))
data_dir = path.join(base_dir, 'data')

files = [f for f in listdir(data_dir) if isfile(join(data_dir, f))]

containers=list(set([f.split('_')[0] for f in files]))
containers.sort()

data={}
for f in files:
  with open(join(data_dir,f),'r') as r:
    lines=r.readlines()

    body, data_type=f.split('.')
    name=body.split('_')[0]

    for l in lines:
 
       l=l.strip('\n')
       if data_type=='cpu':

          date, time, value = l.split(' ')
          value=value.strip('%')
       elif data_type=='mem':

          date, time, value, _, value_max=l.split(' ')

          factor=1
          if value[-3]=='KiB':
             factor==0.001
          if value[-3]=='GiB':
             factor==1000

          value=value.strip('KiB').strip('MiB').strip('GiB')
          value*=factor 
          time=':'.join(time.split(':')[0:2]+['00'])
         
          date_time=date+'T'+time

       if not data.get(date_time):
          data[date_time]=dict([(c,{'mem':None, 'cpu':None}) for c in containers])

       data[date_time][name][data_type]=value

csv={'mem':[['datetime']+[c+' (MiB)' for c in containers]],
     'cpu':[['datetime']+[c+' (%)' for c in containers]]}

data=data.items()
data.sort(key=lambda x:x[0])


for date, val in data:

   cpu=[val[c]['cpu'] for c in containers]
   if not None in cpu:
      csv['cpu'].append([date]+cpu)

   mem=[val[c]['mem'] for c in containers]
   if not None in mem:
      csv['mem'].append([date]+mem)

csv['mem']='\n'.join([';'.join(r) for r in csv['mem']])
csv['cpu']='\n'.join([';'.join(r) for r in csv['cpu']])

export_dir=path.join(base_dir, 'exports')
if not os.path.exists(export_dir):
    os.makedirs(export_dir)

dateTimeObj = datetime.now()
timestamp = dateTimeObj.strftime("%Y%m%d-%H%M%S")

for data_type in ['mem','cpu']:

   with open(path.join(export_dir,'export-'+data_type+'-'+timestamp+'.csv'), 'w') as f:
      f.write(csv[data_type])

print(csv['mem'])
      


