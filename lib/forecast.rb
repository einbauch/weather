# encoding: utf-8

class Forecast
  WEEKDAYS = {
    '1' => 'воскресенье',
    '2' => 'понедельник',
    '3' => 'вторник',
    '4' => 'среда',
    '5' => 'четверг',
    '6' => 'пятница',
    '7' => 'суббота'
  }
  
  TIME_OF_DAY = {
    '0' => 'ночь',
    '1' => 'утро',
    '2' => 'день',
    '3' => 'вечер'
  }
  
  CLOUDINESS = {
    '0' => 'ясно',
    '1' => 'малооблачно',
    '2' => 'облачно',
    '3' => 'пасмурно'
  }
  
  PRECIPITATION = {
    '4' => 'дождь',
    '5' => 'ливень',
    '6' => 'снег',
    '7' => 'снег',
    '8' => 'гроза',
    '9' => 'нет данных',
    '10' => 'без осадков'
  }
  
  WIND_DIRECTION = {
    '0' => 'С',
    '1' => 'С-В',
    '2' => 'В',
    '3' => 'Ю-В',
    '4' => 'Ю',
    '5' => 'Ю-З',
    '6' => 'З',
    '7' => 'С-З'
  }
  
  def initialize(day, month, year, tod, weekday, town)
    @date = "#{day}-#{month}-#{year}"
    @tod = TIME_OF_DAY[tod]
    @weekday = WEEKDAYS[weekday]
    @town = town
  end
  
  def update_phenomena(cloudiness, precipitation, rpower, spower)
    @cloudiness = CLOUDINESS[cloudiness]    
    @precipitation = PRECIPITATION[precipitation]
    
    if %w(4 5 6 7).include? precipitation && rpower == '0'
      @precipitation.insert(0, 'возможен ')
    end
    
    if precipitation == '8' && spower == '0'
      @precipitation.insert(0, 'возможна ')
    end
  end
  
  def update_pressure(min, max)
    @min_pressure = min
    @max_pressure = max
  end
  
  def update_wind(min, max, direction)
    @min_wind = min
    @max_wind = max
    @wind_direction = WIND_DIRECTION[direction]
  end
  
  def update_temp(min, max)
    @min_temp = min
    @max_temp = max
  end
  
  def update_humidity(min, max)
    @min_humidity = min
    @max_humidity = max
  end
  
  def print_forecast
    puts "Прогноз погоды: #{@town} на #{@tod} #{@date}, #{@weekday}:"
    puts "Температура от #{@min_temp} до #{@max_temp} град. Цельсия"
    puts "Облачность: #{@cloudiness}, осадки: #{@precipitation}"
    puts "Ветер #{@wind_direction} от #{@min_wind} до #{@max_wind} м/с"
    puts "Атмосферное давление от #{@min_pressure} до #{@max_pressure} мм.рт.ст"
    puts "Относительная влажность воздуха от #{@min_humidity} до #{@max_humidity} %"
  end

end