package main

import (
	"context"
	"os"

	"github.com/int128/kubectl-hello-world/cmd"
)

func main() {
	var c cmd.Cmd
	os.Exit(c.Run(context.Background(), os.Args))
}
