# 🤝 Contributing to DBT Subscription Revenue Challenge

¡Gracias por tu interés en contribuir a este proyecto! Este repositorio contiene la solución completa al DBT Subscription Revenue Modeling Challenge.

## 🚀 Cómo Contribuir

### Reporting Issues

Si encuentras un bug o tienes una sugerencia:

1. **Bug Report**: Usa el template de issue con:
   - Descripción detallada del problema
   - Pasos para reproducir
   - Environment (OS, Python, dbt version)
   - Logs relevantes

2. **Feature Request**: Describe:
   - Caso de uso propuesto
   - Beneficio esperado
   - Alternativas consideradas

### Development Setup

```bash
# 1. Fork el repositorio
git clone https://github.com/TU_USERNAME/globalvision-dbt-challenge.git

# 2. Crea tu branch
git checkout -b feature/nombre-de-tu-feature

# 3. Setup del entorno
python -m venv venv
source venv/bin/activate  # Linux/Mac
# o venv\Scripts\activate  # Windows
pip install -r requirements.txt
dbt deps

# 4. Haz tus cambios
# Edita los archivos necesarios
# Ejecuta tests: dbt test
# Ejecuta análisis: python analyze_results.py

# 5. Commit y push
git add .
git commit -m "feat: descripción concisa del cambio"
git push origin feature/nombre-de-tu-feature
```

## 📁 Estructura del Proyecto

```
models/
├── staging/          # Datos limpios y estandarizados
├── intermediate/      # Modelos intermedios de lógica de negocio
└── marts/           # Modelos finales para consumo

seeds/               # Datos de entrada crudos
macros/              # Funciones reutilizables (si aplica)
tests/               # Tests de datos personalizados
analyses/            # Análisis ad-hoc
```

## 🎯 Estándares de Código

### SQL/dbt Models
- **Nomenclatura**: 
  - `stg_` para staging
  - `int_` para intermediate  
  - `fct_` para facts/marts
- **Indentación**: 2 espacios
- **Comentarios**: Explicar lógica de negocio compleja
- **Columnas**: snake_case

### Python Scripts
- **PEP 8 compliant**: Formato y estilo
- **Type hints**: Cuando sea aplicable
- **Docstrings**: Para funciones principales
- **Imports**: Agrupados al inicio

### YAML Configuration
- **2 espacios** para indentación
- **Quotes consistentes**
- **Comentarios descriptivos**

## 🧪 Testing

### Tests de dbt
```bash
# Ejecutar todos los tests
dbt test

# Tests específicos
dbt test --select stg_subscriptions
dbt test --select fct_arr_changes_simple

# Tests con cobertura
dbt test --select tag:critical
```

### Tests Python
```bash
# Si se agregan tests Python
python -m pytest tests/
python -m pytest tests/ --cov=analyze_results
```

## 📝 Tipos de Contribuciones

### 🐛 Bug Fixes
- Pequeños arreglos: `fix: corrección del problema`
- Issues críticos: `fix!: corrección crítica`
- Referenciar issue número: `fix: resolve #123`

### ✨ Features
- Nuevas funcionalidades: `feat: agregar nueva visualización`
- Mejoras: `feat: mejorar performance de queries`
- Breaking changes: `feat!: cambio que afecta compatibilidad`

### 📚 Documentation
- Actualizar README: `docs: actualizar guía de instalación`
- Mejorar comentarios: `docs: agregar comentarios en modelo X`

### 🎨 Estilo y Formato
- Code style: `style: aplicar black formatting`
- Refactoring: `refactor: mejorar estructura del código`

## 🔍 Review Process

### Antes de Submit PR
- [ ] Tests pasando localmente
- [ ] Código formateado correctamente
- [ ] Documentación actualizada
- [ ] Sin prints o logs temporales
- [ ] Commits atómicos y descriptivos

### PR Template
```markdown
## Descripción
Breve descripción del cambio propuesto.

## Tipo de Cambio
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests unitarios pasando
- [ ] Tests de integración pasando
- [ ] Manual testing completado

## Checklist
- [ ] Código sigue estándares del proyecto
- [ ] Tests agregados si aplica
- [ ] Documentación actualizada
- [ ] Self-review completado
```

## 🏷️ Labels de Issues

- `bug`: Problemas reportados
- `enhancement`: Mejoras propuestas
- `documentation`: Issues de docs
- `good first issue`: Para nuevos contribuyentes
- `help wanted`: Solicitando ayuda
- `priority: high`: Crítico/urgente
- `priority: medium`: Importante pero no urgente
- `priority: low`: Nice to have

## 📊 Métricas de Calidad

### Performance
- Queries dbt deben ejecutarse en < 30 segundos
- Script Python debe completar en < 2 minutos
- Uso de memoria < 500MB para análisis

### Cobertura
- Tests de datos críticos: 100%
- Documentación de modelos: 100%
- Manejo de casos edge: > 80%

## 🎖️ Code of Conduct

- Ser respetuoso y constructivo
- Aceptar feedback y mejorar
- Ayudar a nuevos contribuyentes
- Seguir estándares profesionales

## 🏆 Reconocimiento

Las contribuciones serán reconocidas en:
- CHANGELOG.md
- Contributors section en README
- Releases notes

---

**Gracias por contribuir a hacer este proyecto mejor para todos!** 🚀
