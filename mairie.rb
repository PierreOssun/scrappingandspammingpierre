require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'json'
require "google_drive"
require 'pp'


#methode qui retorune l'email de contact sur la page d'un commune
def get_the_email_of_a_townhal_from_its_webpage(lien)
  doc = Nokogiri::HTML(open("#{lien}"))
  email = doc.css('html body tr[4] td.style27 p.Style22 font')[1]
    return email.text[1..-1]
end

#methode qui renvoie une array des urls de chaque mairie
def get_all_the_urls_of_val_doise_townhalls()
  urls_town = []
  doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/moselle.html"))
  doc.css('a.lientxt').each do |x|
      lien_page_mairie = x['href']
      lien_page_mairie.slice!(0)
      lien_page_mairie = "http://annuaire-des-mairies.com" + lien_page_mairie
      urls_town.push(lien_page_mairie)
    end
  return urls_town
end

#methode qui retourne une array avec la liste des noms de communes
def towns_names()
  town_names = []
    doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/moselle.html"))
    doc.css('a.lientxt').each do |x|
    names = x.text
    names.downcase!
    town_names.push(names)
  end
  return town_names
end

#Hash qui retourne :nom de la ville et :son email
def create_hash
list_town = []
  i = 0
  urls_town = get_all_the_urls_of_val_doise_townhalls()
  town_names = towns_names()
    while i < town_names.length
      hash = Hash.new
      hash[:ville] = town_names[i]
      hash[:email] = get_the_email_of_a_townhal_from_its_webpage(urls_town[i])
      list_town.push(hash)
      i += 1
    end
    return list_town
end

#Methode qui va transformer le hash en .json
def hash_to_json
  list_town = create_hash()
  puts "Comment souhaitez vous nommer votre Json ? exemple: scrapinfile (sans l'extention)"
      file_name = gets.chomp
      file_name_js = file_name + ".json"
  puts "Ou souhaitez vous l'enregistrer ? exemple:/home/sdx/Documents/googledrive "
      path = gets.chomp
      json_file = File.new("#{file_name_js}","w") #creer un fichier .json
      current_path = File.expand_path(File.dirname(__FILE__)) #retourne le current path du nouveau json cree
      File.rename(current_path, path) #move le .json de son emplacement initial, a l'emplacement desire par l'utilisateur
      filenp = path + "/" + file_name_js
      File.open(filenp,"w") do |f| #creer le .json a l'aide du hash des villes/email
        f.write(list_town.to_json)
     end
     puts "Veuillez trouver votre fichier enregistre sous #{filenp}"
end

#Methode qui va ecrire le hash sur une sheet en ligne
def hash_to_sheet
  puts "Avant toute chose :
  - veuillez placer votre fichier config.json dans le meme dossier que ce script
  - Veuillez vous log-in sur votre Google-API (https://console.developers.google.com/apis/credentials)"
  puts "Pouvons nous continuer ? oui/non"
  autorisation = gets.chomp
    if autorisation == "oui"
      puts "Veuillez rentrer la cle de votre googlesheet : (exemple :1uuBPSi4Rd_5Any7tgmnkZW3oAMLtLsu3rRTTh_jg3e)"
      sheet_key = gets.chomp
      session = GoogleDrive::Session.from_config("config.json") #log in sur le Drive API
      ws = session.spreadsheet_by_key(sheet_key).worksheets[0] #selectionne la sheet renseigne par l'utilisateur
      puts "creation du hash en cours..."
      urls_town = get_all_the_urls_of_val_doise_townhalls()
      town_names = towns_names()
      i = 0
      while i < town_names.length #boucle pour creer le sheet
        ws[i+1,1] = town_names[i]
        ws[i+1,2] = get_the_email_of_a_townhal_from_its_webpage(urls_town[i])
        ws.save
        i += 1
      end
      puts "Sheet actualise ! verifier sur https://docs.google.com/spreadsheets/d/" + sheet_key + "/edit#gid=0"
    elsif autorisation == "non"
      puts "Dommage !"
      sleep(10)
      hash_to_sheet()
    else
      puts "Veuillez choisir oui ou non"
      hash_to_sheet()
  end
end

#Les commandes
def command_promp
  puts "Bienvenue dans le SpamScrapper ! Ce script permet de scrapper les emails et les nom de mairies du departement de la Moselle (57) !.
  Dans quel fichier souhaitez vous stocker ces datas ?
  1 - Scrapper les emails et nom de mairies et les stocker dans un fichier json
  2 - Scrapper les emails et nom de mairies et les stocker dans un spreedsheep Google Drive"
  choice = gets.chomp
     if choice == "1"
       puts "Êtes-vous sûr ? oui / non"
         user_input = gets.chomp
         if user_input == "oui"
           puts "Patientez pentdant la creation du hash..."
           hash_to_json()
         elsif user_input == "non"
           puts "Vous avez 10 secondes pour reflechir"
           sleep(10)
           command_promp
         else
           puts "Veuillez choisir oui ou non"
           command_promp()
         end
       elsif choice == "2"
         puts "Êtes-vous sûr ? oui / non"
           user_input = gets.chomp
           if user_input == "oui"
             hash_to_sheet()
           elsif user_input == "non"
             puts "Vous avez 10 secondes pour reflechir"
             sleep(10)
             command_promp
           else
             puts "Veuillez choisir oui ou non"
             command_promp
           end
       else puts "Veuillez choisir 1 ou 2"
         command_promp()
     end
end
command_promp
