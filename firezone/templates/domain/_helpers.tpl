{{- define "firezone.domain.fullname" -}}
{{- printf "%s-%s" (include "firezone.fullname" $) "domain" -}}
{{- end }}

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

{{/*
Create the name of the service account to use
*/}}
{{- define "firezone.domain.serviceAccountName" -}}
{{- if or (.Values.domain.serviceAccount.create) (.Values.global.erlangCluster.enableKubernetesClusterModule) }}
{{- default (include "firezone.fullname" .) .Values.domain.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.domain.serviceAccount.name }}
{{- end }}
{{- end }}
