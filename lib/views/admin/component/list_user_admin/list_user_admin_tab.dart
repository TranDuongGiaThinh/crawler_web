import 'package:crawler/views/admin/component/list_user_admin/user_infor_item.dart';
import 'package:crawler/views/admin/presnter/admin_presenter.dart';
import 'package:flutter/material.dart';

class ListUserAdminTab extends StatefulWidget {
  const ListUserAdminTab({super.key, required this.presenter});
  final AdminPresenter presenter;

  @override
  State<ListUserAdminTab> createState() => _ListUserAdminTabState();
}

class _ListUserAdminTabState extends State<ListUserAdminTab> {
  @override
  void initState() {
    super.initState();

    widget.presenter.loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.only(left: 100, right: 100),
        child: ListView(
          children: [
            for (int i = 0; i < widget.presenter.users.length; i++)
              UserInforItem(
                presenter: widget.presenter,
                user: widget.presenter.users[i],
              )
          ],
        ),
      ),
    );
  }
}
