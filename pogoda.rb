# encoding: utf-8

require_relative 'lib/win_cp_fix'
require_relative 'lib/forecast'
require 'net/http'
require 'uri'
require 'rexml/document'

# http://xml.meteoservice.ru/export/gismeteo/point/37.xml (Moscow)

towns = {
  11 => 'Челябинск',
  21 => 'Хабаровск',
  37 => 'Москва',
  55 => 'Одесса',
  59 => 'Пермь',
  69 => 'Санкт-Петербург',
  99 => 'Новосибирск',
  115 => 'Орел',
  121 => 'Чита',
  141 => 'Братск',
  199 => 'Краснодар',
  202 => 'Якутск',
  1869 => 'Рио-де-Жанейро' #чтобы было не так грустно после Читы и Братска :)
}

town_keys = towns.keys

puts 'Здравствуйте! Представляем вашему внимание наш прогноз погоды, точный как варашиловский стрелок!'
puts
puts 'Введите номер интересующего вас города:'

towns.each do |key, town|
  puts "#{key}. #{town}"
end

town_index = nil

until town_keys.include? town_index do
  town_index = STDIN.gets.to_i
  break if town_keys.include? town_index
  puts 'Вы ввели неверное число, попробуйте еще раз!'
end

uri = URI.parse("http://xml.meteoservice.ru/export/gismeteo/point/#{town_index}.xml")

response = Net::HTTP.get_response(uri)

doc = REXML::Document.new(response.body)

forecasts = Array.new

town_name = towns[town_index]

doc.elements.each('//FORECAST') do |forecast|
  
  day = forecast.attributes['day']
  month = forecast.attributes['month']
  year = forecast.attributes['year']
  tod = forecast.attributes['tod']
  weekday = forecast.attributes['weekday']
  
  item = Forecast.new(day, month, year, tod, weekday, town_name)
  
  phenomena = forecast.elements['PHENOMENA']
  
  cloudiness = phenomena.attributes['cloudiness']
  precipitation = phenomena.attributes['precipitation']
  rpower = phenomena.attributes['rpower']
  spower = phenomena.attributes['spower']
  
  item.update_phenomena(cloudiness, precipitation, rpower, spower)
  
  pressure = forecast.elements['PRESSURE']
  
  max_pressure = pressure.attributes['max']
  min_pressure = pressure.attributes['min']
  
  item.update_pressure(min_pressure, max_pressure)
  
  temperature = forecast.elements['TEMPERATURE']
  
  max_temp = temperature.attributes['max']
  min_temp = temperature.attributes['min']
  
  item.update_temp(min_temp, max_temp)
  
  wind = forecast.elements['WIND']
  
  min_wind = wind.attributes['min']
  max_wind = wind.attributes['max']
  wind_direction = wind.attributes['direction']
  
  item.update_wind(min_wind, max_wind, wind_direction)
  
  wet = forecast.elements['RELWET']
  
  min_wet = wet.attributes['min']
  max_wet = wet.attributes['max']
  
  item.update_humidity(min_wet, max_wet)
  
  forecasts << item

end

puts

forecasts.each do |forecast|
  puts '----------------------------------'
  puts
  forecast.print_forecast
  puts
end
