#!/usr/bin/env bash
set -o errexit

pnpm i --frozen-lockfile --dir assets

mix deps.get --only prod
MIX_ENV=prod mix compile

NODE_ENV=production pnpm run --dir assets build

MIX_ENV=prod mix phx.gen.release
MIX_ENV=prod mix release --overwrite
