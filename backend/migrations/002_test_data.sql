-- Insertar conductores de prueba
INSERT INTO users (name, email, phone, role) 
VALUES 
  ('Carlos Rodríguez', 'carlos@motocar.pe', '987001001', 'driver'),
  ('Miguel Ángel', 'miguel@motocar.pe', '987001002', 'driver'),
  ('José López', 'jose@motocar.pe', '987001003', 'driver'),
  ('Ana García', 'ana@motocar.pe', '987001004', 'driver'),
  ('Luis Torres', 'luis@motocar.pe', '987001005', 'driver')
ON CONFLICT (phone) DO NOTHING;

-- Obtener IDs e insertar datos relacionados
DO $$
DECLARE
  user_id_1 uuid;
  user_id_2 uuid;
  user_id_3 uuid;
  user_id_4 uuid;
  user_id_5 uuid;
  driver_id_1 uuid;
  driver_id_2 uuid;
  driver_id_3 uuid;
  driver_id_4 uuid;
  driver_id_5 uuid;
BEGIN
  -- Obtener IDs de usuarios
  SELECT id INTO user_id_1 FROM users WHERE phone = '987001001';
  SELECT id INTO user_id_2 FROM users WHERE phone = '987001002';
  SELECT id INTO user_id_3 FROM users WHERE phone = '987001003';
  SELECT id INTO user_id_4 FROM users WHERE phone = '987001004';
  SELECT id INTO user_id_5 FROM users WHERE phone = '987001005';

  -- Insertar conductores
  INSERT INTO drivers (user_id, status, rating, total_trips)
  VALUES 
    (user_id_1, 'available', 4.8, 156),
    (user_id_2, 'available', 4.9, 203),
    (user_id_3, 'available', 4.7, 98),
    (user_id_4, 'available', 5.0, 45),
    (user_id_5, 'available', 4.6, 178)
  ON CONFLICT DO NOTHING;

  -- Obtener IDs de conductores
  SELECT id INTO driver_id_1 FROM drivers WHERE user_id = user_id_1;
  SELECT id INTO driver_id_2 FROM drivers WHERE user_id = user_id_2;
  SELECT id INTO driver_id_3 FROM drivers WHERE user_id = user_id_3;
  SELECT id INTO driver_id_4 FROM drivers WHERE user_id = user_id_4;
  SELECT id INTO driver_id_5 FROM drivers WHERE user_id = user_id_5;

  -- Insertar vehículos
  INSERT INTO vehicles (driver_id, make, model, plate, year, color)
  VALUES 
    (driver_id_1, 'Bajaj', 'RE', 'ABC-123', 2023, 'Amarillo'),
    (driver_id_2, 'Bajaj', 'Maxima', 'DEF-456', 2022, 'Rojo'),
    (driver_id_3, 'Bajaj', 'RE Compact', 'GHI-789', 2023, 'Verde'),
    (driver_id_4, 'Bajaj', 'RE', 'JKL-012', 2021, 'Azul'),
    (driver_id_5, 'Bajaj', 'Maxima', 'MNO-345', 2023, 'Naranja')
  ON CONFLICT (plate) DO NOTHING;

  -- Insertar ubicaciones en diferentes puntos de Lima
  INSERT INTO locations (driver_id, geom, speed, heading)
  VALUES 
    (driver_id_1, ST_SetSRID(ST_MakePoint(-77.0428, -12.0464), 4326), 0, 90),
    (driver_id_2, ST_SetSRID(ST_MakePoint(-77.0364, -12.0975), 4326), 15, 180),
    (driver_id_3, ST_SetSRID(ST_MakePoint(-77.0211, -12.1461), 4326), 0, 270),
    (driver_id_4, ST_SetSRID(ST_MakePoint(-76.9897, -12.1408), 4326), 20, 45),
    (driver_id_5, ST_SetSRID(ST_MakePoint(-76.9408, -12.0797), 4326), 10, 135);

  RAISE NOTICE 'Datos de prueba insertados: 5 conductores con vehículos y ubicaciones';
END $$;

