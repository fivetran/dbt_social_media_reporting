{% macro duckdb__json_parse(string, string_path) %}

    json_extract_string(
        {{ string }},
        '$.{%- for s in string_path -%}{{ s }}{%- if not loop.last -%}.{%- endif -%}{%- endfor -%}'
    )

{% endmacro %}
