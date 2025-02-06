import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/util/helper/chart_helpers.dart';
import '../bloc/analysis_bloc.dart';
import '../helper/analysis_helper.dart';
import '../widgets/member_category_view.dart';

/// @author : Jibin K John
/// @date   : 05/02/2025
/// @time   : 19:27:46
class MembersDetailView extends StatefulWidget {
  final List<MembersChartData> chartData;
  final double total;
  final AnalysisState analysisState;

  const MembersDetailView({
    super.key,
    required this.chartData,
    required this.total,
    required this.analysisState,
  });

  @override
  State<MembersDetailView> createState() => _MembersDetailViewState();
}

class _MembersDetailViewState extends State<MembersDetailView> {
  late ValueNotifier<String> _selectedMember;
  late ValueNotifier<Map<String, List<CategoryChartData>>>
  _membersCategoryMapData;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initMembersData();
  }

  @override
  void dispose() {
    if (!_isDisposed) {
      _selectedMember.dispose();
      _membersCategoryMapData.dispose();
      _isDisposed = true;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Detail Summary"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Headers
          Container(
            color: Colors.white,
            height: size.height * kHeaderHeight,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
              scrollDirection: Axis.horizontal,
              itemCount: widget.chartData.length,
              separatorBuilder: (ctx, index) => const SizedBox(width: 5.0),
              itemBuilder: (ctx, index) {
                return ValueListenableBuilder(
                    valueListenable: _selectedMember,
                    builder: (ctx, selectedMember, _) {
                      final isSelected = _selectedMember.value ==
                          widget.chartData[index].user.uid;
                      return ActionChip(
                        onPressed: () =>
                        _selectedMember.value =
                            widget.chartData[index].user.uid,
                        backgroundColor: isSelected
                            ? Colors.blue.shade50
                            : Colors.grey.shade200,
                        side: BorderSide.none,
                        label: Text(
                          widget.chartData[index].user.name,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: isSelected ? Colors.blue : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    });
              },
            ),
          ),

          // Main Body
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _selectedMember,
              builder: (ctx, selectedMember, _) {
                final memberMap = {
                  for (var member in widget.chartData) member.user.uid: member
                };
                final member =
                    memberMap[selectedMember] ?? widget.chartData.first;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: KeyedSubtree(
                    key: ValueKey(selectedMember),
                    child: MemberCategoryView(
                      categoryData:
                      _membersCategoryMapData.value[member.user.uid] ?? [],
                      memberData: member,
                      size: size,
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  void _initMembersData() {
    _selectedMember = ValueNotifier(widget.chartData.first.user.uid);
    _membersCategoryMapData = ValueNotifier(_getMembersCategoryMapData());
  }

  Map<String, List<CategoryChartData>> _getMembersCategoryMapData() {
    return {
      for (var user in widget.chartData)
        user.user.uid: AnalysisHelper.getCategoryDataForUser(
          context: context,
          userId: user.user.uid,
          transactions: widget.analysisState.transactions,
        ),
    };
  }
}

const kHeaderHeight = 0.05;
const kHorizontalPadding = 16.0;
