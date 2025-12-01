import 'package:flutter/material.dart';
import 'package:tss_poster/tss_poster.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poster Creator Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Poster Creator Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PosterEditor()),
                );
              },
              child: const Text('Create from Scratch'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AutoPosterPage()),
                );
              },
              child: const Text('Auto Create Poster'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TemplatePage()),
                );
              },
              child: const Text('Use Template'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomEditorPage()),
                );
              },
              child: const Text('Custom Editor (No Shapes)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ControllerDemoPage()),
                );
              },
              child: const Text('External Controller Demo'),
            ),
          ],
        ),
      ),
    );
  }
}

class AutoPosterPage extends StatelessWidget {
  const AutoPosterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auto Poster')),
      body: AutoPosterForm(
        onGenerate: (poster) {
          // Navigate to editor with generated poster
          // Note: You'd need to pass the poster to the editor,
          // which requires updating PosterEditor to accept an initial poster.
          // For now, we'll just show a dialog.
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Poster Generated'),
              content:
                  Text('Generated poster with ${poster.layers.length} layers.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Templates')),
      body: TemplateGallery(
        onSelect: (poster) {
          if (poster.id.startsWith('paid')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('This is a paid template!')),
            );
          } else {
            // Navigate to editor with selected template
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PosterEditor(initialPoster: poster),
              ),
            );
          }
        },
      ),
    );
  }
}

class CustomEditorPage extends StatelessWidget {
  const CustomEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PosterEditor(
        showShape: false,
        onExport: (bytes) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Export Callback'),
              content: Text('Received ${bytes.length} bytes'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ControllerDemoPage extends StatefulWidget {
  const ControllerDemoPage({super.key});

  @override
  State<ControllerDemoPage> createState() => _ControllerDemoPageState();
}

class _ControllerDemoPageState extends State<ControllerDemoPage> {
  final PosterController _controller = PosterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('External Controller Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Get Poster JSON',
            onPressed: () {
              // Access the poster model directly from the controller
              final json = _controller.poster.toJson();

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Poster Data'),
                  content: SingleChildScrollView(
                    child: Text(json.toString()),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PosterEditor(
              controller: _controller,
              showExport: false, // Hide default export button to use our own
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                // Trigger export programmatically
                final image = await _controller.exportAsPNG();
                if (image != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Image exported successfully!')),
                  );
                }
              },
              icon: const Icon(Icons.image),
              label: const Text('Export via Controller'),
            ),
          ),
        ],
      ),
    );
  }
}
