# Proyecto 01: Análisis de COVID-19 con SQL Server y Tableau

## Descripción

Este proyecto analiza la evolución de la pandemia de COVID-19 a partir de datos de casos, muertes, población y vacunación por país y región.

El objetivo es transformar datos públicos en información útil para responder preguntas de negocio y validar distintas hipótesis sobre el impacto global del virus. Para ello, se utiliza **SQL Server** para la exploración, limpieza y preparación de los datos, y **Tableau** para crear un dashboard interactivo.

## Preguntas analizadas

El análisis busca responder principalmente a las siguientes preguntas:

1. ¿Cuál fue la tasa de letalidad global del COVID-19?
2. ¿Qué países y continentes concentraron la mayor cantidad de muertes?
3. ¿Qué porcentaje de la población llegó a infectarse en cada país?
4. ¿La evolución de los contagios fue uniforme en todo el mundo?
5. ¿Cómo evolucionó la vacunación en relación con la población total?

## Herramientas utilizadas

- **SQL Server / T-SQL:** exploración, transformación y análisis de datos.
- **Tableau:** visualización de indicadores, mapas y series temporales.
- **CTE, funciones de ventana y tablas temporales:** cálculo de personas vacunadas acumuladas por país y fecha.
- **Vistas SQL:** preparación de conjuntos de datos para su posterior visualización.

## Contenido del proyecto

- [`data-exploration-covid19.sql`](./data-exploration-covid19.sql): consultas SQL utilizadas para explorar los datos, calcular indicadores y preparar las visualizaciones.
- [`CovidDashboard_17899345726940.twbx`](./CovidDashboard_17899345726940.twbx): libro de trabajo de Tableau.
- [`Link Tableau Public.txt`](./Link%20Tableau%20Public.txt): enlace al dashboard publicado en Tableau Public.
- [`datasets/`](./datasets/): directorio destinado a los conjuntos de datos utilizados en el proyecto.

## Indicadores y visualizaciones

El dashboard incluye, entre otros elementos:

- Casos totales a nivel global.
- Muertes totales y tasa de letalidad.
- Distribución de muertes por región o continente.
- Porcentaje de población infectada por país.
- Evolución temporal de la proporción de población infectada.
- Comparación entre población total y vacunación acumulada.

## Principales conclusiones

A partir del análisis realizado, el proyecto permite observar que:

- La tasa de letalidad global representa una proporción mucho menor que la percepción inicial de que una gran parte de las personas contagiadas fallecía.
- La cantidad absoluta de muertes no se distribuye de manera uniforme entre continentes y regiones.
- El porcentaje de población infectada presenta diferencias importantes entre países.
- La evolución de los contagios varió significativamente según el país y el período analizado; el impacto de la pandemia no fue uniforme a nivel global.

> Las conclusiones corresponden al período cubierto por el conjunto de datos utilizado en el proyecto y no deben interpretarse como una medición actual de la pandemia.

## Dashboard

El dashboard está disponible en Tableau Public:

[Ver dashboard de COVID-19 en Tableau Public](https://public.tableau.com/app/profile/nicol.s.di.domenico/viz/CovidDashboard_17899345726940/Dashboard1?publish=yes)

## Objetivo del proyecto

Este proyecto forma parte de un portfolio de análisis de datos y demuestra el uso combinado de SQL Server y Tableau para:

- Explorar grandes volúmenes de información.
- Crear métricas y cálculos analíticos.
- Validar hipótesis mediante datos.
- Comunicar resultados a través de visualizaciones interactivas.
