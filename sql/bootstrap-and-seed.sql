CREATE NAMESPACE IF NOT EXISTS fairtiq.app;
USE fairtiq.app;

DROP TABLE IF EXISTS journeys;

CREATE TABLE journeys (
  journey_id STRING,
  user_id STRING,
  price DECIMAL(10,2),
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  stations ARRAY<STRUCT<
    id: STRING,
    name: STRING,
    location: STRUCT<lat: DOUBLE, lon: DOUBLE>,
    crossed_at: TIMESTAMP
  >>
)
USING iceberg
TBLPROPERTIES (
  'format-version' = '2'
);

USE fairtiq.app;

INSERT INTO journeys VALUES
(
  'j1', 'u1', 3.20,
  TIMESTAMP '2026-04-01 08:10:00',
  TIMESTAMP '2026-04-01 08:42:00',
  array(
    named_struct('id', 's-001', 'name', 'Central', 'location', named_struct('lat', 47.3769, 'lon', 8.5417), 'crossed_at', TIMESTAMP '2026-04-01 08:10:00'),
    named_struct('id', 's-002', 'name', 'Museum',  'location', named_struct('lat', 47.3700, 'lon', 8.5380), 'crossed_at', TIMESTAMP '2026-04-01 08:22:00'),
    named_struct('id', 's-003', 'name', 'Airport', 'location', named_struct('lat', 47.4506, 'lon', 8.5610), 'crossed_at', TIMESTAMP '2026-04-01 08:42:00')
  )
),
(
  'j2', 'u2', 2.80,
  TIMESTAMP '2026-04-02 09:05:00',
  TIMESTAMP '2026-04-02 09:35:00',
  array(
    named_struct('id', 's-010', 'name', 'Harbor', 'location', named_struct('lat', 47.3665, 'lon', 8.5500), 'crossed_at', TIMESTAMP '2026-04-02 09:05:00'),
    named_struct('id', 's-011', 'name', 'OldTown', 'location', named_struct('lat', 47.3712, 'lon', 8.5450), 'crossed_at', TIMESTAMP '2026-04-02 09:20:00')
  )
),
(
  'j3', 'u1', 4.10,
  TIMESTAMP '2026-05-01 18:15:00',
  TIMESTAMP '2026-05-01 18:58:00',
  array(
    named_struct('id', 's-020', 'name', 'University', 'location', named_struct('lat', 47.3763, 'lon', 8.5481), 'crossed_at', TIMESTAMP '2026-05-01 18:15:00'),
    named_struct('id', 's-021', 'name', 'RiverSide',  'location', named_struct('lat', 47.3718, 'lon', 8.5360), 'crossed_at', TIMESTAMP '2026-05-01 18:34:00'),
    named_struct('id', 's-022', 'name', 'Stadium',    'location', named_struct('lat', 47.4110, 'lon', 8.5440), 'crossed_at', TIMESTAMP '2026-05-01 18:58:00'),
    named_struct('id', 's-023', 'name', 'Library',    'location', named_struct('lat', 47.3805, 'lon', 8.5500), 'crossed_at', TIMESTAMP '2026-05-01 19:10:00')
  )
),
(
  'j4', 'u3', 2.20,
  TIMESTAMP '2026-05-03 07:40:00',
  TIMESTAMP '2026-05-03 08:05:00',
  array()
);
