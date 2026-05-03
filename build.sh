#!/usr/bin/env bash
set -o errexit

pnpm i --frozen-lockfile --prod --dir assets

mix deps.get --only prod
MIX_ENV=prod mix compile

MIX_ENV=prod mix assets.build
MIX_ENV=prod mix assets.deploy

MIX_ENV=prod mix phx.gen.release
MIX_ENV=prod mix release --overwrite
