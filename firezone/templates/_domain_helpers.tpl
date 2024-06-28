{{/*
Domain Common labels
*/}}
{{- define "firezone.domain.labels" -}}
helm.sh/chart: {{ include "firezone.chart" . }}
{{ include "firezone.domain.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Domain Selector labels
*/}}
{{- define "firezone.domain.selectorLabels" -}}
app.kubernetes.io/name: {{ include "firezone.name" . }}
app.kubernetes.io/component: domain
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
