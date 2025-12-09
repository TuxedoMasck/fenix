import 'package:fenix/Back_interfazNotificaciones.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class InterfazNotificaciones extends StatelessWidget {
  const InterfazNotificaciones({super.key});

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('es', timeago.EsMessages());

    return ChangeNotifierProvider(
      create: (_) => NotificacionesLogic(),
      child: Consumer<NotificacionesLogic>(
        builder: (context, logic, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Notificaciones'),
            ),
            body: RefreshIndicator(
              onRefresh: logic.fetchNotifications,
              child: _buildBody(context, logic),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificacionesLogic logic) {
    if (logic.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (logic.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(logic.error!, textAlign: TextAlign.center),
        ),
      );
    }

    if (logic.notificaciones.isEmpty) {
      return const Center(
        child: Text('No tienes notificaciones nuevas.'),
      );
    }

    return ListView.builder(
      itemCount: logic.notificaciones.length,
      itemBuilder: (context, index) {
        final notificacion = logic.notificaciones[index];
        final esLeida = notificacion.leida;
        return Dismissible(
          key: Key(notificacion.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            logic.eliminarNotificacion(notificacion.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notificación "${notificacion.titulo}" eliminada.')),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: esLeida ? Colors.grey.shade300 : Theme.of(context).primaryColor,
              child: Icon(
                Icons.notifications_none,
                color: esLeida ? Colors.grey.shade600 : Colors.white,
              ),
            ),
            title: Text(
              notificacion.titulo,
              style: TextStyle(
                fontWeight: esLeida ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Text(notificacion.cuerpo),
            trailing: Text(
              timeago.format(notificacion.fecha, locale: 'es'),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              logic.marcarComoLeida(notificacion.id);
            },
          ),
        );
      },
    );
  }
}
