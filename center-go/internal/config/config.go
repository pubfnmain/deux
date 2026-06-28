package config

import (
	"fmt"
	"os"

	"github.com/goccy/go-yaml"
)

const DefaultPath = "configs/config.yaml"

type postgres struct {
	URL      string `json:"url"`
	Hostname string `json:"hostname"`
	Port     uint64 `json:"port"`
	Username string `json:"username"`
	Password string `json:"password"`
	Database string `json:"database"`
}

func (p *postgres) Conn() string {
	return fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", p.Hostname, p.Port, p.Username, p.Password, p.Database)
}

type Config struct {
	TigerBeetle struct {
		ClusterID uint64 `json:"cluster_id"`
		Address   uint64 `json:"address"`
	} `json:"tigerbeetle"`

	Valkey struct {
		URL string `json:"url"`
	}

	Postgres postgres
}

func New(path string) (*Config, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	var config Config
	if err := yaml.NewDecoder(f).Decode(&config); err != nil {
		return nil, err
	}
	return &config, nil
}
