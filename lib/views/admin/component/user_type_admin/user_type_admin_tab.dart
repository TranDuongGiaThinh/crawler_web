import 'package:crawler/views/admin/component/user_type_admin/add_user_type_dialog.dart';
import 'package:crawler/views/admin/component/user_type_admin/user_type_admin_item.dart';
import 'package:crawler/views/admin/presnter/admin_presenter.dart';
import 'package:flutter/material.dart';

class UserTypeAdminTab extends StatefulWidget {
  const UserTypeAdminTab({super.key, required this.presenter});
  final AdminPresenter presenter;

  @override
  State<UserTypeAdminTab> createState() => _UserTypeAdminTabState();
}

class _UserTypeAdminTabState extends State<UserTypeAdminTab> {
  @override
  void initState() {
    super.initState();

    widget.presenter.loadUserTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: widget.presenter.isHandling
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: (widget.presenter.userTypes.length / 3).ceil(),
                      itemBuilder: (context, rowIndex) {
                        final startIndex = rowIndex * 3;
                        final endIndex = startIndex + 3;
                        final rowItems = widget.presenter.userTypes.sublist(
                          startIndex,
                          endIndex > widget.presenter.userTypes.length
                              ? widget.presenter.userTypes.length
                              : endIndex,
                        );
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: rowItems.map((userType) {
                            return UserTypeAdminItem(
                              presenter: widget.presenter,
                              item: userType,
                            );
                          }).toList(),
                        );
                      },
                    ),
            ),
          ],
        ),
        Positioned(
          bottom: 32.0,
          right: 32.0,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddUserTypeDialog(presenter: widget.presenter);
                },
              );
            },
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
