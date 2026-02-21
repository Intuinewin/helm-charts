{{/*
Expand the name of the chart.
*/}}
{{- define "firezone.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "firezone.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "firezone.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "firezone.labels" -}}
helm.sh/chart: {{ include "firezone.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Database env secrets
*/}}
{{- define "firezone.database.auth" -}}
- name: DATABASE_USER
  valueFrom:
    secretKeyRef:
      name: {{ required "Missing `firezone.database.username.secret`" .Values.global.database.username.secret }}
      key: {{ required "Missing `firezone.database.username.key`" .Values.global.database.username.key }}
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ required "Missing `firezone.database.password.secret`" .Values.global.database.password.secret }}
      key: {{ required "Missing `firezone.database.password.key`" .Values.global.database.password.key }}
{{- end }}

{{/*
Common env
*/}}
{{- define "firezone.common" -}}
- name: ERL_EPMD_PORT
  value: {{ .Values.global.erlangCluster.epmdPort | quote }}
- name: ERLANG_DISTRIBUTION_PORT
  value: {{ quote .Values.global.erlangCluster.distributionPort }}
- name: FEATURE_IDP_SYNC_ENABLED
  value: {{ quote .Values.global.features.idpSync.enabled }}
- name: FEATURE_SIGN_UP_ENABLED
  value: {{ quote .Values.global.signup.enabled }}
- name: RUN_MANUAL_MIGRATIONS
  value: {{ quote .Values.global.runManualMigrations }}
{{- if gt (len .Values.global.signup.whitelistedDomains) 0 }}
- name: SIGN_UP_WHITELISTED_DOMAINS
  value: {{ join "," .Values.global.signup.whitelistedDomains }}
{{- end }}
- name: FEATURE_POLICY_CONDITIONS_ENABLED
  value: {{ quote .Values.global.features.policyConditions.enabled }}
- name: FEATURE_REST_API_ENABLED
  value: {{ quote .Values.global.features.restApi.enabled }}
- name: FEATURE_INTERNET_RESOURCE_ENABLED
  value: {{ quote .Values.global.features.internetResource.enabled }}
{{- end }}

{{/*
Common env secrets
*/}}
{{- define "firezone.secrets" -}}
- name: SECRET_KEY_BASE
  valueFrom:
    secretKeyRef:
      name: {{ required "Missing `firezone.phoenix.keyBase.secret`" .Values.global.phoenix.keyBase.secret }}
      key: {{ required "Missing `firezone.phoenix.keyBase.key`" .Values.global.phoenix.keyBase.key }}
- name: LIVE_VIEW_SIGNING_SALT
  valueFrom:
    secretKeyRef:
      name: {{ required "Missing `firezone.phoenix.liveViewSalt.secret`" .Values.global.phoenix.liveViewSalt.secret }}
      key: {{ required "Missing `firezone.phoenix.liveViewSalt.key`" .Values.global.phoenix.liveViewSalt.key }}
- name: COOKIE_SIGNING_SALT
  valueFrom:
    secretKeyRef:
      name: {{ required "Missing `firezone.phoenix.cookieSigningSalt.secret`" .Values.global.phoenix.cookieSigningSalt.secret }}
      key: {{ required "Missing `firezone.phoenix.cookieSigningSalt.key`" .Values.global.phoenix.cookieSigningSalt.key }}
- name: COOKIE_ENCRYPTION_SALT
  valueFrom:
    secretKeyRef:
      name: {{ required "Missing `firezone.phoenix.cookieEncryptionSalt.secret`" .Values.global.phoenix.cookieEncryptionSalt.secret }}
      key: {{ required "Missing `firezone.phoenix.cookieEncryptionSalt.key`" .Values.global.phoenix.cookieEncryptionSalt.key }}
- name: TOKENS_KEY_BASE
  valueFrom:
    secretKeyRef:
      name: {{ required "Missing `firezone.tokens.keyBase.secret`" .Values.global.tokens.keyBase.secret }}
      key: {{ required "Missing `firezone.tokens.keyBase.key`" .Values.global.tokens.keyBase.key }}
- name: TOKENS_SALT
  valueFrom:
    secretKeyRef:
      name: {{ required "Missing `firezone.tokens.salt.secret`" .Values.global.tokens.salt.secret }}
      key: {{ required "Missing `firezone.tokens.salt.key`" .Values.global.tokens.salt.key }}
- name: RELEASE_COOKIE
  valueFrom:
    secretKeyRef:
      name: {{ required "Missing `firezone.erlangCluster.cookie.secret`" .Values.global.erlangCluster.cookie.secret }}
      key: {{ required "Missing `firezone.erlangCluster.cookie.key`" .Values.global.erlangCluster.cookie.key }}
- name: OUTBOUND_EMAIL_ADAPTER_OPTS
  valueFrom:
    secretKeyRef:
      name: {{ required "Missing `firezone.email.opts.secret`" .Values.global.email.opts.secret }}
      key: {{ required "Missing `firezone.email.opts.key`" .Values.global.email.opts.key }}
{{- end }}
