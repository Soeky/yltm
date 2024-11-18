package routes

import (
	"context"
	"net/http"

	"backend/s3client"

	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/gin-gonic/gin"
)

func ListBucketFiles(c *gin.Context) {
	output, err := s3client.S3Client.ListObjectsV2(context.TODO(), &s3.ListObjectsV2Input{
		Bucket: &s3client.BucketName,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to list files"})
		return
	}

	files := []string{}
	for _, obj := range output.Contents {
		files = append(files, *obj.Key)
	}

	c.JSON(http.StatusOK, gin.H{"files": files})
}
