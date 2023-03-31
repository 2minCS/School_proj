#https://pixabay.com/api/?key=32681396-4c078b204c14cddc83b5eb2cd&image_type=photo
#https://nolanlawson.com/2022/04/08/the-struggle-of-using-native-emoji-on-the-web/
#https://www.kirupa.com/html5/emoji.htm
import secrets
from emoji import emojis




def nEfile():
  area=[]
  l=[]
  key = []

  #random = secrets.SystemRandom()
  #' '.join(secrets.choice(words) for i in range(4))
  #for i in range(2):
  #  list.append([])
  #  for j in range(3): 
  #      list[i].append(j)
  for i in range(6):
    l.append([])
    for j in range(6):
      e=secrets.randbelow(973)
      if emojis[e] not in l[i]:
        # appending the random number to the resultant list, if the condition is true
        l[i].append(emojis[e])#set(random.choices(list(emojis), k=36))
      else:
        continue
    key = list(secrets.choice(emojis[e]) for emojis[e] in l)
    
  #print(l)
  #print(key)
  z=0
  y=0
  for i in range(6):
    area.append([])
    for j in l[i]:
      area[i].append(f'<div id="{y}" class="grid-item-{z}" onclick="auth(this.id)">{j}</div>')
      y+=1
    z+=1
  #print(area)
  return area, key
#nEfile()