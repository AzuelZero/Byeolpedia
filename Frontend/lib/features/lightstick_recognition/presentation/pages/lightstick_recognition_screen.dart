  State<LightstickRecognitionScreen> createState() => _LightstickRecognitionScreenState();
}

class _LightstickRecognitionScreenState extends State<LightstickRecognitionScreen> {
  bool _isProcessing = false;
  List<RecognitionResult> _results = [];
  late LightstickService _lightstickService;

  @override
  void initState() {
    super.initState();
    _lightstickService = LightstickService(ApiService());
  }

  Future<void> _captureAndRecognize() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      // Simulate image capture - in real app, use image_picker or camera
      final mockImagePath = '/path/to/image.jpg';
      
      final resultsData = await _lightstickService.recognizeLightstick(mockImagePath);
      
      setState(() {
        _results = resultsData.map((data) => RecognitionResult(
          id: data['id'],
          name: data['name'],
          confidence: data['confidence'],
          group: data['group'],
          version: data['version'],
        )).toList();
        _isProcessing = false;
      });
      
      _showRecognitionResults();
    } catch (e) {
      setState(() => _isProcessing = false);
      _showErrorDialog('Error al procesar la imagen: ${e.toString()}');
    }
  }

  void _showRecognitionResults() {
    showModalBottomSheet(
      context: context,
      builder: (context) => RecognitionResultsSheet(results: _results),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reconocimiento de Lightsticks')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Vista previa de la cámara',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Presiona el botón para capturar y reconocer',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Reconociendo lightstick...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndRecognize,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class RecognitionResult {
  final String id;
  final String name;
  final double confidence;
  final String group;
  final String version;

  RecognitionResult({
    required this.id,
    required this.name,
    required this.confidence,
    required this.group,
    required this.version,
  });
}

class RecognitionResultsSheet extends StatelessWidget {
  final List<RecognitionResult> results;

  const RecognitionResultsSheet({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resultados del Reconocimiento',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (results.isEmpty)
            const Text('No se reconoció ningún lightstick')
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.lightbulb, color: Colors.white),
                    ),
                    title: Text(result.name),
                    subtitle: Text('${result.group} - ${result.version}'),
                    trailing: Text(
                      '${(result.confidence * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: result.confidence > 0.8 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ),
        ],
      ),
    );
  }
}