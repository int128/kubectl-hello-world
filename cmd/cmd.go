package cmd

import (
	"context"
	"github.com/spf13/pflag"

	"k8s.io/cli-runtime/pkg/genericclioptions"
	"k8s.io/klog"
)

const usage = `Help:

Usage: %s [options] [args...]

  A kubectl plugin just saying Hello World!

Options:
%s`

type Cmd struct{}

func (c *Cmd) Run(ctx context.Context, args []string) int {
	f := pflag.NewFlagSet(args[0], pflag.ContinueOnError)
	f.Usage = func() {
		klog.Infof(usage, args[0], f.FlagUsages())
	}

	var o cmdOptions
	o.ConfigFlags = genericclioptions.NewConfigFlags()
	o.ConfigFlags.AddFlags(f)

	if err := f.Parse(args[1:]); err != nil {
		if err == pflag.ErrHelp {
			return 1
		}
		klog.Errorf("Invalid arguments: %s", err)
		return 1
	}
	o.Args = f.Args()

	cfg, err := o.ConfigFlags.ToRawKubeConfigLoader().RawConfig()
	if err != nil {
		klog.Errorf("Could not load kubeconfig: %s", err)
		return 1
	}

	klog.Infof("Hello World from %s", cfg.CurrentContext)
	return 0
}

type cmdOptions struct {
	ConfigFlags *genericclioptions.ConfigFlags
	Args        []string
}
