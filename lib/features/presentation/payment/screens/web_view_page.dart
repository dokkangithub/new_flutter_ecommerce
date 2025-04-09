import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({
    super.key,
    required this.url,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onNavigationRequest: (NavigationRequest request) {
            // Allow navigation to all URLs
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _onPageStarted(String url) {
    setState(() {
      _isLoading = true;
    });
    
    // Check if the URL contains success or failure indicators
    if (url.contains('paymentStatus=SUCCESS') || 
        url.contains('status=success') || 
        url.contains('order-confirmed')) {
      // Extract the order ID if present
      String? orderId;
      try {
        final uri = Uri.parse(url);
        orderId = uri.queryParameters['merchantOrderId'] ?? 
                  uri.queryParameters['orderId'];
        print('Order ID: $orderId');
      } catch (e) {
        print('Error parsing URL: $e');
      }
      
      // Return to previous screen with success URL
      Navigator.pop(context, url);
    } else if (url.contains('paymentStatus=FAILED') || 
               url.contains('status=failed') || 
               url.contains('payment-failed')) {
      // Return to previous screen with failure URL
      Navigator.pop(context, url);
    }
  }

  void _onPageFinished(String url) {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      // Add simulation buttons for testing only
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context, 
                  '${widget.url}?paymentStatus=SUCCESS&merchantOrderId=123456',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Simulate Success'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context, 
                  '${widget.url}?paymentStatus=FAILED',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Simulate Failure'),
            ),
          ],
        ),
      ),
    );
  }


}
