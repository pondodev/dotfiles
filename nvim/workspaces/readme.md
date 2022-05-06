# how 2 workspace

the entire idea of workspaces here is that you'll call `Workspace(...)` and pass through an environment that you wish
to open. the main (and currently only) thing this environment does is set a makefile for your environment so that you
may run `:Make` with project specific targets. the name of the environments are defined by the name of the `*.mk` files
in this directory, so for example if you ran `:call Workspace(foo)` then it would load `foo.mk` as your current
makefile.

