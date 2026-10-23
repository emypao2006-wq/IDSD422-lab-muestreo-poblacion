# Informe — Clasificación de variables y población vs. muestra

**Para:** Gerencia de RetailAndina S.A. · **De:** Equipo de Business Intelligence
**Fecha:** 23/10/2026 **Asunto:** Base de fidelización: tipos de variables y estimación por muestreo

---

## Resumen ejecutivo

Se clasificaron las siete variables de la base de fidelización de RetailAndina S.A., además del identificador de cliente, para verificar su correcta interpretación estadística. También se estimó el ingreso mensual promedio de una población de 400 clientes mediante muestras de 20 registros, aplicando muestreo por conveniencia, aleatorio simple y estratificado. El promedio poblacional fue de USD 1330,72 y el muestreo aleatorio simple obtuvo la estimación más cercana en la ejecución de Python. Sin embargo, se identificó que la composición de las muestras es fundamental para evitar conclusiones basadas en una selección poco representativa.

## Parte A — Clasificación de las variables

Se analizó el archivo clientes.csv, compuesto por 12 clientes y 8 columnas. Se verificaron los tipos inferidos, los valores únicos y el orden de las variables ordinales utilizando Python y R.

| Variable | Tipo | Justificación (criterio) | Verificación en código |
|---|---|---|---|
| `cliente_id` | Identificador nominal | Identifica registros sin expresar cantidades ni orden. | `str`, 12 valores únicos. |
| `edad` | Cuantitativa discreta registrada | Está expresada en años cumplidos, aunque la edad exacta puede medirse continuamente. | `int64`, 12 valores únicos. |
| `numero_hijos` | Cuantitativa discreta | Es un conteo de hijos y no admite valores fraccionarios. | `int64`, 5 valores únicos. |
| `genero` | Categórica nominal | Sus categorías no tienen un orden natural. | `str`, 3 categorías. |
| `nivel_educacion` | Categórica ordinal | Presenta niveles educativos con un orden definido. | 4 categorías; mínimo Primaria. |
| `ciudad` | Categórica nominal | Las ciudades no tienen un orden estadístico. | `str`, 3 categorías. |
| `ingresos_mensuales` | Cuantitativa continua | Es una magnitud monetaria que puede expresarse con decimales. | `int64`, 12 valores únicos. |
| `satisfaccion` | Categórica ordinal | Representa niveles ordenados del 1 al 5, no cantidades proporcionales. | `int64` inicial, 4 valores observados; mínimo 2. |

**P1.** ¿Qué te dijo el dtype de `satisfaccion` y por qué no basta para clasificarla? ¿Qué pasa si una ordinal queda como texto sin declarar el orden?
Al revisar `dtypes`, observé que `satisfaccion` aparecía como `int64`. Sin embargo, la clasifiqué como categórica ordinal porque sus valores representan niveles ordenados y una satisfacción de 4 no significa el doble de una de 2. Si una variable ordinal queda como texto sin declarar su orden, las comparaciones pueden realizarse alfabéticamente en lugar de respetar su jerarquía. Al establecer el orden de `nivel_educacion`, comprobé que Primaria era la categoría mínima y que no existían valores faltantes. Además, al escribir incorrectamente `Postgrado`, se generaron 2 valores faltantes.

## Parte B — Población vs. muestra

### La población y su parámetro

| Concepto | Valor |
|---|---|
| Población (N) | 400 clientes |
| Variable de interés | `ingresos_mensuales` |
| Parámetro poblacional (media) | USD 1330,72 |

*¿Por qué se muestrea si aquí el parámetro existe y se calculó?*

En esta práctica se conocía el promedio poblacional porque los 400 registros estaban disponibles. Sin embargo, se aplicaron métodos de muestreo para comparar sus estimaciones con el valor real. En situaciones donde la población es demasiado grande o resulta costoso analizarla completamente, una muestra permite estimar sus características utilizando menos recursos.

### Los tres diseños

Resultados obtenidos en Python:

