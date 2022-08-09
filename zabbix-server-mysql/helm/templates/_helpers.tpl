{{- define "chart.env" }}
env:
    {{- range $key, $val := .Values.env }}
    - name: {{ $key }}
      value: {{ $val | quote }}
    {{- end }}
{{- end }}

