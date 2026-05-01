# Introducción a Distribuciones Estadísticas

En este post exploramos las distribuciones de probabilidad más comunes y su aplicación en análisis de datos.

## 1. Distribución Normal (Gaussiana)

La distribución normal es una de las más importantes en estadística. Su función de densidad de probabilidad está dada por:

$$f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}$$

donde $\mu$ es la media y $\sigma$ es la desviación estándar.


```python
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

# Parámetros de la distribución normal
mu = 100  # media
sigma = 15  # desviación estándar

# Generar datos
x = np.linspace(mu - 4*sigma, mu + 4*sigma, 1000)
y = stats.norm.pdf(x, mu, sigma)

# Visualizar
plt.figure(figsize=(10, 6))
plt.plot(x, y, 'b-', linewidth=2, label='PDF Distribución Normal')
plt.fill_between(x, y, alpha=0.2)
plt.xlabel('Valor')
plt.ylabel('Densidad de Probabilidad')
plt.title(f'Distribución Normal (μ={mu}, σ={sigma})')
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()

print(f"Media: {mu}")
print(f"Desviación estándar: {sigma}")
```

## 2. Distribución Exponencial

La distribución exponencial se utiliza para modelar tiempos entre eventos. Su función de densidad es:

$$f(x) = \lambda e^{-\lambda x}$$ 

donde $\lambda > 0$ es el parámetro de tasa.


```python
# Parámetro de tasa
lambda_param = 0.5

# Generar datos
x_exp = np.linspace(0, 10, 1000)
y_exp = stats.expon.pdf(x_exp, scale=1/lambda_param)

# Visualizar
plt.figure(figsize=(10, 6))
plt.plot(x_exp, y_exp, 'r-', linewidth=2, label=f'PDF Exponencial (λ={lambda_param})')
plt.fill_between(x_exp, y_exp, alpha=0.2, color='red')
plt.xlabel('Tiempo')
plt.ylabel('Densidad de Probabilidad')
plt.title(f'Distribución Exponencial')
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()
```

## 3. Análisis de Datos Reales

A continuación, demonstramos cómo verificar si un conjunto de datos sigue una distribución normal usando el test de Shapiro-Wilk:


```python
# Generar datos de muestra
np.random.seed(42)
sample_data = np.random.normal(100, 15, 100)

# Test de Shapiro-Wilk
statistic, p_value = stats.shapiro(sample_data)

print(f"Test de Shapiro-Wilk")
print(f"Estadístico: {statistic:.4f}")
print(f"P-valor: {p_value:.4f}")
print(f"\nInterpretación: ", end="")
if p_value > 0.05:
    print("Los datos parecen seguir una distribución normal (no rechazamos H0)")
else:
    print("Los datos NO siguen una distribución normal (rechazamos H0)")
```

## 4. Ejemplo de SQL: Análisis de Distribuciones en Base de Datos

En práctica, frecuentemente necesitamos analizar distribuciones directamente desde bases de datos:

```sql
-- Calcular media, mediana y desviación estándar en SQL
SELECT 
    AVG(valor) as media,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY valor) as mediana,
    STDDEV_POP(valor) as desviacion_estandar,
    COUNT(*) as total_registros
FROM datos_ventas
WHERE fecha >= '2026-01-01';
```

## 5. Conclusiones

- La **distribución normal** es fundamental en estadística y aparece en muchos fenómenos naturales
- La **distribución exponencial** es útil para modelar tiempos de espera y eventos raros
- Siempre es importante **verificar los supuestos distribucionales** antes de aplicar pruebas estadísticas
- Los **tests estadísticos** como Shapiro-Wilk nos ayudan a validar nuestros datos

---

*Este post fue generado a partir de un Jupyter notebook. Para más información sobre estadística aplicada, consulta la documentación oficial de SciPy.*
