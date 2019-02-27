package main

import (
	"os"

	"github.com/int128/hello-kubectl-plugin/cmd"
	"github.com/spf13/pflag"
)

func main() {
	flags := pflag.NewFlagSet("kubectl-hello", pflag.ExitOnError)
	pflag.CommandLine = flags

	root := cmd.New()
	if err := root.Execute(); err != nil {
		os.Exit(1)
	}
}
