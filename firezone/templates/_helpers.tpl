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
Web Common labels
*/}}
{{- define "firezone.web.labels" -}}
helm.sh/chart: {{ include "firezone.chart" . }}
{{ include "firezone.web.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Web Selector labels
*/}}
{{- define "firezone.web.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "%s-%s" (include "firezone.fullname" $) "web" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Api Common labels
*/}}
{{- define "firezone.api.labels" -}}
helm.sh/chart: {{ include "firezone.chart" . }}
{{ include "firezone.api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Api Selector labels
*/}}
{{- define "firezone.api.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "%s-%s" (include "firezone.fullname" $) "api" }}
app.kubernetes.io/instance: {{ .Release.Name }}
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
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "firezone.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "firezone.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
