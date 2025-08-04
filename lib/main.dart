import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(title: 'Eispole', home: HomePage()));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> scoops = [0, 0, 0, 0, 0, 0, 0]; // All 7 flavors
  List<String> flavors = ['Vanilla 🍦', 'Chocolate 🍫', 'Butterscotch 🧈', 'Stracciatella 🍨', 'Cookies 🍪', 'Mango 🥭', 'Bubble Gum 🍬'];
  List<Map> orders = [];

  int get total => scoops.fold(0, (sum, item) => sum + item) * 2;

  void placeOrder() {
    if (scoops.every((s) => s == 0)) {
      _showDialog('Oops! 🙈', 'Please select at least one scoop!', Colors.pink[600]!);
      return;
    }
    
    var order = {
      'number': Random().nextInt(900) + 100,
      'scoops': List.from(scoops),
      'total': total,
      'time': TimeOfDay.now().format(context),
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text('Woohoo! Order Confirmed! 🎉🍦', style: TextStyle(color: Colors.pink[600], fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _gradientBox('Order #${order['number']}', [Colors.cyan[100]!, Colors.blue[100]!], Colors.cyan[700]!),
            SizedBox(height: 10),
            ...List.generate(7, (i) => scoops[i] > 0 ? Text('${flavors[i]}: ${scoops[i]} scoops') : SizedBox()),
            SizedBox(height: 10),
            _gradientBox('Total: €${order['total']}', [Colors.orange[100]!, Colors.yellow[100]!], Colors.orange[700]!),
          ],
        ),
        actions: [
          _button('Cancel Order', Colors.red[400]!, () => _cancelOrder()),
          _button('Awesome! 🎉', Colors.green[400]!, () {
            setState(() {
              orders.add(order);
              scoops = [0, 0, 0, 0, 0, 0, 0];
            });
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  void _cancelOrder() {
    Navigator.pop(context);
    _showDialog('Order Cancelled 😔', 'Your order has been cancelled.', Colors.red[500]!);
    setState(() => scoops = [0, 0, 0, 0, 0, 0, 0]);
  }

  void _showDialog(String title, String content, Color color) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [_button('OK', Colors.blue[400]!, () => Navigator.pop(context))],
      ),
    );
  }

  Widget _button(String text, Color color, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
        child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _gradientBox(String text, List<Color> colors, Color textColor) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors[0], width: 2),
      ),
      child: Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
    );
  }

  Widget _flavorRow(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyan[200]!, width: 2),
        boxShadow: [BoxShadow(color: Colors.cyan[100]!.withOpacity(0.5), spreadRadius: 2, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(flavors[index], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
          Row(
            children: [
              IconButton(onPressed: scoops[index] > 0 ? () => setState(() => scoops[index]--) : null, 
                        icon: Icon(Icons.remove_circle_rounded, color: Colors.red[400], size: 24)),
              Container(
                width: 35, height: 35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.cyan[300]!, Colors.blue[300]!]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(child: Text('${scoops[index]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
              IconButton(onPressed: () => setState(() => scoops[index]++), 
                        icon: Icon(Icons.add_circle_rounded, color: Colors.green[500], size: 24)),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.orange[200]!, Colors.yellow[200]!]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('€${scoops[index] * 2}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange[800])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[50]!, Colors.cyan[50]!, Colors.yellow[50]!, Colors.purple[50]!],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(top: 40, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.pink[400]!, Colors.purple[400]!, Colors.cyan[400]!]),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Center(child: Text('🍦 Eispole 🍨', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Title
                    _gradientBox('🌈 Choose Your Magical Ice Cream! 🌈', [Colors.yellow[100]!, Colors.orange[100]!], Colors.orange[700]!),
                    SizedBox(height: 20),

                    // Flavors
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.cyan[50]!, Colors.blue[50]!]),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.cyan[300]!, width: 2),
                      ),
                      child: Column(children: List.generate(7, (i) => _flavorRow(i))),
                    ),
                    SizedBox(height: 20),

                    // Total & Order button
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.pink[100]!, Colors.purple[100]!]),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.pink[300]!, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text('💰 Total: €$total 💰', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink[700])),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: placeOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400],
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_cart, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Order Now! 🚀', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Order history
            if (orders.isNotEmpty)
              Container(
                height: 180,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.purple[50]!, Colors.pink[50]!]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple[300]!, width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.purple[300]!, Colors.pink[300]!]),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Orders (${orders.length})', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: orders.length,
                        itemBuilder: (_, i) => Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.cyan[200]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('🎫 #${orders[i]['number']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[700])),
                              Text('€${orders[i]['total']} | ${orders[i]['time']}', style: TextStyle(color: Colors.pink[600])),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}