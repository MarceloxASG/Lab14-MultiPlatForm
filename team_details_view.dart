// team_details_view.dart

import 'package:flutter_application_3/team.dart';
import 'package:flutter_application_3/team_database.dart';
import 'package:flutter/material.dart';

class TeamDetailsView extends StatefulWidget {
  final int? teamId;

  const TeamDetailsView({super.key, this.teamId});

  @override
  _TeamDetailsViewState createState() => _TeamDetailsViewState();
}

class _TeamDetailsViewState extends State<TeamDetailsView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  DateTime _lastChampionshipDate = DateTime.now();

  late TeamDatabase teamDatabase;
  bool _isEditing = false;
  late TeamModel _team;

  @override
  void initState() {
    super.initState();
    teamDatabase = TeamDatabase.instance;
    if (widget.teamId != null) {
      _isEditing = true;
      teamDatabase.read(widget.teamId!).then((team) {
        setState(() {
          _team = team;
          _nameController.text = team.name;
          _yearController.text = team.year.toString();
          _lastChampionshipDate = team.lastChampionshipDate;
        });
      });
    } else {
      _team = TeamModel(name: '', year: DateTime.now().year, lastChampionshipDate: DateTime.now());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _saveTeam() async {
    final name = _nameController.text.trim();
    final year = int.parse(_yearController.text.trim());

    if (_isEditing) {
      await teamDatabase.update(_team.copy(name: name, year: year, lastChampionshipDate: _lastChampionshipDate));
    } else {
      await teamDatabase.create(TeamModel(name: name, year: year, lastChampionshipDate: _lastChampionshipDate));
    }

    Navigator.pop(context);
  }

  Future<void> _deleteTeam() async {
    await teamDatabase.delete(_team.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Team' : 'Create Team'),
        actions: _isEditing
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Team'),
                      content: Text('Are you sure you want to delete this team?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: _deleteTeam,
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Year'),
            ),
            SizedBox(height: 12.0),
            ListTile(
              title: Text('Last Championship Date'),
              subtitle: Text(_lastChampionshipDate.toString().split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: _lastChampionshipDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (newDate != null) {
                  setState(() {
                    _lastChampionshipDate = newDate;
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveTeam,
              child: Text(_isEditing ? 'Update Team' : 'Create Team'),
            ),
          ],
        ),
      ),
    );
  }
}
