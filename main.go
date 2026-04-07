package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	// Standard Prometheus metrics endpoint
	http.Handle("/metrics", promhttp.Handler())

	// Your static file server
	fs := http.FileServer(http.Dir("./static"))
	http.Handle("/", fs)

	port := ":8080"
	fmt.Printf("Server listening on http://localhost%s\n", port)
	err := http.ListenAndServe(port, nil)
	if err != nil {
		log.Fatal(err)
	}
}
