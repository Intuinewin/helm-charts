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
app.kubernetes.io/name: {{ include "firezone.name" . }}
app.kubernetes.io/component: web
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
