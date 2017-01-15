HASH_TO_CELSIUM = {
  'F' => -> (temperature) { (temperature - 32) * (5.0 / 9) },
  'K' => -> (temperature) { temperature - 273.15 },
  'C' => -> (t) { t }
}

HASH_FROM_CELSIUM = {
  'F' => -> (temperature) { temperature * (9.0 / 5) + 32 },
  'K' => -> (temperature) { temperature + 273.15 },
  'C' => -> (t) { t }
}

def convert_between_temperature_units(temperature, from_units, to_units)
  temperature = HASH_TO_CELSIUM[from_units].call(temperature)
  temperature = HASH_FROM_CELSIUM[to_units].call(temperature)
  temperature.round(7)
end

SUBSTANCES = {
  'water'   => {melting_point: 0,     boiling_point: 100  },
  'ethanol' => {melting_point: -114,  boiling_point: 78.37},
  'gold'    => {melting_point: 1_064, boiling_point: 2_700},
  'silver'  => {melting_point: 961.8, boiling_point: 2_162},
  'copper'  => {melting_point: 1_085, boiling_point: 2_567}
}

def melting_point_of_substance(substance, units)
  HASH_FROM_CELSIUM[units].call(SUBSTANCES[substance][:melting_point])
end

def boiling_point_of_substance(substance, units)
  HASH_FROM_CELSIUM[units].call(SUBSTANCES[substance][:boiling_point])
end
