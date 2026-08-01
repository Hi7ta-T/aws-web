
CREATE TABLE user (
  user_id INT PRIMARY KEY NOT NULL,
  nickname VARCHAR(20) NOT NULL,
  password VARCHAR(60) NOT NULL,
  current_pref ENUM NOT NULL,
  current_city VARCHAR(20),
  age_group ENUM NOT NULL,
  gender ENUM NOT NULL
);
