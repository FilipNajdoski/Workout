import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ResultType { time, weight, reps }

class BenchmarkScreen extends StatefulWidget {
  @override
  _BenchmarkScreenState createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  List<BenchmarkEntryData> entries = [];
  List<List<BenchmarkEntryData>> submittedBenchmarks = [];

  void addEntry() {
    setState(() {
      // Allow only one benchmark entry per submission.
      entries = [BenchmarkEntryData()];
    });
  }

  void submitBenchmark() {
    // Optionally validate entries before submission.
    setState(() {
      submittedBenchmarks.add(List.from(entries));
      // Clear the current entries after submission:
      entries.clear();
    });
  }

  bool _canSubmit() {
    if (entries.isEmpty) return false;
    for (var entry in entries) {
      if (entry.name.trim().isEmpty || entry.resultType == null) return false;
      if (entry.resultType == ResultType.time) {
        if (entry.minutes.trim().isEmpty || entry.seconds.trim().isEmpty)
          return false;
      } else if (entry.resultType == ResultType.weight) {
        if (entry.weight.trim().isEmpty) return false;
      } else if (entry.resultType == ResultType.reps) {
        if (entry.reps.trim().isEmpty) return false;
      }
    }
    return true;
  }

  String _formatEntryResult(BenchmarkEntryData entry) {
    if (entry.resultType == ResultType.time) {
      return '${entry.minutes}:${entry.seconds}';
    } else if (entry.resultType == ResultType.weight) {
      return '${entry.weight} ${entry.weightUnit}';
    } else if (entry.resultType == ResultType.reps) {
      return '${entry.reps}';
    }
    return '';
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: entries.isEmpty
          ? FloatingActionButton(
              onPressed: addEntry,
              child: Icon(Icons.add),
            )
          : null,
      //appBar: AppBar(title: Text('Benchmark')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Form area
              if (!entries.isEmpty) ...[
                // Display the benchmark entry fields.
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    for (int i = 0; i < entries.length; i++)
                      BenchmarkEntry(
                        entryData: entries[i],
                        onChanged: () => setState(() {}),
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _canSubmit() ? submitBenchmark : null,
                      child: Text('Submit Benchmark'),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 32),
              // Submitted benchmarks list
              if (submittedBenchmarks.isNotEmpty) ...[
                Text(
                  'Benchmarks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: submittedBenchmarks.length,
                  itemBuilder: (context, index) {
                    final benchmark = submittedBenchmarks[index];
                    return Dismissible(
                      key: Key('benchmark_$index'),
                      direction: DismissDirection.horizontal,
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // Swipe right: Delete benchmark.
                          final bool? confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Benchmark'),
                              content: Text(
                                  'Are you sure you want to delete this benchmark?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            setState(() {
                              submittedBenchmarks.removeAt(index);
                            });
                          }
                          return false;
                        } else if (direction == DismissDirection.endToStart) {
                          // Swipe left: Edit benchmark.
                          // Create a temporary copy of the benchmark entries.
                          List<BenchmarkEntryData> tempBenchmark =
                              benchmark.map((entry) => entry.copy()).toList();
                          final editedBenchmark =
                              await showDialog<List<BenchmarkEntryData>>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Edit Benchmark'),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (int i = 0;
                                        i < tempBenchmark.length;
                                        i++)
                                      BenchmarkEntry(
                                        entryData: tempBenchmark[i],
                                        onChanged: () {},
                                      ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, null),
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(context, tempBenchmark),
                                  child: Text('Update'),
                                ),
                              ],
                            ),
                          );
                          if (editedBenchmark != null) {
                            setState(() {
                              submittedBenchmarks[index] = editedBenchmark;
                            });
                          }
                          return false;
                        }
                        return false;
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 16),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.blue,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(8),
                        child: Text(
                          benchmark.map((entry) {
                            final entryName =
                                entry.name.isNotEmpty ? entry.name : 'Unnamed';
                            return '$entryName: ${_formatEntryResult(entry)}';
                          }).join('\n'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class BenchmarkEntryData {
  String name = '';
  ResultType? resultType;
  // For time
  String minutes = '';
  String seconds = '';
  // For weight
  String weight = '';
  String weightUnit = 'kg'; // or lb
  // For reps
  String reps = '';

  BenchmarkEntryData copy() {
    return BenchmarkEntryData()
      ..name = name
      ..resultType = resultType
      ..minutes = minutes
      ..seconds = seconds
      ..weight = weight
      ..weightUnit = weightUnit
      ..reps = reps;
  }
}

class BenchmarkEntry extends StatefulWidget {
  final BenchmarkEntryData entryData;
  final VoidCallback onChanged;
  const BenchmarkEntry({
    Key? key,
    required this.entryData,
    required this.onChanged,
  }) : super(key: key);

  @override
  _BenchmarkEntryState createState() => _BenchmarkEntryState();
}

class _BenchmarkEntryState extends State<BenchmarkEntry> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movement Name Input
            TextFormField(
              initialValue: widget.entryData.name,
              decoration: InputDecoration(labelText: 'Movement Name'),
              onChanged: (value) {
                widget.entryData.name = value;
                widget.onChanged();
              },
            ),
            SizedBox(height: 8),
            // Dropdown to choose result type
            DropdownButton<ResultType>(
              isExpanded: true,
              value: widget.entryData.resultType,
              hint: Text('Select Result Type'),
              items: [
                DropdownMenuItem(
                  child: Text('Time'),
                  value: ResultType.time,
                ),
                DropdownMenuItem(
                  child: Text('Weight'),
                  value: ResultType.weight,
                ),
                DropdownMenuItem(
                  child: Text('Reps'),
                  value: ResultType.reps,
                ),
              ],
              onChanged: (ResultType? newValue) {
                setState(() {
                  widget.entryData.resultType = newValue;
                });
                widget.onChanged();
              },
            ),
            SizedBox(height: 8),
            // Conditional display based on selection
            if (widget.entryData.resultType == ResultType.time) ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: widget.entryData.minutes.isEmpty
                          ? "00"
                          : widget.entryData.minutes,
                      decoration: InputDecoration(labelText: 'Minutes'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      // If using Form validation, you can enable this validator.
                      validator: (value) {
                        final minute = int.tryParse(value ?? "0") ?? 0;
                        if (minute < 0 || minute > 59) {
                          return '0-59 allowed';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        widget.entryData.minutes = value;
                        widget.onChanged();
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: widget.entryData.seconds.isEmpty
                          ? "00"
                          : widget.entryData.seconds,
                      decoration: InputDecoration(labelText: 'Seconds'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      validator: (value) {
                        final sec = int.tryParse(value ?? "0") ?? 0;
                        if (sec < 0 || sec > 59) {
                          return '0-59 allowed';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        widget.entryData.seconds = value;
                        widget.onChanged();
                      },
                    ),
                  ),
                ],
              ),
            ] else if (widget.entryData.resultType == ResultType.weight) ...[
              TextFormField(
                initialValue: widget.entryData.weight,
                decoration: InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  widget.entryData.weight = value;
                  widget.onChanged();
                },
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                isExpanded: true,
                value: widget.entryData.weightUnit,
                items: [
                  DropdownMenuItem(child: Text('kg'), value: 'kg'),
                  DropdownMenuItem(child: Text('lb'), value: 'lb'),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    widget.entryData.weightUnit = newValue!;
                  });
                  widget.onChanged();
                },
              ),
            ] else if (widget.entryData.resultType == ResultType.reps) ...[
              TextFormField(
                initialValue: widget.entryData.reps,
                decoration: InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  widget.entryData.reps = value;
                  widget.onChanged();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
