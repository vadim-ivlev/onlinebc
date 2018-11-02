package cache

import (
	"errors"
)

// Get value by key.
// If key is absent returns an empty string and an error.
func Get(key string) (string, error) {
	return "", errors.New("Not implemented")
}

// Sets value by key.
func Set(key string, value string) error {
	return nil
}

// Deletes the key from the cache.
func Del(key string) error {
	return nil
}
