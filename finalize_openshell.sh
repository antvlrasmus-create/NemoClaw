#!/bin/bash
# Finalize OpenShell configuration for NemoClaw

# 1. Select Gateway
./openshell.elf gateway select nemoclaw

# 2. Create Provider
./openshell.elf provider create nvidia --credential nvidia_api_key=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

# 3. Set Inference
./openshell.elf inference set nvidia/nemotron-3-super-120b-a12b

echo "OpenShell configuration finalized!"
