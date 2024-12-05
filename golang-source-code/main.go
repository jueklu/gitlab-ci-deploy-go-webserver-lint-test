// Declare the main package / required for any standalone executable Go program
package main

import (
	"fmt"
	"os"
	"github.com/gin-gonic/contrib/static"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// Serve static files from the "./views" directory
	r.Use(static.Serve("/", static.LocalFile("./views", true)))

	// Start the server on the default port (8080)
	// Handle the error return value of r.Run()
	if err := r.Run(); err != nil {
		fmt.Printf("Server failed to start: %v\n", err)
		os.Exit(1) // Exit with an error code if the server fails
	}
}