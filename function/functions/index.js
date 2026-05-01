const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Función auxiliar para calcular la distancia entre dos coordenadas (Fórmula de Haversine)
function getDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Radio de la Tierra en kilómetros
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (lon2 - lon1) * Math.PI / 180;
    const a = 
        Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
        Math.sin(dLon/2) * Math.sin(dLon/2); 
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
    return R * c; 
}

exports.assignDriverToOrder = functions.firestore
    .document('orders/{orderId}')
    .onUpdate(async (change, context) => {
        const orderData = change.after.data();
        const previousOrderData = change.before.data();
        const orderId = context.params.orderId;

        // Condición 1: El restaurante acaba de aceptar el pedido (y NO es self-delivery, por lo que pasa a "order_accepted")
        const isNewlyAccepted = orderData.orderStatus === 'order_accepted' && previousOrderData.orderStatus !== 'order_accepted';
        
        // Condición 2: El repartidor asignado rechazó el pedido, por lo que buscamos al siguiente ("driver_rejected")
        const isDriverRejected = orderData.orderStatus === 'driver_rejected' && previousOrderData.orderStatus !== 'driver_rejected';

        // Si no cumple ninguna, terminamos la ejecución para no gastar recursos
        if (!isNewlyAccepted && !isDriverRejected) {
            return null;
        }

        console.log(`Buscando repartidor para el pedido ${orderId}. Estado: ${orderData.orderStatus}`);

        try {
            // Obtenemos todos los conductores en línea y activos
            const driversSnapshot = await admin.firestore().collection('driver')
                .where('isOnline', '==', true)
                .where('active', '==', true)
                .get();

            if (driversSnapshot.empty) {
                console.log('No hay conductores en línea disponibles en este momento.');
                return null;
            }

            // Lista de IDs de conductores que ya rechazaron este pedido (para no volver a preguntarles)
            const rejectedDriverIds = orderData.rejectedDriverIds || [];
            
            let nearestDriver = null;
            let shortestDistance = Number.MAX_VALUE;

            // Coordenadas del restaurante
            const restaurantLat = orderData.vendorAddress?.location?.latitude;
            const restaurantLng = orderData.vendorAddress?.location?.longitude;

            if (!restaurantLat || !restaurantLng) {
                console.log('Error: La ubicación del restaurante no está definida en el pedido.');
                return null;
            }

            // Iteramos sobre todos los conductores para encontrar al más cercano
            driversSnapshot.forEach(doc => {
                const driver = doc.data();
                
                // Excluimos a los que ya rechazaron el pedido
                if (rejectedDriverIds.includes(driver.driverId)) {
                    return;
                }

                // Asegurarnos de que el conductor tenga ubicación registrada
                const driverLat = driver.location?.latitude;
                const driverLng = driver.location?.longitude;

                if (driverLat && driverLng) {
                    const distance = getDistance(restaurantLat, restaurantLng, driverLat, driverLng);
                    
                    // Si está más cerca que el anterior guardado, lo reemplazamos
                    if (distance < shortestDistance) {
                        shortestDistance = distance;
                        nearestDriver = driver;
                    }
                }
            });

            // Si no quedó ningún conductor elegible (ej. todos lo rechazaron o están muy lejos)
            if (!nearestDriver) {
                console.log('No se encontraron conductores elegibles cerca del restaurante.');
                return null;
            }

            console.log(`Asignando al conductor ${nearestDriver.driverId} al pedido ${orderId}. Distancia: ${shortestDistance.toFixed(2)} km`);

            // 1. Actualizamos el documento del pedido
            await admin.firestore().collection('orders').doc(orderId).update({
                driverId: nearestDriver.driverId,
                orderStatus: 'driver_assigned', // El estado exacto que usa la app en order_status.dart
                assignedAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            // 2. Actualizamos el documento del conductor
            await admin.firestore().collection('driver').doc(nearestDriver.driverId).update({
                orderId: orderId,
                status: 'busy' // Para que el mapa sepa que ya está ocupado
            });

            console.log(`Asignación completada con éxito para el pedido ${orderId}`);

            // NOTA: Para notificaciones Push (FCM), podrías añadir el código de admin.messaging().send() aquí.
            
            return true;
        } catch (error) {
            console.error('Error al asignar conductor:', error);
            return null;
        }
    });
