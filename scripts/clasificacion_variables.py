# clasificacion_variables.py — Parte A: clasificación de las variables de clientes.csv.
#
# El archivo data/clientes.csv tiene 12 clientes y 7 variables (más el id).
# El objetivo: clasificar cada variable (numérica continua/discreta, categórica
# binaria/ordinal/nominal) y verificar la clasificación en código.
#
# Regla del capítulo 3: el dtype es una pista, no la clasificación — el criterio
# (¿tiene sentido la mitad del valor? ¿hay orden entre las categorías?) decide.
#
# Uso (desde la raíz del repositorio):  python scripts/clasificacion_variables.py

import pandas as pd

clientes = pd.read_csv("data/clientes.csv")

# ---------------------------------------------------------------------------
# 1. Estructura del archivo
# ---------------------------------------------------------------------------
print(f"Dimensiones: {clientes.shape[0]} filas × {clientes.shape[1]} columnas")
print()
print("Primeras filas:")
print(clientes.to_string(index=False))
print()

# ---------------------------------------------------------------------------
# 2. Tipos inferidos (dtype) — la pista que da el lenguaje
# ---------------------------------------------------------------------------
print("Tipos inferidos (dtype):")
print(clientes.dtypes)
print()
# TODO 1: ¿qué columnas llegan como número y cuáles como texto? Anótalo para el
#         informe. Ojo con satisfaccion: llega como número y es ordinal
#         ("4 no es el doble de 2") — la justificación va en el informe.
#Columnas numéricas (int64): edad, numero_hijos, ingresos_mensuales y satisfaccion.
#
# Columnas de texto (str): cliente_id, genero, nivel_educacion y ciudad.
#
# Aunque satisfaccion aparece como int64, estadísticamente es una variable categórica ordinal, porque sus valores representan niveles ordenados del 1 al 5.
# ---------------------------------------------------------------------------
# 3. Valores únicos — ¿cuántas categorías hay y cuáles son?
# ---------------------------------------------------------------------------
# TODO 2:
for columna in clientes.columns:
    valores = clientes[columna].unique()

    print(f"Variable: {columna}")
    print(f"Cantidad de valores únicos: {len(valores)}")
    print(f"Valores: {valores}")
print()

# ---------------------------------------------------------------------------
# 4. Declarar el orden de las variables ordinales
# ---------------------------------------------------------------------------
# Una ordinal se guarda como texto (o como número) y su orden natural se pierde:
# alfabéticamente "Posgrado" iría antes que "Primaria", que no tiene sentido.
#
# TODO 3:
orden_educacion = [
    "Primaria",
    "Secundaria",
    "Universidad",
    "Posgrado"
]

clientes["nivel_educacion"] = clientes["nivel_educacion"].astype(
    pd.CategoricalDtype(
        categories=orden_educacion,
        ordered=True
    )
)

print("Nivel educativo mínimo:",
      clientes["nivel_educacion"].min())

print("Valores faltantes en nivel educativo:",
      clientes["nivel_educacion"].isna().sum())

# TODO 4:
orden_satisfaccion = [1, 2, 3, 4, 5]

clientes["satisfaccion"] = clientes["satisfaccion"].astype(
    pd.CategoricalDtype(
        categories=orden_satisfaccion,
        ordered=True
    )
)

print("Satisfacción mínima:",
      clientes["satisfaccion"].min())

print("Valores faltantes en satisfacción:",
      clientes["satisfaccion"].isna().sum())
# Prueba adicional: error en la categoría Posgrado

orden_incorrecto = [
    "Primaria",
    "Secundaria",
    "Universidad",
    "Postgrado"
]

educacion_error = clientes["nivel_educacion"].astype(
    pd.CategoricalDtype(
        categories=orden_incorrecto,
        ordered=True
    )
)

print("Valores faltantes con Postgrado:",
      educacion_error.isna().sum())
print()

# ---------------------------------------------------------------------------
# 5. Resumen de la clasificación (para el informe)
# ---------------------------------------------------------------------------
# TODO 5: 
clasificacion = {
    "cliente_id": "Identificador nominal",
    "edad": "Cuantitativa discreta (años cumplidos)",
    "numero_hijos": "Cuantitativa discreta",
    "genero": "Categórica nominal",
    "nivel_educacion": "Categórica ordinal",
    "ciudad": "Categórica nominal",
    "ingresos_mensuales": "Cuantitativa continua",
    "satisfaccion": "Categórica ordinal",
}
print("Resumen de la clasificación (para el informe):")
for variable, tipo in clasificacion.items():
    print(f"  {variable:20s} {tipo}")
