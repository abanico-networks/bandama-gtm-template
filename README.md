# Bandama CMP — plantilla para Google Tag Manager

Plantilla personalizada de **Google Tag Manager** para la plataforma de gestión de consentimiento
de **Bandama**. Establece el estado de consentimiento de Google Consent Mode v2 de forma fiable
antes de que se dispare ninguna etiqueta y carga el banner de consentimiento de Bandama.

## Qué hace
1. Fija el **estado de consentimiento por defecto** (Consent Mode v2): publicidad y analítica
   denegadas hasta obtener el consentimiento; seguridad y funcionalidad concedidas, con un tiempo de
   espera configurable.
2. Aplica la **decisión previa** de la persona usuaria (si ya consintió en una visita anterior) sin
   esperar a que cargue el banner.
3. Carga el **script de consentimiento** de Bandama, que muestra el banner y registra la decisión.

## Campos configurables
| Campo | Valor por defecto | Descripción |
|-------|-------------------|-------------|
| URL del script de consentimiento | `https://cdn.bandama.es/consent.js` | Script de consentimiento de Bandama. Debe coincidir con la URL autorizada en los permisos de inyección de scripts. |
| Espera de actualización (ms) | `500` | Milisegundos que Consent Mode espera una actualización antes de asumir los valores por defecto. |

## Instalación
1. En tu contenedor de GTM, ve a **Plantillas → Plantillas de etiquetas → Importar** y sube
   `template.tpl`.
2. Crea una etiqueta a partir de la plantilla **Bandama CMP**.
3. Asígnale el activador **Inicialización de consentimiento - Todas las páginas**.
4. Configura el resto de tus etiquetas (Google Analytics, Google Ads, etc.) para que respeten el
   estado de consentimiento mediante las comprobaciones de consentimiento integradas de Google Tag
   Manager.

## Permisos
La plantilla solicita únicamente los permisos necesarios para su función:
- **Acceso al consentimiento**: escritura sobre los siete tipos de Google Consent Mode v2.
- **Inyección de scripts**: limitada a `https://cdn.bandama.es/consent.js`.
- **Lectura de cookies**: limitada a la cookie de consentimiento de Bandama.

## Compatibilidad
- Contexto: contenedores **web** de Google Tag Manager.
- Estándar: Google Consent Mode v2.

## Licencia
Uso interno del cliente. Contacta con Bandama para condiciones de distribución.
