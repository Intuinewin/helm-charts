{{/*
Migrations Common labels
*/}}
{{- define "firezone.migrations.labels" -}}
helm.sh/chart: {{ include "firezone.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
