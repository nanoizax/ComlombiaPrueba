# Documentación del Proyecto: Aplicación iOS “maasApp-Transmipass”

1. Descripción General del Proyecto

La aplicación maasApp-Transmipass es una solución móvil desarrollada en Swift para dispositivos iOS. El objetivo principal de la app es permitir a los usuarios consultar la información de sus tarjetas Tullave, usadas en el sistema de transporte público de Bogotá, y visualizar los paraderos cercanos en un mapa interactivo utilizando la API de OpenTripPlanner.

2. Funcionalidades Principales

	1.	Registro de Tarjetas Tullave:
	•	Los usuarios pueden ingresar manualmente el número de su tarjeta Tullave. La aplicación verifica si la tarjeta es válida y la registra localmente si lo es.
	•	Las tarjetas se almacenan en el dispositivo, permitiendo al usuario consultar la información en cualquier momento sin necesidad de volver a ingresar los datos.
	2.	Visualización de Paraderos Cercanos:
	•	La aplicación utiliza la API de OpenTripPlanner para obtener información en tiempo real sobre los paraderos de transporte público cercanos a la ubicación del usuario.
	•	Los paraderos se muestran en un mapa interactivo, donde cada paradero aparece marcado con un pin.
	3.	Modo Automático y Manual de Centración en el Mapa:
	•	Por defecto, la aplicación centra automáticamente el mapa en la ubicación actual del usuario.
	•	Se proporciona un botón para activar o desactivar este comportamiento, permitiendo que el usuario explore libremente el mapa sin que se recentre automáticamente.
	4.	Interacción con los Pines del Mapa:
	•	Al tocar un pin en el mapa, el usuario puede ver información detallada relacionada con la ubicación, como el nombre del paradero o la institución marcada.

3. Detalles Técnicos

	1.	Arquitectura:
	•	El proyecto utiliza una arquitectura basada en MVC (Model-View-Controller), donde el MapViewController gestiona la lógica del mapa y la interacción con la API.
	2.	Almacenamiento Local:
	•	Las tarjetas Tullave ingresadas se almacenan en el dispositivo utilizando UserDefaults para mantener la simplicidad. Esto asegura que los datos persistan entre sesiones de la aplicación.
	3.	Solicitudes HTTP:
	•	Para interactuar con la API de OpenTripPlanner y obtener información de los paraderos, se utiliza la clase URLSession. Los datos recibidos se decodifican utilizando JSONDecoder para transformar las respuestas JSON en objetos Swift.
	4.	Ubicación del Usuario:
	•	Se emplea CoreLocation para obtener la ubicación actual del usuario. La aplicación solicita permisos para acceder a la ubicación cuando está en uso, lo que es necesario para mostrar los paraderos cercanos.
	5.	Ubicación Fija para Pruebas:
	•	Se añadieron coordenadas fijas (ubicación en Bogotá) para pruebas con paraderos en zonas específicas:

let latitude = 4.609710
let longitude = -74.081750


	6.	Interacción con el Mapa:
	•	Se utiliza MapKit para la visualización del mapa y para gestionar los pines (anotaciones) en el mapa.
	•	Las anotaciones se gestionan mediante MKPointAnnotation y MKPinAnnotationView, lo que permite personalizar la apariencia y la interacción con los pines.
	7.	Spinner de Carga:
	•	Al cargar los paraderos cercanos por primera vez, se muestra un spinner para indicar al usuario que la aplicación está recuperando datos en segundo plano. Después de la primera carga, el spinner ya no aparece.

4. Flujo de Usuario

	1.	Pantalla de Registro de Tarjetas:
	•	El usuario ingresa el número de su tarjeta Tullave.
	•	Si la tarjeta es válida, se guarda en el dispositivo y aparece en una lista de tarjetas registradas.
	2.	Pantalla del Mapa:
	•	El usuario puede ver los paraderos cercanos en tiempo real, centrados automáticamente en su ubicación.
	•	Mediante el botón de activación/desactivación, el usuario puede alternar entre el modo de centrado automático y la exploración libre del mapa.
	3.	Interacción con Pines:
	•	El usuario puede tocar los pines para ver información sobre cada ubicación.

5. Integración con APIs Externas

	•	API de OpenTripPlanner:
	•	La API de OpenTripPlanner se utiliza para obtener la lista de paraderos cercanos a la ubicación actual del usuario. Esta información se solicita utilizando la URL proporcionada por el servicio y los datos se presentan en el mapa.

6. Requisitos Técnicos

	•	Lenguaje de Programación: Swift 5
	•	Versiones de iOS Soportadas: iOS 13 y superiores
	•	APIs Utilizadas:
	•	MapKit: Para la visualización del mapa y las interacciones con los pines.
	•	CoreLocation: Para obtener la ubicación del usuario.
	•	URLSession: Para realizar las solicitudes HTTP a la API de OpenTripPlanner.

7. Manejo de Errores y Excepciones

	•	Errores de Red:
	•	Si la solicitud a la API de OpenTripPlanner falla (por falta de conexión, tiempo de espera, etc.), la aplicación maneja el error mostrando un mensaje en la consola, y el spinner de carga se detiene automáticamente para evitar que el usuario quede esperando indefinidamente.
	•	Manejo de Errores en la API:
	•	Si la API devuelve un error o los datos recibidos son incorrectos, se muestra un mensaje apropiado al usuario indicando que no fue posible cargar la información.

8. Permisos Requeridos

	•	Permiso de Ubicación:
	•	La aplicación solicita acceso a la ubicación del usuario mientras está en uso, necesario para mostrar los paraderos cercanos en el mapa.
	•	Los permisos se configuran en el archivo Info.plist con las claves NSLocationWhenInUseUsageDescription.

9. Posibles Mejoras Futuras

	•	Sincronización en la Nube: Implementar la sincronización de tarjetas Tullave en la nube para que los usuarios puedan acceder a sus tarjetas desde múltiples dispositivos.
	•	Notificaciones en Tiempo Real: Agregar notificaciones push para alertar a los usuarios cuando haya actualizaciones importantes o cambios en los paraderos cercanos.

