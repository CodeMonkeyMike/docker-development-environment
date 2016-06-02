# docker-development-environment
Build development environment with docker

This was a proof of concept to build my whole development environment in one single VM. After I had finished this script I found that it was not that great for a development environment.

Issues:
 * Against Docker philosophy - More then one tool per container
 * Slow to build - Mostly because there are many tools being built in one container
 * Fails easily - Mostly because composer
 * Interfering tools - FZF is used by multiple tools among other things
