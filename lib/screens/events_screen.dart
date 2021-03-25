import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class EventsScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Vos Evenements'),
      ),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchAndSet(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapShot.error != null) {
                return Center(child: Text('une erreur est survenue'));
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, chils) {
                    return orderData.orders.isEmpty
                        ?  Center(
                      child: Text('Panier vide!'),
                    )
                        : ListView.builder(
                      itemBuilder: (ctx, index) {
                        return OrderItem(orderData.orders[index].amount,
                            orderData.orders[index]);
                      },
                      itemCount: orderData.orders.length,
                    );
                  },
                );
              }
            }
          }),
      drawer: MainDrawer(),
    );
  }
}
