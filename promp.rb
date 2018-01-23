def command_promp
  puts "Bienvenue dans le SpamScrapper ! Ce script permet de scrapper les emails et les nom de mairies d'un departement Francais.
  Dans quel fichier souhaitez vous stocker ces datas ?
  1 - Scrapper les emails et nom de mairies et les stocker dans un fichier json
  2 - Scrapper les emails et nom de mairies et les stocker dans un spreedsheep Google Drive"
  choice = gets.chomp
     if choice = 1
       puts "Êtes-vous sûr ? oui / non"
         user_input = gets.chomp
         if user_input == "oui"
           puts "ok let's go"
         elsif user_input == "non"
           puts "Vous avez 30 secondes pour reflechir"
         else
           puts "Veuillez choisir oui ou non"
         end
       elsif choice = 2
         puts "Êtes-vous sûr ? oui / non"
           user_input = gets.chomp
           if user_input == "oui"
             puts "ok let's go"
           elsif user_input == "non"
             puts "Vous avez 30 secondes pour reflechir"
           else
             puts "Veuillez choisir oui ou non"
           end
       else puts "Veuillez choisir 1 ou 2"
     end
end
command_promp
