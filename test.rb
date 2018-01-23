require "google_drive"

session = GoogleDrive::Session.from_config("config.json")

ws = session.spreadsheet_by_key("1oTjqSf4X3PfcjTBWFAgdeNRM5WyuhRES9ZeMTHjbhPY").worksheets[0]

ws[2, 1] = "foo"
ws[2, 2] = "bar"
ws.save
