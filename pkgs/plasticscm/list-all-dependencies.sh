#!/usr/bin/env bash

apt-cache depends --with-source Packages.gz \
  --recurse \
  --no-recommends \
  --no-suggests \
  --no-conflicts \
  --no-breaks \
  --no-replaces \
  --no-enhances \
  --no-pre-depends \
  plasticscm-client-complete \
  | grep "^\w"
