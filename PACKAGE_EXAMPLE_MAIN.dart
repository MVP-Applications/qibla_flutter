import 'package:flutter/material.dart';
import 'package:qibla_ar_finder/qibla_ar_finder.dart';

void main() {
  runApp(const QiblaARFinderExample());
}

class QiblaARFinderExample extends StatelessWidget {
  const QiblaARFinderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qibla AR Finder Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla AR Finder Examples'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            context,
            title: 'AR View',
            description: 'Find Qibla using Augmented Reality',
            icon: Icons.view_in_ar,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ARViewExample()),
            ),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'Compass View',
            description: 'Traditional compass with Qibla indicator',
            icon: Icons.explore,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CompassViewExample()),
            ),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'Full Featured Page',
            description: 'Complete page with all features',
            icon: Icons.dashboard,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QiblaARPage()),
            ),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'Custom Configuration',
            description: 'AR view with custom styling',
            icon: Icons.settings,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomConfigExample()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

// Example 1: Basic AR View
class ARViewExample extends StatelessWidget {
  const ARViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR View Example'),
      ),
      body: QiblaARView(
        onQiblaFound: (direction) {
          debugPrint('Qibla direction: $direction°');
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        },
      ),
    );
  }
}

// Example 2: Compass View
class CompassViewExample extends StatelessWidget {
  const CompassViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compass View Example'),
      ),
      body: Center(
        child: QiblaCompass(
          onDirectionChanged: (direction) {
            debugPrint('Current heading: $direction°');
          },
          showDegrees: true,
          compassSize: 300,
        ),
      ),
    );
  }
}

// Example 3: Custom Configuration
class CustomConfigExample extends StatelessWidget {
  const CustomConfigExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Configuration'),
      ),
      body: QiblaARView(
        config: ARConfig(
          showVerticalWarning: true,
          arrowColor: Colors.amber,
          kaabaOpacity: 0.9,
          enableSmoothing: true,
          smoothingFactor: 0.15,
        ),
        onQiblaFound: (direction) {
          debugPrint('Qibla: $direction°');
        },
      ),
    );
  }
}
