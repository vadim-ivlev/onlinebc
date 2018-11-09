package cache

import (
	"log"
	"errors"
	"github.com/mediocregopher/radix.v2/redis"
)

// Get value by key.
// If key is absent returns an empty string and an error.
func Get(key string) (string, error) {
	conn, err := redis.Dial("tcp", "localhost:6379")
    if err != nil {
        return "", err
	}
	defer conn.Close()

	str, err := conn.Cmd("HGET", "album:1", "title").Str()
    if err != nil {
        return "", err
    }
	return str, nil
}

// Sets value by key.
func Set(key string, value string) error {
	return nil
}

// Deletes the key from the cache.
func Del(key string) error {
	return nil
}
