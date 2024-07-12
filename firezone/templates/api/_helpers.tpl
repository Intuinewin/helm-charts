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
app.kubernetes.io/name: {{ include "firezone.name" . }}
app.kubernetes.io/component: api
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
