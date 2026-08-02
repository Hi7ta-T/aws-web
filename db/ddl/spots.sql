
CREATE TABLE spots (
  spot_id INT PRIMARY KEY NOT NULL,
  spot_city VARCHAR(20) NOT NULL,
  station_name VARCHAR(20) NOT NULL,

  FOREIGN KEY (spot_pref_id)
  REFERENCES prefecture(pref_id)
);
