puts "Starting to convert the data"


require 'json'
require 'time'

raw_data = JSON.parse(File.read('./raw_map_data.json'))

puts "Parsed raw data"

filtered_raw_data = raw_data.select do |line|
  next unless line.dig("MakerNotes", "TimeStamp") && line.dig("Composite","GPSLatitude") && line.dig("Composite","GPSLongitude")

  # Filter for Aotearoa
  latitude = line.dig("Composite","GPSLatitude")
  latitude < -30
end

puts "Filtered raw data"

sorted_raw_data = filtered_raw_data.sort_by do |line|
  time = Time.strptime(line.dig("MakerNotes", "TimeStamp"), '%Y:%m:%d %H:%M:%S.%L%z')
  time
end

puts "Sorted raw data"

coordinates = sorted_raw_data.map do |line|
  [line.dig("Composite","GPSLongitude"),line.dig("Composite","GPSLatitude")]
end

geojson = {
  type: "LineString",
  coordinates: coordinates
}

File.write('./geojson.json', JSON.dump(geojson))
