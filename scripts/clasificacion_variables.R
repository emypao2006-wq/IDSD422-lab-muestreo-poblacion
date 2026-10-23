# clasificacion_variables.R — Parte A: clasificación de las variables de clientes.csv.
#
# El archivo data/clientes.csv tiene 12 clientes y 7 variables (más el id).
# El objetivo: clasificar cada variable (numérica continua/discreta, categórica
# binaria/ordinal/nominal) y verificar la clasificación en código.
#
# Regla del capítulo 3: el tipo que infiere el lenguaje es una pista, no la
# clasificación — el criterio (¿tiene sentido la mitad del valor? ¿hay orden
# entre las categorías?) decide.
#
# Uso (desde la raíz del repositorio):  Rscript scripts/clasificacion_variables.R

clientes <- read.csv("data/clientes.csv", stringsAsFactors = FALSE)

# ---------------------------------------------------------------------------
# 1. Estructura del archivo
# ---------------------------------------------------------------------------
cat(sprintf("Dimensiones: %d filas × %d columnas\n", nrow(clientes), ncol(clientes)))
print(clientes)

# ---------------------------------------------------------------------------
# 2. Tipos inferidos (str) — la pista que da el lenguaje
# ---------------------------------------------------------------------------
str(clientes)
# TODO 1: ¿qué columnas llegan como número (int) y cuáles como texto
#         (character)? Anótalo para el informe. Ojo con satisfaccion: llega
#         como número y es ordinal ("4 no es el doble de 2") — la justificación
#         va en el informe.
# Columnas numericas (int):edad, numero_hijos, ingresos_mensuales y satisfaccion.
#
# Columnas de texto (character): cliente_id, genero, nivel_educacion y ciudad.
#
# Aunque satisfaccion aparece como entero, es una variable categorica ordinal porque sus valores representan niveles

# ---------------------------------------------------------------------------
# 3. Valores únicos — ¿cuántas categorías hay y cuáles son?
# ---------------------------------------------------------------------------
# TODO 2: 
for (columna in names(clientes)) {
  valores <- unique(clientes[[columna]])

  cat("\nVariable:", columna, "\n")
  cat("Cantidad de valores unicos:", length(valores), "\n")
  cat("Valores:", paste(valores, collapse = ", "), "\n")
}
# ---------------------------------------------------------------------------
# 4. Declarar el orden de las variables ordinales
# ---------------------------------------------------------------------------
# Una ordinal se guarda como texto y su orden natural se pierde: alfabéticamente
# "Posgrado" iría antes que "Primaria", que no tiene sentido. En R, eso se
# declara con el factor ordenado.
#
# TODO 3: 
orden_educacion <- c(
  "Primaria",
  "Secundaria",
  "Universidad",
  "Posgrado"
)

clientes$nivel_educacion <- factor(
  clientes$nivel_educacion,
  levels = orden_educacion,
  ordered = TRUE
)

cat("\nNivel educativo minimo:",
    as.character(min(clientes$nivel_educacion)), "\n")

cat("Valores faltantes en nivel educativo:",
    sum(is.na(clientes$nivel_educacion)), "\n")

# TODO 4:

orden_satisfaccion <- c(1, 2, 3, 4, 5)

clientes$satisfaccion <- factor(
  clientes$satisfaccion,
  levels = orden_satisfaccion,
  ordered = TRUE
)

cat("\nSatisfaccion minima:",
    as.character(min(clientes$satisfaccion)), "\n")

cat("Valores faltantes en satisfaccion:",
    sum(is.na(clientes$satisfaccion)), "\n")


# Prueba adicional: escribir Postgrado en vez de Posgrado

orden_incorrecto <- c(
  "Primaria",
  "Secundaria",
  "Universidad",
  "Postgrado"
)

educacion_error <- factor(
  as.character(clientes$nivel_educacion),
  levels = orden_incorrecto,
  ordered = TRUE
)

cat("Valores faltantes con Postgrado:",
    sum(is.na(educacion_error)), "\n")
# ---------------------------------------------------------------------------
# 5. Resumen de la clasificación (para el informe)
# ---------------------------------------------------------------------------
# TODO 5:
clasificacion <- c(
  cliente_id         = "Identificador nominal",
  edad               = "Cuantitativa discreta (años cumplidos)",
  numero_hijos       = "Cuantitativa discreta",
  genero             = "Categorica nominal",
  nivel_educacion    = "Categorica ordinal",
  ciudad             = "Categorica nominal",
  ingresos_mensuales = "Cuantitativa continua",
  satisfaccion       = "Categorica ordinal"
)
cat("\nResumen de la clasificación (para el informe):\n")
for (variable in names(clasificacion)) {
  cat(sprintf("  %-18s %s\n", variable, clasificacion[[variable]]))
}
