package routes

import (
	"bytes"
	"context"
	"net/http"

	"backend/s3client"

	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/gin-gonic/gin"
)

func UploadToS3(c *gin.Context) {
	var data struct {
		Key  string `json:"key"`
		Data string `json:"data"`
	}

	// JSON-Daten binden
	if err := c.ShouldBindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Daten in S3 hochladen
	_, err := s3client.S3Client.PutObject(context.TODO(), &s3.PutObjectInput{
		Bucket: &s3client.BucketName,
		Key:    &data.Key,
		Body:   bytes.NewReader([]byte(data.Data)),
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to upload data to S3"})
		return
	}

	// Erfolgsantwort
	c.JSON(http.StatusOK, gin.H{"message": "Data uploaded successfully"})
}
