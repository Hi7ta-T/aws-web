
CREATE TABLE reviews (
  review_id INT PRIMARY KEY NOT NULL,
  rating DECIMAL(2,1) NOT NULL,
  daytime_safety DECIMAL(2,1) NOT NULL,
  night_safety DECIMAL(2,1) NOT NULL,
  convenience DECIMAL(2,1) NOT NULL,
  password VARCHAR(60) NOT NULL,
  created_at DATETIME NOT NULL,
  comment TEXT,
 
  FOREIGN KEY (user_id) 
  REFERENCES users(user_id),
  FOREIGN KEY (spot_id) 
  REFERENCES spots(spot_id)
);
