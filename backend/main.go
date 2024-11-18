package main

import (
	"backend/routes"
	"backend/s3client"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"log"
	"os"
)

func main() {
	// Lade .env-Datei
	err := godotenv.Load()
	if err != nil {
		log.Println("Error loading .env file (make sure it's present in your project)")
	}

	// S3-Client initialisieren
	s3client.InitS3Client()

	// Lade Server-Port aus Umgebungsvariablen
	port := os.Getenv("SERVER_PORT")
	if port == "" {
		port = "8080" // Standard-Port
	}

	// Gin-Server starten
	r := gin.Default()
	r.POST("/upload", routes.UploadToS3)
	r.GET("/list-files", routes.ListBucketFiles)

	log.Printf("Server running on port %s", port)
	r.Run(":" + port)
}
