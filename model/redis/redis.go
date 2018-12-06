package redis

import (
	"log"
	"onlinebc/configs"

	"github.com/mediocregopher/radix.v2/redis"
)

// Get value by key.
// If key is absent returns an empty string and an error.
func Get(key string) (string, error) {
	conn, err := redis.Dial("tcp", configs.Conf.RedisConnStr)
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

// Sets value by key.
func Set(key string, value string) error {
	conn, err := redis.Dial("tcp", configs.Conf.RedisConnStr)
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

// Deletes the key from the redis.
func Del(key string) error {
	return nil
}
