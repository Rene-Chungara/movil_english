// import '../others/imports.dart';

// class LeccionDetailPage extends StatelessWidget {
//   final int leccionId;
//   final String token;
//   ApiService api = ApiService();

//   LeccionDetailPage({required this.leccionId, required this.token});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Detalles de la Lección')),
//       body: FutureBuilder(
//         future: api.getLecciones(token, leccionId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error al cargar los detalles'));
//           }

//           if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text('No se encontraron detalles.'));
//           }

//           var leccion = snapshot.data; // Snapshot data ya no es null

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   leccion['nombre'] ?? 'Sin nombre',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   leccion['descripcion'] ?? 'Sin descripción',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 // Puedes agregar más detalles de la lección aquí
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
