import 'package:flutter/material.dart';
import 'package:master_plan/models/plan.dart';
import 'package:master_plan/provider/plan_provider.dart';
import 'package:master_plan/views/plan_screen.dart';

class PlanCreatorScreen extends StatefulWidget {
  const PlanCreatorScreen({super.key});

  @override
  State<PlanCreatorScreen> createState() => _PlanCreatorScreenState();
}

class _PlanCreatorScreenState extends State<PlanCreatorScreen> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Plans Miftah'),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [_buildListCreator(), Expanded(child: _buildMasterPlans())],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // ganti ‘Namaku' dengan nama panggilan Anda
  //     appBar: AppBar(title: const Text('Master Plans Miftah')),
  //     body: Column(children: [
  //       _buildListCreator(),
  //       Expanded(child: _buildMasterPlans())
  //     ]),
  //   );
  // }

  Widget _buildListCreator() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(15),
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: 'Tambah Rencana Baru',
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.add_task, color: Colors.blue),
          ),
          onEditingComplete: addPlan,
        ),
      ),
    );
  }

  // Widget _buildListCreator() {
  //   return Padding(
  //       padding: const EdgeInsets.all(20.0),
  //       child: Material(
  //         color: Theme.of(context).cardColor,
  //         elevation: 10,
  //         child: TextField(
  //             controller: textController,
  //             decoration: const InputDecoration(
  //                 labelText: 'Add a plan', contentPadding: EdgeInsets.all(20)),
  //             onEditingComplete: addPlan),
  //       ));
  // }

  void addPlan() {
    final text = textController.text;
    if (text.isEmpty) {
      return;
    }
    final plan = Plan(name: text, tasks: []);
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    planNotifier.value = List<Plan>.from(planNotifier.value)..add(plan);
    textController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {});
  }

  Widget _buildMasterPlans() {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    List<Plan> plans = planNotifier.value;

    if (plans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 100,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Rencana',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Tambahkan rencana baru dengan mengisi form di atas',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.list_alt, color: Colors.blue),
              ),
              title: Text(
                plan.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  plan.completenessMessage,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PlanScreen(plan: plan),
                  ),
                );
              },
            ),
          );
        },
      ),
    );

    // Widget _buildMasterPlans() {
    //   ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    //   List<Plan> plans = planNotifier.value;

    //   if (plans.isEmpty) {
    //     return Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Container(
    //             padding: const EdgeInsets.all(32),
    //             decoration: BoxDecoration(
    //               color: Colors.grey.withOpacity(0.1),
    //               shape: BoxShape.circle,
    //             ),
    //             child: const Icon(
    //               Icons.assignment_outlined,
    //               size: 100,
    //               color: Colors.blue,
    //             ),
    //           ),
    //           const SizedBox(height: 16),
    //           Text(
    //             'Belum ada rencana',
    //             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.blue,
    //                 ),
    //           ),
    //           const SizedBox(height: 8),
    //           Text(
    //             'Tambahkan rencana baru dengan mengisi form di atas',
    //             textAlign: TextAlign.center,
    //             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    //                   color: Colors.grey[600],
    //                 ),
    //           ),
    //         ],
    //       ),
    //     );
    //   }

    // if (plans.isEmpty) {
    //   return Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Icon(Icons.note, size: 100, color: Colors.grey),
    //         Text('Anda belum memiliki rencana apapun.',
    //             style: Theme.of(context).textTheme.headlineSmall)
    //       ]);
    // }
    //   return ListView.builder(
    //       itemCount: plans.length,
    //       itemBuilder: (context, index) {
    //         final plan = plans[index];
    //         return ListTile(
    //             title: Text(plan.name),
    //             subtitle: Text(plan.completenessMessage),
    //             onTap: () {
    //               Navigator.of(context).push(MaterialPageRoute(
    //                   builder: (_) => PlanScreen(
    //                         plan: plan,
    //                       )));
    //             });
    //       });
    // }
  }
}
