package cmd

import (
	"fmt"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"
	"k8s.io/cli-runtime/pkg/genericclioptions"
	"k8s.io/klog"
)

var example = `
	%[1]s hello-world
`

func New(streams genericclioptions.IOStreams) *cobra.Command {
	o := &options{
		IOStreams:   streams,
		configFlags: genericclioptions.NewConfigFlags(),
	}
	cmd := &cobra.Command{
		Use:          "hello-world [flags]",
		Short:        "Say hello world",
		Example:      fmt.Sprintf(example, "kubectl"),
		SilenceUsage: true,
		RunE: func(c *cobra.Command, args []string) error {
			if err := o.Run(); err != nil {
				return errors.Wrapf(err, "error while running command")
			}
			return nil
		},
	}
	o.configFlags.AddFlags(cmd.Flags())
	return cmd
}

type options struct {
	genericclioptions.IOStreams
	configFlags *genericclioptions.ConfigFlags
}

func (o *options) Run() error {
	config, err := o.configFlags.ToRawKubeConfigLoader().RawConfig()
	if err != nil {
		return errors.Wrapf(err, "error while loading config")
	}
	klog.Infof("Hello World from %s", config.CurrentContext)
	return nil
}
