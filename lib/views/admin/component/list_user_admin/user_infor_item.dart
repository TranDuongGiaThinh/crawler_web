import 'package:crawler/models/user_model.dart';
import 'package:crawler/views/admin/presnter/admin_presenter.dart';
import 'package:crawler/views/home/components/user_tab/package_user_item.dart';
import 'package:crawler/views/home/presenter/user_tab_presenter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserInforItem extends StatefulWidget {
  const UserInforItem({
    super.key,
    required this.presenter,
    required this.user,
  });

  final AdminPresenter presenter;
  final UserModel user;

  @override
  State<UserInforItem> createState() => _UserInforItemState();
}

class _UserInforItemState extends State<UserInforItem> {
  late UserTabPresenter userTapPresenter;

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  void initState() {
    super.initState();

    userTapPresenter = UserTabPresenter(
        user: widget.user,
        reload: () {
          setState(() {
            widget.presenter.reload();
          });
        });

    widget.presenter.loadPackageTypes();
    userTapPresenter.loadPackageUserOfUser();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.user.fullname,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      String message;
                      if (widget.user.locked) {
                        bool result =
                            await widget.presenter.unlockUser(widget.user.id);
                        message = result
                            ? 'Mở khóa người dùng thành công.'
                            : 'Mở khóa người dùng thất bại.';
                      } else {
                        bool result =
                            await widget.presenter.lockUser(widget.user.id);
                        message = result
                            ? 'Khóa người dùng thành công.'
                            : 'Khóa người dùng thất bại.';
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Thông báo'),
                            content: Text(message),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  widget.presenter.loadUsers();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      widget.user.locked ? Icons.lock_outline : Icons.lock_open,
                      color: widget.user.locked ? Colors.red : Colors.grey,
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${widget.user.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Số điện thoại: ${widget.user.phone}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Trạng thái: ${widget.user.locked ? "Bị khóa" : "Hoạt động"}',
              style: const TextStyle(fontSize: 16),
            ),
            ExpansionTile(
              title: const Text(
                'Gói đang sử dụng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              children: [
                if (userTapPresenter.packageUsers.isNotEmpty)
                  PackageUserItem(
                    packageUser: userTapPresenter.packageUsers[0],
                    userType: widget.presenter.getUserType(
                        userTapPresenter.packageUsers[0].userTypeId),
                    packageTypeName: widget.presenter.getPackageTypeName(
                            userTapPresenter.packageUsers[0].packageTypeId) ??
                        "",
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Không có gói thành viên nào đang sử dụng.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
            ExpansionTile(
              title: const Text(
                'Lịch sử gói',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              children: [
                if (userTapPresenter.packageUsers.isNotEmpty)
                  for (int i = 0; i < userTapPresenter.packageUsers.length; i++)
                    PackageUserItem(
                      packageUser: userTapPresenter.packageUsers[i],
                      userType: widget.presenter.getUserType(
                          userTapPresenter.packageUsers[i].userTypeId),
                      packageTypeName: widget.presenter.getPackageTypeName(
                              userTapPresenter.packageUsers[i].packageTypeId) ??
                          "",
                    )
                else
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Không có lịch sử gói thành viên.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
