require 'gmail'
require 'mail'
require "google_drive"

#functiun that send an email
def send_email(townhall_name,email)
  gmail = Gmail.connect("","")
  gmail.deliver do
    to email
    subject "Formation gratuite de code sur 3 mois"
    body get_the_email_html(townhall_name)
  end
end

#function that iterates trough all the lines to send the pair townhall_name,email
def go_trought_the_lines
  session = GoogleDrive::Session.from_config("config.json")
  ws = session.spreadsheet_by_key("1uuBPSi4Rd_5Any7tgmnkZW3oAMLtLsu3rRTTh_jg3eY").worksheets[0]
  i = 1
    while i < ws.num_rows
      send_email(ws[i,1],ws[i,2])
      i += 1
    end
end

#function that embed the html body of the email
def get_the_email_html(townhall_name)
  content_type 'text/html; charset=UTF-8'
  return "<p>Bonjour,</p>
          <p>Je m'appelle Pierre, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau.</p>
          <p>La formation s'appelle The Hacking Project http://thehackingproject.org </p>
          <p>Nous apprenons l'informatique via la métthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquel nous planchons en petites équipes autonomes.</p>
          <p>Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite !!!</p>
          <p>Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à #{townhall_name}, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées. Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec #{townhall_name} !</p>
          <p>Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80</p>

          <p>Codialement,</p>

          <p>Pierre</p>"
end

#call the function to spam all Moselle (57) townhalls
go_trought_the_lines
