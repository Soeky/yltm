package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	_ "github.com/lib/pq"
)

var db *sql.DB

func main() {
	// Datenbankverbindung
	var err error
	dsn := "host=" + os.Getenv("DB_HOST") +
		" user=" + os.Getenv("DB_USER") +
		" password=" + os.Getenv("DB_PASSWORD") +
		" dbname=" + os.Getenv("DB_NAME") +
		" sslmode=disable"
	db, err = sql.Open("postgres", dsn)
	if err != nil {
		log.Fatal(err)
	}

	// Routen
	http.HandleFunc("/tasks", handleTasks)
	http.HandleFunc("/events", handleEvents)
	http.HandleFunc("/users", handleUsers)

	log.Println("Server läuft auf Port :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

// Datenstrukturen
type Task struct {
	ID        int       `json:"id"`
	UserID    int       `json:"user_id"`
	Title     string    `json:"title"`
	DueDate   time.Time `json:"due_date"`
	Completed bool      `json:"completed"`
}

type Event struct {
	ID        int       `json:"id"`
	UserID    int       `json:"user_id"`
	Title     string    `json:"title"`
	StartTime time.Time `json:"start_time"`
	EndTime   time.Time `json:"end_time"`
}

type User struct {
	ID     int       `json:"id"`
	Name   string    `json:"name"`
	Wakeup time.Time `json:"wakeup"`
	Sleep  time.Time `json:"sleep"`
}

// Handlers für Tasks
func handleTasks(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		userID, err := strconv.Atoi(r.URL.Query().Get("user_id"))
		if err != nil {
			http.Error(w, "Invalid user ID", http.StatusBadRequest)
			return
		}
		rows, err := db.Query("SELECT id, user_id, title, due_date, completed FROM tasks WHERE user_id = $1", userID)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var tasks []Task
		for rows.Next() {
			var task Task
			if err := rows.Scan(&task.ID, &task.UserID, &task.Title, &task.DueDate, &task.Completed); err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			tasks = append(tasks, task)
		}
		json.NewEncoder(w).Encode(tasks)

	case "POST":
		var task Task
		if err := json.NewDecoder(r.Body).Decode(&task); err != nil {
			http.Error(w, "Invalid input", http.StatusBadRequest)
			return
		}

		err := db.QueryRow(
			"INSERT INTO tasks (user_id, title, due_date, completed) VALUES ($1, $2, $3, $4) RETURNING id",
			task.UserID, task.Title, task.DueDate, task.Completed).Scan(&task.ID)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		json.NewEncoder(w).Encode(task)
	}
}

// Handlers für Events
func handleEvents(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		userID, err := strconv.Atoi(r.URL.Query().Get("user_id"))
		if err != nil {
			http.Error(w, "Invalid user ID", http.StatusBadRequest)
			return
		}
		rows, err := db.Query("SELECT id, user_id, title, start_time, end_time FROM events WHERE user_id = $1", userID)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var events []Event
		for rows.Next() {
			var event Event
			if err := rows.Scan(&event.ID, &event.UserID, &event.Title, &event.StartTime, &event.EndTime); err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			events = append(events, event)
		}
		json.NewEncoder(w).Encode(events)

	case "POST":
		var event Event
		if err := json.NewDecoder(r.Body).Decode(&event); err != nil {
			http.Error(w, "Invalid input", http.StatusBadRequest)
			return
		}

		err := db.QueryRow(
			"INSERT INTO events (user_id, title, start_time, end_time) VALUES ($1, $2, $3, $4) RETURNING id",
			event.UserID, event.Title, event.StartTime, event.EndTime).Scan(&event.ID)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		json.NewEncoder(w).Encode(event)
	}
}

// Handlers für Users
func handleUsers(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		rows, err := db.Query("SELECT id, name, wakeup, sleep FROM users")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var users []User
		for rows.Next() {
			var user User
			if err := rows.Scan(&user.ID, &user.Name, &user.Wakeup, &user.Sleep); err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			users = append(users, user)
		}
		json.NewEncoder(w).Encode(users)

	case "POST":
		var user User
		if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
			http.Error(w, "Invalid input", http.StatusBadRequest)
			return
		}

		err := db.QueryRow(
			"INSERT INTO users (name, wakeup, sleep) VALUES ($1, $2, $3) RETURNING id",
			user.Name, user.Wakeup, user.Sleep).Scan(&user.ID)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		json.NewEncoder(w).Encode(user)
	}
}
