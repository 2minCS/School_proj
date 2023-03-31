# -*- coding: utf-8 -*-

from flask import render_template, Flask, request, abort
from auth import oauth
from mail import mail
from img import nEfile
from db import dbcomp

 
# Flask constructor takes the name of
# current module (__name__) as argument.
app = Flask(__name__)
a=[]
key=[]
area = []
r=False
@app.route('/', methods=['GET'])
def index():
    global key
    global area
    if len(key) < 6:
      area, key=nEfile()
      #mail(key)
    #print(key)
    return render_template('index.html', area=area)
  
  
@app.route('/<jsdata>', methods=['POST'])
def jsdata(jsdata):
   a.append(request.get_data().decode(encoding='UTF-8'))
   #print(a)
   return a
  
@app.route('/login', methods=['POST'])
def login():
  global r
  u = request.form.get('user')
  p = request.form.get('pass')
  r = dbcomp(u,p)
  print(u,p)
  print(r)
  if r == True:
    return 'True'
  else:
    return render_template('404.html'), 404
   
@app.route('/auth_method', methods=['POST'])
def auth_method():
  e = request.form['email']
  p = request.form['phone']
  #print(e)
  if e:
    mail(key,e)
    return 'True'
    
  #elif p:
    #text(key,p)
  else:
    return render_template('404.html')

@app.route('/profile', methods=['GET'])
def auth():
  if len(a)==6 and len(key)==6:
      b = oauth(a,key)
      #print(b)
      if b == True and r == True:
        return render_template('profile.html')
      else:
        return render_template('404.html')
  else:
        return render_template('404.html')
    
@app.errorhandler(404)
def page_not_found(error):
   return render_template('404.html', title = '404'), 404
# main driver function
if __name__ == '__main__':
    
    app.run(host='0.0.0.0',port='8080')

