{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "galaxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "galaxy.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "galaxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Expand the name of the chart.
*/}}
{{- define "galaxy-postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.postgresql.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Add a trailing slash to a given path, if missing
*/}}
{{- define "galaxy.add_trailing_slash" -}}
{{- if hasSuffix "/" . -}}
{{- printf "%s" . -}}
{{- else -}}
{{- printf "%s/" . -}}
{{- end -}}
{{- end -}}

{{/*
Decide whether to create a new secret or use an existing secret.
It creates a new secret if the value is the expected default, and assumes it's an
existing secret in all other cases.
*/}}
{{- define "galaxy.createGalaxyDbSecret" -}}
{{- range $key, $entry := .Values.extraEnv -}}
{{- if eq $entry.name "GALAXY_DB_USER_PASSWORD" -}}
    {{- if eq $entry.valueFrom.secretKeyRef.name "{{ .Release.Name }}-galaxy-db-password" -}}
        {{- true -}}
    {{- else -}}
    {{- end -}}
{{- else -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return galaxy database user password
*/}}
{{- define "galaxy.galaxyDbPassword" -}}
{{- if .Values.postgresql.galaxyDatabasePassword }}
    {{- .Values.postgresql.galaxyDatabasePassword -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Return galaxy database connection string
*/}}
{{- define "galaxy.galaxyDbConnectionString" -}}
postgresql://{{ .Values.postgresql.galaxyDatabaseUser }}:$(GALAXY_DB_USER_PASSWORD)@{{ template "galaxy-postgresql.fullname" . }}/galaxy
{{- end -}}
