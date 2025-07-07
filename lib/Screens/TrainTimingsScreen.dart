import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrainTimingsScreen extends StatefulWidget {
  final String stationName;

  const TrainTimingsScreen({super.key, required this.stationName});

  @override
  State<TrainTimingsScreen> createState() => _TrainTimingsScreenState();
}

class _TrainTimingsScreenState extends State<TrainTimingsScreen> {
  List<dynamic> trainTimings = [];
  bool isLoading = true;
  String? errorMessage;
  bool isNetworkError = false;
  late String stationCode;

  @override
  void initState() {
    super.initState();
    // Map station names to their codes
    if (widget.stationName.toLowerCase().contains('raipur')) {
      stationCode = 'R';
    } else if (widget.stationName.toLowerCase().contains('durg')) {
      stationCode = 'DURG';
    } else {
      stationCode = 'R'; // Default to Raipur if no match
    }

    // Add a small delay to avoid mouse tracker errors during hot reload
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTrainTimings();
    });
  }

  Future<void> fetchTrainTimings() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
      isNetworkError = false;
    });

    // For debugging purposes
    print('Attempting to fetch train timings for station code: $stationCode');

    final apiUrl =
        'https://rail-sahayak-api-612894814147.us-central1.run.app/api/timetable/$stationCode';
    print('API URL: $apiUrl');

    try {
      final response = await http
          .get(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (!mounted) return;

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // The API returns trains array directly instead of data property
        if (data['trains'] == null) {
          setState(() {
            errorMessage = 'API returned data in unexpected format';
            isLoading = false;
          });
          return;
        }

        setState(() {
          trainTimings = data['trains'] ?? [];
          isLoading = false;
        });

        print('Successfully loaded ${trainTimings.length} train records');
      } else {
        setState(() {
          errorMessage =
              'Failed to load train timings. Server responded with code ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        String errorMsg = e.toString();
        isNetworkError =
            errorMsg.contains('SocketException') ||
            errorMsg.contains('timeout') ||
            errorMsg.contains('Unable to resolve host');

        errorMessage = isNetworkError
            ? 'Network error: Please check your internet connection and try again.'
            : 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.train, color: Colors.white, size: 28),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Train Timings for ${widget.stationName} Station',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'UP and DN train schedules',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 221, 221, 221),
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8.0),
          child: Container(
            height: 6.0,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.redAccent),
                ),
              )
            else if (errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red.shade400),
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.red.shade50,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (isNetworkError)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ElevatedButton.icon(
                            onPressed: fetchTrainTimings,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            else if (trainTimings.isEmpty)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'No train timings available',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: fetchTrainTimings,
                  color: Colors.redAccent,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: trainTimings.length,
                    itemBuilder: (context, index) {
                      final train = trainTimings[index];
                      return Card(
                        key: ValueKey('train_${index}'),
                        margin: const EdgeInsets.only(bottom: 12.0),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      train['trainName'] ?? 'Unknown Train',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      train['trainNo']?.toString() ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Arrival: ${train['arrival'] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Departure: ${train['departure'] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              if (train['haltMins'] !=
                                  null) // Changed from 'halt' to 'haltMins'
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.hourglass_bottom,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Halt Time: ${train['haltMins']} min',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
