# Proyecto 02 — Nashville Housing: SQL Server y Power BI

## Descripción

Este proyecto analiza el mercado inmobiliario del área metropolitana de Nashville a partir de un conjunto de datos históricos de transacciones de propiedades.

El objetivo principal es transformar una base de datos transaccional con problemas de calidad en un dataset limpio, estructurado y listo para realizar análisis en Power BI. Para ello, se utiliza **SQL Server** para la limpieza y transformación de los datos, y **Power BI** para la creación de un informe interactivo con indicadores y visualizaciones orientadas a la toma de decisiones.

El análisis está planteado desde la perspectiva de un director de operaciones e inversiones inmobiliarias que necesita identificar oportunidades de inversión y comprender el comportamiento del mercado.

## Preguntas de negocio

El proyecto busca responder, entre otras, las siguientes preguntas:

1. ¿Cómo evolucionó el volumen mensual de ventas en 2015 en comparación con 2014?
2. ¿Qué propiedad concentró la mayor cantidad de operaciones durante 2015?
3. ¿Cuál fue el uso de suelo más revendido en la ciudad de Nashville?
4. ¿Cuál fue la cantidad máxima de transacciones registradas para una misma propiedad?
5. ¿Qué ciudades concentran el mayor volumen de operaciones?
6. ¿Qué ciudades presentan los precios promedio de venta más elevados?
7. ¿Qué proporción de propiedades se transfirió desocupada frente a ocupada?
8. ¿Cuál es la diferencia de precio promedio entre las propiedades desocupadas y las ocupadas?

## Proceso de trabajo

### 1. Exploración y limpieza en SQL Server

El archivo [`DataCleaningSQL.sql`](./DataCleaningSQL.sql) contiene el proceso completo de preparación de los datos, incluyendo:

- Estandarización del formato de las fechas de venta.
- Compleción de valores faltantes en las direcciones de las propiedades.
- Separación de las direcciones de propiedad y de los propietarios en columnas individuales.
- Normalización de los valores del campo `SoldAsVacant`.
- Identificación y eliminación de registros duplicados.
- Eliminación de columnas consideradas innecesarias para el análisis.
- Creación de la vista `vw_NashvilleHousing_Clean`, utilizada como fuente para Power BI.

### 2. Análisis y visualización en Power BI

Una vez finalizada la limpieza, los datos se conectan a Power BI para construir un informe interactivo. El dashboard permite analizar:

- La evolución temporal de las ventas.
- La distribución de transacciones por ciudad.
- Los precios promedio por zona.
- Los usos de suelo con mayor cantidad de operaciones.
- La frecuencia de reventa de las propiedades.
- La relación entre el estado de ocupación y el precio de venta.

## Principales hallazgos

A partir del análisis realizado se obtuvieron los siguientes resultados principales:

- El ritmo mensual de ventas de 2015 fue estable y similar al de 2014. La caída del total anual de 2015 se explica principalmente por una operación atípica registrada en 2014, que elevó excepcionalmente el volumen de ese año.
- La propiedad ubicada en **1212 Laurel St** concentró el mayor volumen de operaciones, con 230 transacciones.
- En Nashville, el uso de suelo con mayor cantidad de reventas fue el correspondiente a viviendas unifamiliares, con aproximadamente el 57,99% de las operaciones.
- Nashville concentró la mayor cantidad de transacciones, seguida por Antioch y Hermitage.
- Nashville y Brentwood registraron algunos de los precios promedio más altos, mientras que Madison presentó valores promedio más accesibles.
- La mayoría de las propiedades se transfirió ocupada. Las propiedades desocupadas representaron aproximadamente el 8,28% de las transacciones analizadas.

## Herramientas utilizadas

- **SQL Server**: exploración, limpieza y transformación de datos.
- **T-SQL**: consultas, actualización de registros, eliminación de duplicados y creación de vistas.
- **Power BI**: modelado, análisis y visualización de los datos.
- **GitHub**: documentación y versionado del proyecto.

## Archivos del proyecto

- [`DataCleaningSQL.sql`](./DataCleaningSQL.sql): script de limpieza y transformación de datos en SQL Server.
- [`NashvilleHousing.pbix`](./NashvilleHousing.pbix): archivo de Power BI con el modelo y el informe interactivo.
- [`NashvilleHousingReport.pdf`](./NashvilleHousingReport.pdf): versión exportada del informe.
- [`datasets/`](./datasets/): carpeta destinada a los datasets utilizados en el proyecto.

## Resultado

El resultado final es un flujo de análisis completo que comienza con datos inmobiliarios sin depurar, continúa con un proceso reproducible de limpieza en SQL Server y termina con un dashboard en Power BI orientado a responder preguntas de negocio sobre demanda, precios, ubicación y comportamiento de las propiedades.
