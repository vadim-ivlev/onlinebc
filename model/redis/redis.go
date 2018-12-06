package redis

import (
	"log"

	"github.com/mediocregopher/radix.v2/redis"
)

// Get returns value by key.
// If key is absent returns an empty string and an error.
func Get(key string) (string, error) {
	conn, err := redis.Dial("tcp", params.ConnectStr)
	if err != nil {
		log.Print("Get No connection")
		return "", err
	}
	defer conn.Close()

	str, err := conn.Cmd("GET", "onlinebc:"+key).Str()
	if err != nil {
		return "", err
	}

	return str, nil
}

// Set sets value by key.
// TODO: use TTL
func Set(key string, value string) error {
	conn, err := redis.Dial("tcp", params.ConnectStr)
	if err != nil {
		log.Print("Set No connection")
		return err
	}
	defer conn.Close()

	resp := conn.Cmd("SET", "onlinebc:"+key, value)
	if resp.Err != nil {
		return resp.Err
	}

	return nil
}

// Del deletes the key from the redis.
func Del(key string) error {
	return nil
}
