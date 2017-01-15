def convert_from_celsium(degree, unit)
  from_celsium = {'C' => degree, 'F' => (degree * 1.8) + 32, 'K' => (degree + 273.15)}
  from_celsium[unit]
end

def convert_from_fahrenheit(degree, unit)
  from_fahrenheit = {'F' => degree, 'C' => (degree - 32) / 1.8, 'K' => (degree + 459.67) / 1.8}
  from_fahrenheit[unit]
end

def convert_from_kalvin(degree, unit)
  from_kalvin = {'K' => degree, 'C' => (degree - 273.15), 'F' => (degree * 1.8) - 459.67}
  from_kalvin[unit]
end

def convert_between_temperature_units(degree, current_unit, convert_unit)
  if current_unit == 'C'
    convert_from_celsium(degree, convert_unit)
  elsif current_unit == 'F'
    convert_from_fahrenheit(degree, convert_unit)
  elsif current_unit == 'K'
    convert_from_kalvin(degree, convert_unit)
  end
end

MELTING_POINT = { 'water' => 0, 'ethanol' => -114, 'gold' => 1064, 'silver' => 961.8, 'copper' => 1085 }

def melting_point_of_substance(substance, unit)
  convert_between_temperature_units(MELTING_POINT[substance], 'C', unit)
end

BOILING_POINT = { 'water' => 100, 'ethanol' => 78.37, 'gold' => 2700, 'silver' => 2162, 'copper' => 2567 }

def boiling_point_of_substance(substance, unit)
  convert_between_temperature_units(BOILING_POINT[substance], 'C', unit)
end
