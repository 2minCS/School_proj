import smtplib, ssl
from email.mime.text import MIMEText


def is_connected(conn):
    try:
        status = conn.noop()[0]
    except:  # smtplib.SMTPServerDisconnected
        status = -1
    return True if status == 250 else False

  
def mail(key,e):
  key = ' '.join(str(k) for k in key)
  context = ssl.create_default_context()
  conn=smtplib.SMTP("live.smtp.mailtrap.io", 587)
  #a=is_connected(conn)
  sender = "ImgAuth <noreply@EmojiAuth.com>"
  receiver = e
  
  message = f"""\
  Your ImgAuth key is {key}. Please don't share this with anyone."""
  message = MIMEText(message)
  message['Subject'] = "ImgAuth Key"
  message['From'] = sender
  message['To'] = receiver
  conn.starttls(context=context)
  
  with conn as server:
      server.login("api", "b813086e469e894cf1f6eb571bb6ef89")
      server.sendmail(sender, receiver, message.as_string())

def mailtest(key, e):
  key = ' '.join(str(k) for k in key)
  context = ssl.create_default_context()
  conn=smtplib.SMTP("smtp.mailtrap.io", 587)
  #a=is_connected(conn)
  sender = "ImgAuth <noreply@EmojiAuth.com>"
  receiver = "A Test User <to@example.com>"
  
  message = f"""\
  Your ImgAuth key is {key}. Please don't share this with anyone."""
  message = MIMEText(message)
  message['Subject'] = "ImgAuth Key"
  message['From'] = sender
  message['To'] = receiver
  conn.starttls(context=context)
  
  with conn as server:
      server.login("ad4732c08d3f8d", "5c85451b65bd0a")
      server.sendmail(sender, receiver, message.as_string())