| Diseño | n | Media estimada | Composición por ciudad | Diferencia vs. parámetro |
|---|---:|---:|---|---:|
| Conveniencia (`head`) | 20 | USD 1348,50 | Quito: 20; Guayaquil: 0; Cuenca: 0 | +17,78 |
| Aleatorio simple (`sample`) | 20 | USD 1336,00 | Quito: 8; Guayaquil: 4; Cuenca: 8 | +5,28 |
| Estratificado (`groupby` + 5 %) | 20 | USD 1287,50 | Quito: 10; Guayaquil: 6; Cuenca: 4 | -43,22 |


### Medias de cinco sorteos aleatorios

| Semilla | 1 | 2 | 3 | 4 | 5 |
|---|---:|---:|---:|---:|---:|
| Media (USD) | 1336,00 | 1405,00 | 1235,00 | 1491,50 | 1288,00 |

**P2.** ¿Cuánto vale el parámetro poblacional y cuánto estimó cada diseño? ¿Cuál quedó más cerca y por qué eso **no** alcanza para declarar un ganador?

El parámetro poblacional fue de USD 1330,72. El muestreo por conveniencia estimó USD 1348,50; el aleatorio simple, USD 1336,00; y el estratificado, USD 1287,50. El aleatorio simple obtuvo la menor diferencia absoluta, con USD 5,28. Sin embargo, una sola ejecución no permite afirmar que siempre sea el mejor método, porque las estimaciones varían según los clientes seleccionados y deben evaluarse también las características de cada diseño.

**P3.** La muestra por conveniencia también tiene 20 filas. ¿Qué defecto tiene y cómo lo delatas en la composición por ciudad? ¿Se corrige tomando más filas?

La muestra por conveniencia incluyó únicamente 20 clientes de Quito, dejando fuera a Guayaquil y Cuenca, que representan conjuntamente el 50 % de la población. Esto evidenció una selección poco representativa geográficamente. Aunque la media estimada estuvo cerca del parámetro, aumentar el número de filas no garantiza corregir el problema, ya que la selección continúa dependiendo del orden de los registros.

**P4.** El sorteo aleatorio dio un número distinto en cada semilla. ¿Qué implica esa variabilidad para una empresa que va a decidir con un solo estudio?

Al utilizar cinco semillas diferentes, obtuve promedios entre USD 1235,00 y USD 1491,50. Esta variación demostró que las estimaciones dependen de los clientes seleccionados, incluso cuando todas las muestras contienen 20 registros. Por ello, la empresa debe considerar la incertidumbre muestral antes de tomar decisiones basadas en una sola estimación.

**P5.** ¿Cuándo usarías cada diseño en la práctica? Relaciona cada uno con un uso real (piloto, subgrupos que deben aparecer, conclusión sobre toda la población).

Utilizaría el muestreo por conveniencia para pruebas piloto o exploraciones iniciales, sin generalizar sus resultados a toda la población. Emplearía el muestreo aleatorio simple para estimar características generales mediante una selección probabilística. Finalmente, escogería el muestreo estratificado cuando fuera importante garantizar la representación proporcional de Quito, Guayaquil y Cuenca.

## Conclusiones

1. La clasificación de las variables permitió comprobar que el tipo de dato inferido por el lenguaje no siempre coincide con su naturaleza estadística. Esto se evidenció en `satisfaccion`, almacenada como número entero, pero clasificada como ordinal. Además, el error de escritura `Postgrado` produjo 2 valores faltantes.

2. El muestreo aleatorio simple presentó la estimación más cercana al promedio poblacional de USD 1330,72, con una diferencia de USD 5,28 en Python. Sin embargo, el estratificado garantizó la representación proporcional de las tres ciudades, mientras que el de conveniencia incluyó solamente clientes de Quito.

3. Recomendaría a la gerencia utilizar métodos probabilísticos y analizar la composición de las muestras antes de tomar decisiones. Los resultados corresponden a los 400 registros de esta base de fidelización y a los diseños evaluados, por lo que no garantizan las mismas estimaciones en otras poblaciones o sorteos.