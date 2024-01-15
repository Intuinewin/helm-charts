#!/bin/sh

cat <<EOF
include: '.gitlab/templates.yml'

stages:
  - linting
  - build
  - deploy

EOF

for f in $(find * -maxdepth 0 -type d)
do
  CHART_VERSION=$(grep "^version:" $f/Chart.yaml | cut -d' ' -f2-)
  CHART_RELEASE="$f-$CHART_VERSION"
  cat <<EOF
'$f:jsonlint':
  stage: linting
  image: registry.gitlab.com/pipeline-components/jsonlint:latest
  script:
    - |
      find "${f}" -not -path './.git/*' -name '*.json' -type f -print0 |
      parallel --will-cite -k -0 -n1 jsonlint -q

'$f:yamllint':
  stage: linting
  image: registry.gitlab.com/pipeline-components/yamllint:latest
  script:
    - yamllint --strict "$f/Chart.yaml" "$f/values.yaml"

'$f:lint':
  stage: linting
  extends: .helm-lint
  variables:
    HELM_CHART_PATH: "${f}"

'${f}:package':
  stage: build
  extends: .helm-package
  variables:
    HELM_CHART_PATH: "$f"
    HELM_CHART_VERSION: "$CHART_VERSION"
  rules:
    - if: \$CI_COMMIT_TAG =~ "/^$f-.*$/"
      changes:
        - $f/**/*

'$f:publish':
  stage: deploy
  extends: .helm-publish
  needs:
    - $f:package
  variables:
    HELM_CHART_PATH: "$f"
    HELM_CHART_VERSION: "$CHART_VERSION"
  rules:
    - if: \$CI_COMMIT_TAG =~ "/^$f-.*$/"
      changes:
        - $f/**/*
EOF
done
