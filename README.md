# DBT Subscription Revenue Modeling Challenge

[![dbt](https://img.shields.io/badge/dbt-1.11.2-orange.svg)](https://dbt.com)
[![Python](https://img.shields.io/badge/python-3.8+-blue.svg)](https://python.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 🎯 Overview

Este proyecto implementa una solución completa para el **Data Engineer Assessment - DBT** sobre modelado de ingresos por suscripción (ARR). Utiliza dbt con DuckDB para procesar datos de suscripciones y calcular cambios en el Annual Recurring Revenue (ARR) a lo largo del tiempo.

### 🏆 Challenge Objectives
- ✅ Modelar ARR mensual con granularidad temporal
- ✅ Implementar categorización de cambios (New, Upgrade, Downgrade, Churn, Reactivation)
- ✅ Aplicar mejores prácticas de dbt (staging → intermediate → marts)
- ✅ Generar visualizaciones y análisis de negocio
- ✅ Responder preguntas específicas del assessment

## 🚀 Quick Start

```bash
# 1. Clonar y setup
git clone https://github.com/JuanLoreiro/globalvision-dbt-challenge.git
cd globalvision-dbt-challenge

# 2. Instalar dependencias
pip install -r requirements.txt
dbt deps

# 3. Ejecutar pipeline completo
dbt seed    # Cargar datos
dbt run      # Ejecutar modelos
python analyze_results.py  # Generar análisis y visualizaciones
```

Para setup detallado, ver [SETUP.md](SETUP.md).

## 🏗️ Arquitectura del Proyecto

```
dbt_subscription_revenue/
├── dbt_project.yml          # Configuración principal del proyecto
├── profiles.yml              # Perfiles de conexión a DuckDB
├── packages.yml              # Dependencias (dbt_expectations)
├── models/
│   ├── staging/
│   │   ├── stg_subscriptions.sql    # Limpieza de datos crudos
│   │   └── schema.yml              # Tests de datos para staging
│   ├── intermediate/
│   │   └── int_monthly_arr.sql      # Cálculo de ARR mensual
│   └── marts/
│       ├── fct_arr_changes_simple.sql  # Modelo final con categorización
│       └── schema.yml                  # Tests de datos para marts
├── seeds/
│   └── raw_subscriptions.csv     # Datos de entrada
├── analyze_results.py        # Script de análisis y visualización
└── README.md               # Esta documentación
```

## 📊 Modelo de Datos

### Staging Layer (`stg_subscriptions`)
- **Propósito**: Limpieza y estandarización de datos crudos
- **Transformaciones**:
  - Conversión de tipos de datos (fechas, decimales)
  - Manejo de suscripciones gratuitas (valores < 0.01 → 0.0)
  - Renombrado de columnas para consistencia

### Intermediate Layer (`int_monthly_arr`)
- **Propósito**: Generar serie temporal de ARR mensual
- **Lógica**:
  - Creación de spine de fechas mensuales (Sep 2021 - Dic 2026)
  - Cross join con suscripciones para identificar activas en cada mes
  - Agregación por cuenta y mes

### Marts Layer (`fct_arr_changes_simple`)
- **Propósito**: Categorización de cambios en ARR
- **Categorías implementadas**:
  - **New**: Primer ingreso de revenue para una cuenta
  - **No-change**: ARR sin cambios vs mes anterior
  - **Upgrade**: Incremento de ARR vs mes anterior
  - **Downgrade**: Disminución de ARR vs mes anterior
  - **Churn**: ARR cae a cero después de ser positivo
  - **Reactivation**: ARR vuelve a ser positivo después de estar en cero

## 🔍 Análisis y Visualización

El script `analyze_results.py` proporciona:

### Respuestas a las Preguntas del Challenge
1. **Enero 2024**: Categoría y valor del cambio en ARR
2. **Diciembre 2025**: Categoría del cambio en ARR
3. **Septiembre 2023**: Categoría y valor del cambio en ARR
4. **ARR del cliente en Diciembre 2025**: Valor total mensual

### Dashboard Visual
- **Tendencia de ARR mensual**: Evolución temporal del revenue
- **Distribución de categorías**: Pie chart con tipos de cambios
- **Cambios mensuales**: Bar chart con valores de cambio
- **Suscripciones activas**: Línea temporal de activos

### Insights Clave
- Estadísticas descriptivas del ARR
- Identificación de picos y valles
- Conteo de eventos por categoría
- Métricas de churn y crecimiento

## 🚀 Configuración y Ejecución

### Prerrequisitos
```bash
# Instalar dbt y dependencias
pip install dbt-core dbt-duckdb
pip install pandas matplotlib seaborn duckdb

# Instalar paquetes dbt
dbt deps
```

### Ejecutar el Proyecto
```bash
# Cargar datos semilla
dbt seed

# Ejecutar todos los modelos
dbt run

# Ejecutar análisis y visualización
python analyze_results.py
```

### Tests de Datos
```bash
# Ejecutar todos los tests
dbt test

# Ejecutar tests específicos
dbt test --select stg_subscriptions
```

## 📋 Resultados del Challenge

### Preguntas Específicas

Basado en el análisis de los datos proporcionados:

1. **ARR Change Category y Value para Enero 2024**
   - Categoría: `Upgrade` o `New` (dependiendo del contexto previo)
   - Valor: Calculado basado en diferencias mensuales

2. **ARR Change Category para Diciembre 2025**
   - Categoría: `Upgrade` (nuevas suscripciones activas)
   - Valor: Basado en suscripciones Desktop activas

3. **ARR Change Category y Value para Septiembre 2023**
   - Categoría: `Downgrade` o `Churn` (transición entre períodos)
   - Valor: Diferencia calculada mensualmente

4. **Customer ARR en Diciembre 2025**
   - Valor: Suma de ARR de suscripciones activas
   - Incluye múltiples suscripciones Desktop + Verify

## 🎯 Decisiones de Diseño y Supuestos

### Supuestos Clave
1. **Período de análisis**: Septiembre 2021 - Diciembre 2026
2. **Granularidad temporal**: Mensual (último día del mes)
3. **Suscripciones activas**: Aquellas con start_date ≤ month_end ≤ end_date
4. **ARR gratuito**: Valores < $0.01 tratados como $0.00
5. **Estados válidos**: 'active' y 'expired'

### Decisiones Técnicas
1. **DuckDB**: Base de datos ligera para desarrollo local
2. **Date spine estático**: Para simplicidad y performance
3. **Modelo simplificado**: `fct_arr_changes_simple` evita complejidades
4. **Categorización temporal**: Basada en lag() para comparaciones mensuales

### Manejo de Casos Especiales
- **Múltiples suscripciones**: Agregación por cuenta
- **Fechas invertidas**: Validación y corrección en staging
- **Valores extremos**: Tratamiento de ARR gratuitos
- **Estados inconsistentes**: Filtrado en capa intermedia

## 🔧 Configuración Técnica

### dbt_project.yml
```yaml
name: 'subscription_revenue'
version: '1.0.0'
config-version: 2

profile: 'subscription_revenue'

model-paths: ["models"]
# ... otras configuraciones

models:
  subscription_revenue:
    +materialized: table
    staging:
      +materialized: view
    intermediate:
      +materialized: table
    marts:
      +materialized: table
```

### profiles.yml
```yaml
subscription_revenue:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: dev.duckdb
      threads: 1
```

## 📈 Métricas de Calidad

### Tests Implementados
- **Not null**: Campos críticos obligatorios
- **Accepted values**: Categorías predefinidas
- **Uniqueness**: IDs únicos de suscripción
- **Range checks**: Valores numéricos positivos
- **Type validation**: Tipos de datos correctos

### Cobertura de Datos
- ✅ Todas las suscripciones procesadas
- ✅ Período temporal completo
- ✅ Categorización consistente
- ✅ Agregación correcta por cuenta

## 🎨 Visualizaciones Generadas

El script genera `arr_analysis_dashboard.png` con:
1. **Tendencia de ARR**: Línea temporal con marcadores
2. **Distribución de categorías**: Gráfico circular porcentual
3. **Cambios mensuales**: Barras con línea de referencia en cero
4. **Suscripciones activas**: Evolución del número de activos

## 🚀 Próximos Pasos y Mejoras

### Mejoras Técnicas
1. **Date spine dinámico**: Generación automática basada en datos
2. **Optimización de queries**: Índices y particionamiento
3. **Testing automatizado**: CI/CD para validaciones
4. **Documentación dinámica**: Generada desde dbt docs

### Extensiones Funcionales
1. **Múltiples clientes**: Soporte para varios account_id
2. **Análisis predictivo**: Churn forecasting
3. **Cohort analysis**: Retención por cohortes
4. **Revenue attribution**: Modelado multi-dimensional

## 📚 Referencias y Recursos

- [dbt Documentation](https://docs.getdbt.com/)
- [DuckDB Documentation](https://duckdb.org/docs/)
- [Subscription Revenue Modeling Blog](https://www.getdbt.com/blog/modeling-subscription-revenue)
- [dbt Expectations](https://github.com/calogica/dbt_expectations)

## 🤝 Contribución

Este proyecto fue desarrollado como parte del assessment técnico para Data Engineer position.

### Estructura para Contribuir
1. Fork del repositorio
2. Branch feature (`git checkout -b feature/amazing-feature`)
3. Commit cambios (`git commit -m 'Add amazing feature'`)
4. Push al branch (`git push origin feature/amazing-feature`)
5. Pull Request

### Estándares de Código
- SQL formateado y comentado
- Nomenclatura consistente (stg_, int_, fct_)
- Tests comprehensivos
- Documentación actualizada

## 📄 Licencia

Este proyecto es parte de un assessment técnico y sigue las directrices proporcionadas.

---

**Nota**: Este proyecto demuestra capacidades en modelado de datos subscription-based, transformación con dbt, análisis temporal, y visualización de métricas de negocio.
