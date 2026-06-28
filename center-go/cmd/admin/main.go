package main

import (
	"fmt"
	"log/slog"
	"os"
	"strconv"

	"github.com/pubfnmain/deux/center-go/internal/config"
	tigerbeetle "github.com/tigerbeetle/tigerbeetle-go"
)

func run() error {
	cfgPath := os.Getenv("CONFIG_PATH")
	if cfgPath == "" {
		cfgPath = config.DefaultPath
	}
	cfg, err := config.New(cfgPath)
	if err != nil {
		return err
	}
	client, err := tigerbeetle.NewClient(tigerbeetle.ToUint128(cfg.TigerBeetle.ClusterID), []string{strconv.FormatUint(cfg.TigerBeetle.Address, 10)})
	if err != nil {
		return err
	}
	defer client.Close()
	accounts, err := client.QueryAccounts(tigerbeetle.QueryFilter{Ledger: 1, Code: 718, Limit: 10})
	if err != nil {
		return err
	}
	fmt.Printf("accounts: %+v", accounts)
	//accountResults, err := client.CreateAccounts([]tigerbeetle.Account{
	//	{
	//		ID:     tigerbeetle.ID(),
	//		Ledger: 1,
	//		Code:   718,
	//	},
	//})
	//if err != nil {
	//	return err
	//}
	//slog.Info("created accounts", "accounts", accountResults)
	return nil
}

func main() {
	if err := run(); err != nil {
		slog.Error("failed to run", "err", err)
	}
}
