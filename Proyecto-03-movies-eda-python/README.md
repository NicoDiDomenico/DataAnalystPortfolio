# Proyecto 03 — Análisis Exploratorio de Datos de Películas

Este proyecto realiza un **Análisis Exploratorio de Datos (EDA)** sobre un conjunto histórico de películas con el objetivo de identificar qué variables pueden influir en su éxito comercial, medido principalmente a través de la **recaudación bruta en taquilla** (`gross`).

El análisis fue desarrollado en Python utilizando un Jupyter Notebook y forma parte de un portfolio de análisis de datos.

## Objetivos

El proyecto busca responder principalmente a las siguientes preguntas:

- ¿Existe una relación entre el presupuesto de una película y su recaudación en taquilla?
- ¿Qué variables numéricas presentan mayor correlación con la recaudación?
- ¿Qué características tienen las películas con mayor éxito comercial?
- ¿La compañía productora puede estar asociada con una mayor recaudación?

## Hipótesis analizadas

1. Las películas con un presupuesto más elevado tienden a obtener una mayor recaudación.
2. Las películas producidas por compañías de mayor reconocimiento pueden alcanzar una mayor recaudación.

## Dataset

El archivo `movies.csv` contiene información sobre películas y sus principales características, entre ellas:

- Título y año de estreno.
- Clasificación y género.
- Director, guionista y actor principal.
- País de producción y compañía productora.
- Puntuación y cantidad de votos.
- Presupuesto (`budget`).
- Recaudación bruta (`gross`).
- Duración (`runtime`).

## Proceso de análisis

El notebook `CorrelacionPeliculasPython.ipynb` sigue las siguientes etapas:

1. **Carga e inspección inicial** del dataset.
2. **Auditoría de calidad**, identificando valores faltantes por columna.
3. **Limpieza y conversión de tipos de datos**, especialmente en las variables financieras.
4. **Transformación de datos**, incluyendo la extracción del año desde la fecha de estreno.
5. **Ordenamiento de películas** según su recaudación bruta.
6. **Visualización de relaciones** mediante gráficos de dispersión y líneas de regresión.
7. **Cálculo de correlaciones de Pearson** entre las variables numéricas.
8. **Interpretación de los resultados** para evaluar las hipótesis planteadas.

## Principales resultados

El análisis de correlación muestra una relación positiva entre el presupuesto y la recaudación bruta. En el dataset analizado, el coeficiente de correlación entre ambas variables es aproximadamente **0,74**, lo que indica una asociación lineal positiva considerable.

También se observa una relación positiva entre la cantidad de votos y la recaudación, con una correlación aproximada de **0,63**. Esto puede indicar que las películas con mayor alcance o popularidad tienden a acumular más votos y, al mismo tiempo, una mayor recaudación.

> Una correlación no implica necesariamente causalidad. Los resultados deben interpretarse junto con otros factores, como marketing, género, reparto, fecha de estreno y reconocimiento de la franquicia.

## Tecnologías utilizadas

- **Python**
- **Jupyter Notebook**
- **Pandas** — manipulación y análisis de datos.
- **NumPy** — operaciones numéricas y tratamiento de valores nulos.
- **Seaborn** — visualizaciones estadísticas.
- **Matplotlib** — generación y personalización de gráficos.

## Estructura del proyecto

```text
Proyecto-03-movies-eda-python/
├── CorrelacionPeliculasPython.ipynb
├── movies.csv
└── README.md
```

## Cómo ejecutar el proyecto

1. Clonar el repositorio:

   ```bash
   git clone https://github.com/NicoDiDomenico/DataAnalystPortfolio.git
   ```

2. Acceder a la carpeta del proyecto:

   ```bash
   cd DataAnalystPortfolio/Proyecto-03-movies-eda-python
   ```

3. Instalar las dependencias:

   ```bash
   pip install pandas numpy seaborn matplotlib jupyter
   ```

4. Abrir el notebook:

   ```bash
   jupyter notebook CorrelacionPeliculasPython.ipynb
   ```

5. Ejecutar las celdas en orden para reproducir el análisis.

## Nota sobre las rutas de archivos

Para ejecutar el notebook en otro equipo, es posible que sea necesario actualizar la ruta utilizada para cargar `movies.csv`. Se recomienda utilizar una ruta relativa, por ejemplo:

```python
import pandas as pd

df = pd.read_csv("movies.csv")
```

## Autor

**Nicolás Di Domenico**

Proyecto desarrollado como parte de un portfolio de análisis de datos.
