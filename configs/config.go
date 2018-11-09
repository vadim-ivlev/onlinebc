package configs

import (
    "fmt"
    "gopkg.in/yaml.v2"
    "io/ioutil"
)


type conf struct {
    Port         string `yaml:"serving port"`
    MysqlConnStr string `yaml:"mysql connection string"`
    PstgrConnStr string `yaml:"postgres connection string"`
    RedisConnStr string `yaml:"redis connection string"`
}


// Conf Common config params
var Conf conf


// ReadConfigFile : reads config file
func (c *conf) ReadConfigFile(fileName string) *conf {
    yamlFile, err := ioutil.ReadFile(fileName)
    check(err)
    err = yaml.Unmarshal(yamlFile, c)
	check(err)
	c.printConfig()
    return c
}

func (c *conf) printConfig() {
    s,_:=yaml.Marshal(c)
    fmt.Printf("Params:\n%s",s)
}

func check(err error) {
    if err != nil {
        panic(err.Error())
    }
}
