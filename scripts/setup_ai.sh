#!/bin/sh

echo "Run commands inside manually, vendor interface available for each"
exit

## Installing ollama (manager open models // model provider)
sudo apt-get install zstd
curl -fsSL https://ollama.ai/install.sh | sh

## Installing open code (interface for dev)
curl -fsSL https://opencode.ai/install | bash

## Installing claude code (anthropic cli agent)
curl -fsSL https://claude.ai/install.sh | bash

## Installing open claw (agent with skills)
curl -fsSL https://openclaw.ai/install.sh | bash
