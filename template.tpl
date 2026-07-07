___INFO___

{
  "type": "TAG",
  "id": "cvt_bandama_cmp",
  "version": 1,
  "securityGroups": [],
  "displayName": "Bandama CMP",
  "categories": ["UTILITY", "ANALYTICS", "ADVERTISING"],
  "description": "Plataforma de gestión de consentimiento de Bandama. Establece el estado de consentimiento por defecto (Google Consent Mode v2), aplica la decisión previa de la persona usuaria y carga el banner de consentimiento. Añádela a una etiqueta con el activador «Inicialización de consentimiento - Todas las páginas».",
  "containerContexts": ["WEB"]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "consentJsUrl",
    "displayName": "URL del script de consentimiento",
    "simpleValueType": true,
    "defaultValue": "https://cdn.bandama.es/consent.js",
    "valueValidators": [
      { "type": "NON_EMPTY" }
    ],
    "help": "URL del script de consentimiento de Bandama. Debe coincidir con la URL autorizada en los permisos de inyección de scripts."
  },
  {
    "type": "TEXT",
    "name": "waitForUpdate",
    "displayName": "Espera de actualización (ms)",
    "simpleValueType": true,
    "defaultValue": 500,
    "help": "Milisegundos que Consent Mode espera una actualización del consentimiento antes de asumir los valores por defecto."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState = require('updateConsentState');
const getCookieValues = require('getCookieValues');
const injectScript = require('injectScript');
const makeInteger = require('makeInteger');

const CONSENT_COOKIE = 'bandama_gtm';

// Estado de consentimiento por defecto: publicidad y analítica denegadas hasta que la persona
// usuaria decida; seguridad y funcionalidad concedidas.
const waitForUpdate = data.waitForUpdate ? makeInteger(data.waitForUpdate) : 500;
setDefaultConsentState({
  ad_storage: 'denied',
  ad_user_data: 'denied',
  ad_personalization: 'denied',
  analytics_storage: 'denied',
  functionality_storage: 'granted',
  personalization_storage: 'denied',
  security_storage: 'granted',
  wait_for_update: waitForUpdate
});

// Aplica la decisión previa de la persona usuaria, si existe.
const values = getCookieValues(CONSENT_COOKIE);
if (values && values.length > 0 && values[0]) {
  const update = parseConsent(values[0]);
  if (update) {
    updateConsentState(update);
  }
}

// Carga el script de consentimiento.
injectScript(data.consentJsUrl, data.gtmOnSuccess, data.gtmOnFailure, data.consentJsUrl);

// Convierte "analytics_storage:1|ad_storage:0|..." en { analytics_storage: 'granted', ... }.
function parseConsent(raw) {
  const out = {};
  const parts = raw.split('|');
  for (let i = 0; i < parts.length; i++) {
    const kv = parts[i].split(':');
    if (kv.length === 2 && kv[0]) {
      out[kv[0]] = kv[1] === '1' ? 'granted' : 'denied';
    }
  }
  return out;
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "ad_storage" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "ad_user_data" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "ad_personalization" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "analytics_storage" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "functionality_storage" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "personalization_storage" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "security_storage" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              { "type": 1, "string": "https://cdn.bandama.es/consent.js" }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              { "type": 1, "string": "bandama_gtm" }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Plantilla de gestión de consentimiento de Bandama para Google Tag Manager.
