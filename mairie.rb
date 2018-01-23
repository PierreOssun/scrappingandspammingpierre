require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'


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

#Write list_town to the json file
File.open("/home/sdx/Documents/googledrive/mairiehash.json","w") do |f|
  f.write(list_town.to_json)
end

#Write list_town to the CSV file
CSV.open("/home/sdx/Documents/googledrive/array.csv", "wb") do |csv|
  csv << list_town
end
