import 'package:master_plan/provider/plan_provider.dart';

import '../models/data_layer.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;
  const PlanScreen({super.key, required this.plan});

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // Plan plan = const Plan();

  late ScrollController scrollController;
  Plan get plan => widget.plan;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(plan.name)),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          Plan currentPlan = plans.firstWhere((p) => p.name == plan.name);
          return Column(
            children: [
              Expanded(child: _buildList(currentPlan)),
              SafeArea(child: Text(currentPlan.completenessMessage)),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(
        context,
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Master Plan')),
  //     body: ValueListenableBuilder<Plan>(
  //       valueListenable: PlanProvider.of(context),
  //       builder: (context, plan, child) {
  //         return Column(
  //           children: [
  //             Expanded(child: _buildList(plan)),
  //             SafeArea(child: Text(plan.completenessMessage))
  //           ],
  //         );
  //       },
  //     ),
  //     floatingActionButton: _buildAddTaskButton(context),
  //   );
  // }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // ganti ‘Namaku' dengan Nama panggilan Anda
  //     appBar: AppBar(title: const Text('Master Plan Miftah')),
  //     body: _buildList(),
  //     floatingActionButton: _buildAddTaskButton(),
  //   );
  // }

  // Widget _buildAddTaskButton() {
  //   return FloatingActionButton(
  //     child: const Icon(Icons.add),
  //     onPressed: () {
  //       setState(() {
  //         plan = Plan(
  //           name: plan.name,
  //           tasks: List<Task>.from(plan.tasks)..add(const Task()),
  //         );
  //       });
  //     },
  //   );
  // }

 Widget _buildTaskTile(Task task, int index, BuildContext context) {
  ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);

  return ListTile(
    leading: Checkbox(
      value: task.complete,
      onChanged: (selected) {
        if (selected == null) return;
        
        // Get current plan and its index
        final currentPlan = planNotifier.value.firstWhere(
          (p) => p.name == plan.name,
          orElse: () => plan,
        );
        final planIndex = planNotifier.value.indexOf(currentPlan);
        
        // Create updated task list
        final updatedTasks = List<Task>.from(currentPlan.tasks);
        updatedTasks[index] = Task(
          description: task.description,
          complete: selected,
        );
        
        // Create updated plans list
        final updatedPlans = List<Plan>.from(planNotifier.value);
        updatedPlans[planIndex] = Plan(
          name: currentPlan.name,
          tasks: updatedTasks,
        );
        
        // Update state
        planNotifier.value = updatedPlans;
      },
    ),
    title: TextFormField(
      initialValue: task.description,
      onChanged: (text) {
        // Get current plan and its index
        final currentPlan = planNotifier.value.firstWhere(
          (p) => p.name == plan.name,
          orElse: () => plan,
        );
        final planIndex = planNotifier.value.indexOf(currentPlan);
        
        // Create updated task list
        final updatedTasks = List<Task>.from(currentPlan.tasks);
        updatedTasks[index] = Task(
          description: text,
          complete: task.complete,
        );
        
        // Create updated plans list
        final updatedPlans = List<Plan>.from(planNotifier.value);
        updatedPlans[planIndex] = Plan(
          name: currentPlan.name,
          tasks: updatedTasks,
        );
        
        // Update state
        planNotifier.value = updatedPlans;
      },
    ),
  );
}

Widget _buildAddTaskButton(BuildContext context) {
  ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
  
  return FloatingActionButton(
    child: const Icon(Icons.add),
    onPressed: () {
      // Get current plan and its index
      final currentPlan = planNotifier.value.firstWhere(
        (p) => p.name == plan.name,
        orElse: () => plan,
      );
      final planIndex = planNotifier.value.indexOf(currentPlan);
      
      // Create updated task list
      final updatedTasks = List<Task>.from(currentPlan.tasks)..add(const Task());
      
      // Create updated plans list
      final updatedPlans = List<Plan>.from(planNotifier.value);
      updatedPlans[planIndex] = Plan(
        name: currentPlan.name,
        tasks: updatedTasks,
      );
      
      // Update state
      planNotifier.value = updatedPlans;
    },
  );
}

  // Widget _buildAddTaskButton(BuildContext context) {
  //   ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
  //   return FloatingActionButton(
  //     child: const Icon(Icons.add),
  //     onPressed: () {
  //       Plan currentPlan = plan;
  //       int planIndex =
  //           planNotifier.value.indexWhere((p) => p.name == currentPlan.name);
  //       List<Task> updatedTasks = List<Task>.from(currentPlan.tasks)
  //         ..add(const Task());

  //       // Update plan dengan task baru
  //       planNotifier.value = List<Plan>.from(planNotifier.value)
  //         ..[planIndex] = Plan(
  //           name: currentPlan.name,
  //           tasks: updatedTasks,
  //         );
  //     },
  //   );
  // }

  // Widget _buildAddTaskButton(BuildContext context) {
  //   ValueNotifier<Plan> planNotifier = PlanProvider.of(context);
  //   return FloatingActionButton(
  //     child: const Icon(Icons.add),
  //     onPressed: () {
  //       Plan currentPlan = planNotifier.value;
  //       planNotifier.value = Plan(
  //         name: currentPlan.name,
  //         tasks: List<Task>.from(currentPlan.tasks)..add(const Task()),
  //       );
  //     },
  //   );
  // }

  Widget _buildList(Plan plan) {
    return ListView.builder(
      controller: scrollController,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) =>
          _buildTaskTile(plan.tasks[index], index, context),
    );
  }

  // Widget _buildList() {
  //   return ListView.builder(
  //     controller: scrollController,
  //     keyboardDismissBehavior: Theme.of(context).platform == TargetPlatform.iOS
  //         ? ScrollViewKeyboardDismissBehavior.onDrag
  //         : ScrollViewKeyboardDismissBehavior.manual,
  //     itemCount: plan.tasks.length,
  //     itemBuilder: (context, index) => _buildTaskTile(plan.tasks[index], index),
  //   );
  // }

  // Widget _buildTaskTile(Task task, int index, BuildContext context) {
  //   ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);

  //   return ListTile(
  //     leading: Checkbox(
  //         value: task.complete,
  //         onChanged: (selected) {
  //           if (selected == null) return;

  //           final currentPlan = plan;
  //           final planIndex = planNotifier.value
  //               .indexWhere((p) => p.name == currentPlan.name);

  //           if (planIndex == -1) return; // Handle jika plan tidak ditemukan

  //           final updatedPlan = Plan(
  //             name: currentPlan.name,
  //             tasks: List<Task>.from(currentPlan.tasks)
  //               ..[index] = Task(
  //                 description: task.description,
  //                 complete: selected,
  //               ),
  //           );

  //           planNotifier.value = List<Plan>.from(planNotifier.value)
  //             ..[planIndex] = updatedPlan;
  //         }),
  //     title: TextFormField(
  //       initialValue: task.description,
  //       onChanged: (text) {
  //         final currentPlan = plan;
  //         final planIndex =
  //             planNotifier.value.indexWhere((p) => p.name == currentPlan.name);

  //         if (planIndex == -1) return;

  //         planNotifier.value = List<Plan>.from(planNotifier.value)
  //           ..[planIndex] = Plan(
  //             name: currentPlan.name,
  //             tasks: List<Task>.from(currentPlan.tasks)
  //               ..[index] = Task(
  //                 description: text,
  //                 complete: task.complete,
  //               ),
  //           );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildTaskTile(Task task, int index, BuildContext context) {
  //   ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);

  //   return ListTile(
  //     leading: Checkbox(
  //         value: task.complete,
  //         onChanged: (selected) {
  //           Plan currentPlan = plan;
  //           int planIndex = planNotifier.value
  //               .indexWhere((p) => p.name == currentPlan.name);
  //           planNotifier.value = List<Plan>.from(planNotifier.value)
  //             ..[planIndex] = Plan(
  //               name: currentPlan.name,
  //               tasks: List<Task>.from(currentPlan.tasks)
  //                 ..[index] = Task(
  //                   description: task.description,
  //                   complete: selected ?? false,
  //                 ),
  //             );
  //         }),
  //     title: TextFormField(
  //       initialValue: task.description,
  //       onChanged: (text) {
  //         Plan currentPlan = plan;
  //         int planIndex =
  //             planNotifier.value.indexWhere((p) => p.name == currentPlan.name);
  //         planNotifier.value = List<Plan>.from(planNotifier.value)
  //           ..[planIndex] = Plan(
  //             name: currentPlan.name,
  //             tasks: List<Task>.from(currentPlan.tasks)
  //               ..[index] = Task(
  //                 description: text,
  //                 complete: task.complete,
  //               ),
  //           );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildTaskTile(Task task, int index, BuildContext context) {
  //   ValueNotifier<Plan> planNotifier = PlanProvider.of(context);
  //   return ListTile(
  //     leading: Checkbox(
  //         value: task.complete,
  //         onChanged: (selected) {
  //           Plan currentPlan = planNotifier.value;
  //           planNotifier.value = Plan(
  //             name: currentPlan.name,
  //             tasks: List<Task>.from(currentPlan.tasks)
  //               ..[index] = Task(
  //                 description: task.description,
  //                 complete: selected ?? false,
  //               ),
  //           );
  //         }),
  //     title: TextFormField(
  //       initialValue: task.description,
  //       onChanged: (text) {
  //         Plan currentPlan = planNotifier.value;
  //         planNotifier.value = Plan(
  //           name: currentPlan.name,
  //           tasks: List<Task>.from(currentPlan.tasks)
  //             ..[index] = Task(
  //               description: text,
  //               complete: task.complete,
  //             ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildTaskTile(Task task, int index) {
  //   return ListTile(
  //     leading: Checkbox(
  //         value: task.complete,
  //         onChanged: (selected) {
  //           setState(() {
  //             plan = Plan(
  //               name: plan.name,
  //               tasks: List<Task>.from(plan.tasks)
  //                 ..[index] = Task(
  //                   description: task.description,
  //                   complete: selected ?? false,
  //                 ),
  //             );
  //           });
  //         }),
  //     title: TextFormField(
  //       initialValue: task.description,
  //       onChanged: (text) {
  //         setState(() {
  //           plan = Plan(
  //             name: plan.name,
  //             tasks: List<Task>.from(plan.tasks)
  //               ..[index] = Task(
  //                 description: text,
  //                 complete: task.complete,
  //               ),
  //           );
  //         });
  //       },
  //     ),
  //   );
  // }
}
