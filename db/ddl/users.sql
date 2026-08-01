
CREATE TABLE users (
  user_id INT PRIMARY KEY NOT NULL,
  nickname VARCHAR(20) NOT NULL,
  password VARCHAR(60) NOT NULL,
  current_city VARCHAR(20),
  age_group ENUM(
   '10代', '20代', '30代', 
   '40代', '50代', '60代', 
   '70代~') NOT NULL
  gender ENUM(
   '男性', '女性','未回答') NOT NULL

  FOREIGN KEY (current_pref)
  REFERENCES prefecture(pref_id)
);
