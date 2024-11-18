package s3client

import (
	"context"
	"log"
	"os"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

var S3Client *s3.Client
var BucketName string

func InitS3Client() {
	// Lade Bucket-Namen aus Umgebungsvariablen
	BucketName = os.Getenv("S3_BUCKET_NAME")
	if BucketName == "" {
		log.Fatalf("S3_BUCKET_NAME not set in .env")
	}

	// AWS-Region aus Umgebungsvariablen
	awsRegion := os.Getenv("AWS_REGION")
	if awsRegion == "" {
		log.Fatalf("AWS_REGION not set in .env")
	}

	// Lade die AWS-Konfiguration
	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion(awsRegion),
	)
	if err != nil {
		log.Fatalf("Unable to load AWS config, %v", err)
	}

	// Erstelle den S3-Client
	S3Client = s3.NewFromConfig(cfg)
	log.Println("S3 client initialized successfully")
}
