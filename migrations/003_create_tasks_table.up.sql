CREATE TABLE tasks(
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  title VARCHAR(100)NOTNULL,
  due_date TIMESTAMP,
  completed BOOLEAN DEFAULT FALSE
);