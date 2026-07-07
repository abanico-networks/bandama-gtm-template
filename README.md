# bandama-gtm-template

Custom Template de **Google Tag Manager** para el CMP de **Bandama** (Abanico Networks).

Sustituye el parche de *Custom HTML* (con `stub.js` inline + `gtag("consent")`, que GTM puede
procesar tarde) por una plantilla que usa las APIs sandbox oficiales de GTM —igual que
Cookiebot/CookieConfirm—, por lo que el estado de consentimiento por defecto se fija de forma
fiable antes de que dispare ninguna etiqueta.

## Qué hace (`template.tpl`)
1. `setDefaultConsentState` → todo `denied` salvo `security_storage`/`functionality_storage`
   (`granted`), con `wait_for_update`. Debe ejecutarse en **Consent Initialization**.
2. Lee la cookie **`bandama_gtm`** con `getCookieValues`; si el visitante ya decidió, aplica su
   decisión con `updateConsentState` sin esperar a que cargue el widget.
3. Carga el núcleo del widget (`consent.js`) con `injectScript`. El widget pinta el banner, escribe
   `bandama_gtm` y hace `gtag('consent','update')` (→ dataLayer, que GTM consume) al cambiar el
   consentimiento en el mismo pageview.

## Contrato con el widget (repo `bandama-widget`)
Al persistir, el widget escribe una cookie auxiliar **sin PII**:

```
bandama_gtm=analytics_storage:0|ad_storage:1|ad_user_data:1|ad_personalization:1
```

Señales de **Consent Mode literales** separadas por `|`, cada una `señal:1|0` (`1`=granted,
`0`=denied). Es **config-agnóstico**: la plantilla no necesita conocer los ids de categoría del
dominio, solo mapea `1/0 → granted/denied`. `bandama_consent` sigue siendo la cookie canónica del
producto (base64/JSON); esta es solo el espejo legible para el sandbox.

## Campos configurables
| Campo | Default | Uso |
|-------|---------|-----|
| `consentJsUrl` | `https://cdn.bandama.es/consent.js` | URL del núcleo del widget (debe coincidir con la permitida en `inject_script`). |
| `waitForUpdate` | `500` | ms que Consent Mode espera una actualización. |

## Instalación en el contenedor del cliente
1. **Plantillas → Buscar plantillas / Importar** → sube `template.tpl` (o instálala desde la
   Community Gallery cuando esté publicada).
2. Crea una etiqueta **Bandama CMP** a partir de la plantilla.
3. Asígnale el trigger **Consent Initialization - All Pages**.
4. El resto de etiquetas (GA4, Ads, Meta…) deben usar los *consent checks* nativos de GTM, o
   dispararse con el evento `bandama_consent_update` que el widget empuja al dataLayer.

## Permisos que pide la plantilla
- `access_consent` (escritura) sobre los 7 tipos de Consent Mode v2.
- `inject_script` limitado a `https://cdn.bandama.es/consent.js`.
- `get_cookies` limitado a `bandama_gtm`.

## Nota sobre el `.tpl`
El fichero está en el formato de exportación de GTM. Al importarlo, el **editor de plantillas de
GTM valida y normaliza** metadata y permisos; confirma los permisos en la UI la primera vez.

## Publicación en la Community Template Gallery (pendiente)
Requiere, además del `.tpl`: `LICENSE` (Apache-2.0), `metadata.yaml` con el repo homepage y el
[flujo de contribución](https://developers.google.com/tag-platform/tag-manager/templates/gallery)
de Google. Hasta entonces se distribuye por importación manual del `.tpl`.
