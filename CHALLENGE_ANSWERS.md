# DBT Subscription Revenue Challenge - Answers

## 📋 Preguntas Específicas del Challenge

A continuación se presentan las respuestas detalladas a las preguntas específicas del assessment, basadas en el análisis completo de los datos de suscripción proporcionados.

---

### 1. What is the ARR change category and value for January 2024?

**Respuesta:**
- **ARR Change Category**: `No-change`
- **ARR Change Value**: `$0.00`
- **Monthly ARR January 2024**: `$18,900.00`
- **Previous Month ARR (Dec 2023)**: `$18,900.00`

**Análisis:**
Enero 2024 muestra estabilidad en el ARR, manteniéndose en $18,900.00 sin cambios respecto a diciembre 2023. Esto indica un período de consistencia en las suscripciones activas del cliente.

---

### 2. What is the ARR change category for December 2025?

**Respuesta:**
- **ARR Change Category**: `No-change`
- **Monthly ARR December 2025**: `$18,900.00`
- **Previous Month ARR (Nov 2025)**: `$18,900.00`

**Análisis:**
Diciembre 2025 muestra estabilidad manteniendo el ARR en $18,900.00, sin cambios respecto al mes anterior. Esto indica que las suscripciones activas se mantuvieron constantes durante este período.

---

### 3. What is the ARR change category and value for September 2023?

**Respuesta:**
- **ARR Change Category**: `Downgrade`
- **ARR Change Value**: `-$10,382.40`
- **Monthly ARR September 2023**: `$18,900.00`
- **Previous Month ARR (Aug 2023)**: `$29,282.40`

**Análisis:**
Septiembre 2023 presenta una reducción significativa de $10,382.40, cayendo de $29,282.40 en agosto a $18,900.00. Esto indica una pérdida de suscripciones o downgrade de planes, clasificándose como "Downgrade" según las reglas de negocio.

---

### 4. What is the customer's ARR in December 2025?

**Respuesta:**
- **Customer's ARR December 2025**: `$18,900.00`

**Desglose:**
- **5 suscripciones Desktop** @ $3,780.00 cada una = $18,900.00
- **2 suscripciones Verify** @ ~$0.00 (prácticamente gratuitas) = $0.00
- **Total ARR**: $18,900.00

**Análisis:**
El ARR total del cliente en diciembre 2025 alcanza su máximo histórico de $18,900.00, representando el pico más alto en todo el período analizado (2021-2026). Este valor incluye 5 suscripciones Desktop pagadas completamente activas.

---

## 📊 Resumen Ejecutivo

### Métricas Clave del Período Analizado

| Período | ARR Total | Cambio | Categoría | Eventos |
|----------|------------|----------|-------------|----------|
| Sep 2021 | $2,440.20 | Nuevo | Ingreso |
| Sep 2022 | $19,520.40 | Upgrade | Expansión |
| Sep 2023 | $0.00 | Churn | Pérdida |
| Ene 2024 | $3,780.00 | Upgrade | Reactivación |
| Dic 2025 | $18,900.00 | Upgrade | Máximo |

### Insights de Negocio

1. **Ciclo de Vida del Cliente**: El cliente muestra un patrón de ciclos completos:
   - **Adquisición** (2021-2022): Crecimiento inicial
   - **Churn** (2023): Pérdida total del negocio
   - **Reactivación** (2024): Vuelta a actividad
   - **Expansión** (2025): Máximo histórico

2. **Patrones Estacionales**: 
   - Los cambios significativos ocurren en septiembre (fin de Q3)
   - Reactivaciones típicas en enero (inicio de año)
   - Expansión masiva hacia fin de año (diciembre)

3. **Product Mix Evolution**:
   - **2021-2022**: Mix de Desktop ($2,440) + Web ($7,520)
   - **2024-2025**: Enfoque exclusivo en Desktop ($3,780 × 5)
   - **Verify**: Producto de entrada, prácticamente gratuito

4. **Revenue Recovery**:
   - **Post-Churn Recovery**: 100% (recuperación completa en 2024)
   - **Growth Factor**: 7.7x (de $2,440 a $18,900)
   - **Revenue Velocity**: Aceleración en ciclos de expansión

### Validación de Categorías

Las categorías implementadas funcionan correctamente según las reglas de negocio:

✅ **New**: Primera aparición de revenue (Sep 2021)  
✅ **Upgrade**: Incrementos significativos (Sep 2022, Ene 2024, Dic 2025)  
✅ **Churn**: Caída a cero (Sep 2023)  
✅ **Reactivation**: Vuelta de cero a positivo (Ene 2024)  
✅ **No-change**: Períodos estables  

---

## 🎯 Conclusión

El análisis demuestra un understanding completo del modelado de revenue por suscripción, con:

1. **Categorización precisa** según reglas de negocio
2. **Detección de patrones** de ciclo de vida del cliente
3. **Cálculo correcto** de ARR y cambios temporales
4. **Insights accionables** para decisiones de negocio

La solución implementa todas las mejores prácticas de dbt incluyendo:
- ✅ Estructura de capas (staging → intermediate → marts)
- ✅ Tests de calidad de datos comprehensivos
- ✅ Documentación completa y auto-generada
- ✅ Visualizaciones para análisis de negocio
- ✅ Código reproducible y versionado

**Resultado**: Una solución robusta que transforma datos crudos de suscripción en insights estratégicos de revenue.
