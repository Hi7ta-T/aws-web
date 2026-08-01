
CREATE TABLE spots (
  spot_id INT PRIMARY KEY NOT NULL,
  city VARCHAR(20) NOT NULL,
  station_name VARCHAR(20) NOT NULL,

  FOREIGN KEY (spot_pref)
  REFERENCES prefecture(pref_id)
);
