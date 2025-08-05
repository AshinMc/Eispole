import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Eispole',
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Basic variables for tracking scoops
  List<int> scoops = [0, 0, 0, 0, 0, 0, 0];
  List<String> flavors = ['Vanilla', 'Chocolate', 'Butterscotch', 'Stracciatella', 'Cookies', 'Mango', 'Bubble Gum'];
  List<String> emojis = ['🍦', '🍫', '🧈', '🍨', '🍪', '🥭', '🍬'];
  
  // Simple list to store orders
  List<Map> orders = [];
  
  // Calculate total
  int getTotal() {
    int total = 0;
    for (int i = 0; i < scoops.length; i++) {
      total += scoops[i];
    }
    return total * 2; // €2 per scoop
  }
  
  // Place order
  void placeOrder() {
    // Check if any scoops selected
    bool hasScoops = false;
    for (int scoop in scoops) {
      if (scoop > 0) {
        hasScoops = true;
        break;
      }
    }
    
    if (!hasScoops) {
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select at least one scoop!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    
    // Create order number
    int orderNum = Random().nextInt(900) + 100;
    
    // Show order confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Confirmed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #$orderNum'),
            SizedBox(height: 10),
            // Show each flavor with scoops
            for (int i = 0; i < flavors.length; i++)
              if (scoops[i] > 0)
                Text('${emojis[i]} ${flavors[i]}: ${scoops[i]} scoops'),
            SizedBox(height: 10),
            Text('Total: €${getTotal()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              cancelOrder();
            },
            child: Text('Cancel Order'),
          ),
          TextButton(
            onPressed: () {
              // Save order to history
              Map order = {
                'number': orderNum,
                'total': getTotal(),
                'time': '${DateTime.now().hour}:${DateTime.now().minute}',
                'scoops': List.from(scoops),
              };
              
              setState(() {
                orders.add(order);
                // Reset scoops
                for (int i = 0; i < scoops.length; i++) {
                  scoops[i] = 0;
                }
              });
              
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  
  // Cancel order
  void cancelOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Cancelled'),
        content: Text('Your order has been cancelled.'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                // Reset scoops
                for (int i = 0; i < scoops.length; i++) {
                  scoops[i] = 0;
                }
              });
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eispole'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Main ordering section
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  'Choose Your Ice Cream',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                
                // Flavor rows
                for (int i = 0; i < flavors.length; i++)
                  Card(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Flavor name
                          Text('${emojis[i]} ${flavors[i]}', style: TextStyle(fontSize: 16)),
                          Spacer(),
                          
                          // Minus button
                          IconButton(
                            onPressed: scoops[i] > 0 
                              ? () => setState(() => scoops[i]--) 
                              : null,
                            icon: Icon(Icons.remove_circle),
                          ),
                          
                          // Count
                          Text('${scoops[i]}', style: TextStyle(fontSize: 16)),
                          
                          // Plus button
                          IconButton(
                            onPressed: () => setState(() => scoops[i]++),
                            icon: Icon(Icons.add_circle),
                          ),
                          
                          // Price
                          SizedBox(width: 10),
                          Text('€${scoops[i] * 2}'),
                        ],
                      ),
                    ),
                  ),
                
                // Total and order button
                Card(
                  margin: EdgeInsets.only(top: 10),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Total: €${getTotal()}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: placeOrder,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('Place Order', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Order history
          if (orders.isNotEmpty)
            Container(
              height: 200,
              color: Colors.grey[200],
              child: Column(
                children: [
                  Container(
                    color: Colors.blue,
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: Text(
                      'Order History (${orders.length})',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        Map order = orders[index];
                        int totalScoops = 0;
                        for (int scoop in order['scoops']) {
                          totalScoops += scoop;
                        }
                        
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Order #${order['number']}'),
                                Text('€${order['total']} - $totalScoops scoops'),
                                Text('${order['time']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}