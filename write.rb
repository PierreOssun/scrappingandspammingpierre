require 'rubygems'
require 'json'
require "google_drive"
require 'pp'

#log in gmail & load the sheet
session = GoogleDrive::Session.from_config("config.json")
ws = session.spreadsheet_by_key("1uuBPSi4Rd_5Any7tgmnkZW3oAMLtLsu3rRTTh_jg3eY").worksheets[0]

#request the json that contain the list of hash of all mairies
json = File.read('mairiehash.json')
hash = JSON.parse(json)

#loop that write one line for each json hash
i = 0
while i < hash.length
  ws[i+1,1] = hash[i]["ville"]
  ws[i+1,2] = hash[i]["email"]
  ws.save
  i += 1
end
