import 'package:flutter_application_3/team.dart';
import 'package:flutter_application_3/team_database.dart';
import 'package:flutter_application_3/team_details_view.dart';
import 'package:flutter/material.dart';

class TeamsView extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback toggleView;
  final bool isGridView;

  const TeamsView({Key? key, required this.toggleTheme, required this.toggleView, required this.isGridView}) : super(key: key);

  @override
  State<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends State<TeamsView> {
  TeamDatabase teamDatabase = TeamDatabase.instance;

  List<TeamModel> teams = [];
  List<TeamModel> filteredTeams = [];
  bool isSearching = false;

  @override
  void initState() {
    refreshTeams();
    super.initState();
  }

  @override
  void dispose() {
    teamDatabase.close();
    super.dispose();
  }

  refreshTeams() {
    teamDatabase.readAll().then((value) {
      setState(() {
        teams = value;
        filteredTeams = value;
      });
    });
  }

  void filterTeams(String query) {
    final filtered = teams.where((team) {
      final teamName = team.name.toLowerCase();
      final input = query.toLowerCase();
      return teamName.contains(input);
    }).toList();

    setState(() {
      filteredTeams = filtered;
      isSearching = query.isNotEmpty;
    });
  }

  goToTeamDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TeamDetailsView(teamId: id)),
    );
    refreshTeams();
  }

  void showOptionsDialog(TeamModel team) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options for ${team.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  goToTeamDetailsView(id: team.id);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  deleteTeam(team);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void deleteTeam(TeamModel team) {
    teamDatabase.delete(team.id!);
    refreshTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: filterTeams,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: Icon(widget.isGridView ? Icons.list : Icons.grid_view),
            onPressed: widget.toggleView,
          ),
        ],
      ),
      body: Center(
        child: filteredTeams.isEmpty
            ? const Text(
                'No Teams found',
                style: TextStyle(color: Colors.white),
              )
            : widget.isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: filteredTeams.length,
                    itemBuilder: (context, index) {
                      final team = filteredTeams[index];
                      return GestureDetector(
                        onTap: () => goToTeamDetailsView(id: team.id),
                        onLongPress: () => showOptionsDialog(team),
                        child: Card(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                team.name,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Year: ${team.year}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: filteredTeams.length,
                    itemBuilder: (context, index) {
                      final team = filteredTeams[index];
                      return GestureDetector(
                        onTap: () => goToTeamDetailsView(id: team.id),
                        onLongPress: () => showOptionsDialog(team),
                        child: Card(
                          child: ListTile(
                            title: Text(team.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Year: ${team.year}'),
                                Text('Last Championship: ${team.lastChampionshipDate.toString().split(' ')[0]}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToTeamDetailsView,
        tooltip: 'Create Team',
        child: const Icon(Icons.add),
      ),
    );
  }
}
