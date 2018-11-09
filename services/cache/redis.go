package cache

import (
	"github.com/mediocregopher/radix.v2/redis"
	"onlinebc/configs"
)

// Get value by key.
// If key is absent returns an empty string and an error.
func Get(key string) (string, error) {
	conn, err := redis.Dial("tcp", configs.Conf.RedisConnStr)
    if err != nil {
        return "", err
	}
	defer conn.Close()

	str, err := conn.Cmd("GET", "onlinebc:"+key, "title").Str()
    if err != nil {
        return "", err
	}
	
	return str, nil
}

// Sets value by key.
func Set(key string, value string) error {
	conn, err := redis.Dial("tcp", configs.Conf.RedisConnStr)
    if err != nil {
        return err
	}
	defer conn.Close()

	resp := conn.Cmd("SET", "onlinebc:"+key, value)
     if resp.Err != nil {
        return resp.Err
	}
	
	return nil
}

// Deletes the key from the cache.
func Del(key string) error {
	return nil
}
