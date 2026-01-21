# 🚀 Quick Setup Guide

## Prerrequisitos

Asegúrate de tener instalado:
- Python 3.8+
- dbt-core y dbt-duckdb
- Git

## Instalación Rápida

```bash
# 1. Clonar el repositorio
git clone https://github.com/JuanLoreiro/globalvision-dbt-challenge.git
cd globalvision-dbt-challenge

# 2. Crear entorno virtual (recomendado)
python -m venv venv
source venv/bin/activate  # Linux/Mac
# o
venv\Scripts\activate  # Windows

# 3. Instalar dependencias
pip install -r requirements.txt

# 4. Instalar paquetes dbt
dbt deps

# 5. Ejecutar el proyecto
dbt seed
dbt run
python analyze_results.py
```

## Archivo requirements.txt

```txt
dbt-core==1.11.2
dbt-duckdb==1.10.0
pandas==2.3.3
matplotlib==3.10.8
seaborn==0.13.2
duckdb==1.4.3
numpy==2.4.1
```

## Verificación de Instalación

```bash
# Verificar modelos dbt
dbt ls

# Verificar conexión a datos
dbt run-operation --args "SELECT COUNT(*) as total_rows FROM {{ ref('stg_subscriptions') }}"

# Verificar visualización
python -c "import duckdb; print('DuckDB connection successful')"
```

## Estructura Esperada Después de Setup

```
globalvision-dbt-challenge/
├── dev.duckdb              # Base de datos DuckDB
├── target/                 # Compilados de dbt
├── dbt_packages/           # Paquetes dbt
├── logs/                   # Logs de ejecución
├── arr_analysis_dashboard.png  # Visualización generada
└── models/                 # Modelos dbt
    ├── main.fct_arr_changes_simple
    ├── main.int_monthly_arr  
    └── main.stg_subscriptions
```

## Solución de Problemas Comunes

### dbt: command not found
```bash
# Agregar dbt al PATH
export PATH="$PATH:$HOME/.local/bin"
# o reinstalar
pip install --force-reinstall dbt-core
```

### Error de conexión DuckDB
```bash
# Verificar archivo profiles.yml
cat profiles.yml
# Limpiar caché
dbt clean
dbt seed
```

### Problemas con Python packages
```bash
# Instalar versión específica
pip install pandas==2.3.3 matplotlib==3.10.8
# Usar pip con --user si hay permisos
pip install --user duckdb
```

## Ejecución de Tests

```bash
# Todos los tests
dbt test

# Tests específicos
dbt test --select stg_subscriptions
dbt test --select fct_arr_changes_simple

# Tests con detalle
dbt test --verbose
```

## Generación de Documentación

```bash
# Documentación de dbt
dbt docs generate
dbt docs serve

# Acceder en navegador
http://localhost:8080
```

## 🎯 Checklist Pre-Entrega

- [ ] dbt seed ejecutado exitosamente
- [ ] dbt run completado sin errores
- [ ] Todos los tests pasando
- [ ] Visualización generada
- [ ] Respuestas del challenge documentadas
- [ ] README completo y actualizado
- [ ] Código limpio y comentado
- [ ] Repositorio Git inicializado

## 📞 Soporte

Si encuentras problemas:

1. **Verificar versiones**: Python 3.8+, dbt 1.11.2
2. **Limpiar caché**: `dbt clean && dbt deps`
3. **Revisar logs**: `logs/dbt.log`
4. **Validar datos**: Verificar `seeds/raw_subscriptions.csv`
5. **Probar conexión**: `dbt debug`

---

**Tiempo estimado de setup**: 10-15 minutos
**Espacio requerido**: ~500MB
