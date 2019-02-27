package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var example = `
	%[1]s hello
`

func New() *cobra.Command {
	cmd := &cobra.Command{
		Use:          "hello [flags]",
		Short:        "Say hello world",
		Example:      fmt.Sprintf(example, "kubectl"),
		SilenceUsage: true,
		RunE: func(c *cobra.Command, args []string) error {
			return nil
		},
	}
	return cmd
}
