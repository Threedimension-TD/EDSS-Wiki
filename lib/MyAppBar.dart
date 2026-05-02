/// 自定义顶部导航栏组件
/// 包含 Logo、标题、Wiki 页面菜单、新建页面、更新日志、登录/用户头像等功能

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:web_of_edss/componets/WikiCard.dart';
import 'package:web_of_edss/main.dart';
import 'package:web_of_edss/services/auth_service.dart';
import 'package:web_of_edss/services/wiki_service.dart';
import 'package:web_of_edss/specialpage/LoginPage.dart';

/// 自定义顶部导航栏（有状态组件）
/// 实现 PreferredSizeWidget 以支持自定义高度
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  /// 设置 AppBar 高度为 80 像素
  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

/// MyAppBar 的状态管理类
class _MyAppBarState extends State<MyAppBar> {

  /// Wiki 页面 ID 列表，用于下拉菜单展示
  List<String> wikiPages = [];

  /// 是否正在加载 Wiki 页面列表
  bool loadingWikiPages = true;

  /// 用户是否已登录
  bool isLoggedIn = false;

  /// 初始化状态：加载 Wiki 页面列表并检查登录状态
  @override
  void initState() {
    super.initState();
    _loadWikiPages();
    _checkLoginStatus();
  }

  /// 检查用户登录状态，异步获取后更新 UI
  void _checkLoginStatus() async {
    final loggedIn = await AuthService.isLoggedIn();
    setState(() => isLoggedIn = loggedIn);
  }

  /// 从后端加载所有 Wiki 页面 ID 列表
  /// 加载成功后更新 wikiPages 列表并关闭加载状态
  Future<void> _loadWikiPages() async {
    try {
      final pages = await WikiService.getAllPageIds();
      if (mounted) {
        setState(() {
          wikiPages = pages;
          loadingWikiPages = false;
        });
      }
    } catch (e) {
      loadingWikiPages = false;
    }
  }

  /// 退出登录并跳转到首页
  /// 清除登录状态后移除所有路由栈并跳转到根路由
  Future<void> logoutAndGoHome(BuildContext context) async {
    await AuthService.logout();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,  // 黑色背景
      toolbarHeight: 80,              // 工具栏高度

      /// 中间区域：Logo + 标题（响应式布局）
      /// 点击可跳转到首页
      title: InkWell(
        onTap: () => Navigator.pushNamed(context, '/'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 30),
            // 网站 Logo 图片
            Image.asset(
              'assets/images/logo.png',
              height: 80,
            ),
            const SizedBox(width: 5),
            // 文字 Logo
            SizedBox(
              height: 25,
              width: 120,
              child: Image.asset('assets/images/textlogo.png'),
            ),
            const SizedBox(width: 5),
            // 网站名称（溢出时省略显示）
            Flexible(
              child: Text(
                '永昼生存服务器',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),

      /// 右侧功能按钮区域
      actions: [
        // 用户头像/登录按钮
        _buildUserButton(context),

        // 新建页面按钮（需登录，未登录则跳转登录页）
        Tooltip(
          message: "新建页面",
          child: IconButton(onPressed:
            () {
              if (isLoggedIn) {
                Navigator.pushNamed(context, "/create");
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              }
            },
            icon: const Icon(Icons.add, color: Colors.white,)),
        ),

        // 更新日志按钮
        Tooltip(
          message: "更新日志",
          child: IconButton(
            iconSize: 30,
            icon: const Icon(Icons.update, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/update'),
          ),
        ),
        SizedBox(width: 8),

        // Wiki 页面下拉菜单
        _buildWikiMenu(context),
      ],
    );
  }

  /// 构建 Wiki 页面下拉菜单
  /// 加载中时显示加载指示器，加载完成后显示所有页面列表
  Widget _buildWikiMenu(BuildContext context) {
    // 加载中状态：显示小型圆形进度指示器
    if (loadingWikiPages) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    // 加载完成：显示下拉菜单
    return Padding(padding: EdgeInsets.only(right: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          // 自定义触发按钮为菜单图标
          customButton: const Tooltip(
            message: "Wiki 页面",
            child: Icon(
              Icons.menu,
              color: Colors.white,
              size: 28,
            ),
          ),
          // 将 wikiPages 列表映射为下拉菜单项
          items: wikiPages.map((pageId) {
            return DropdownMenuItem<String>(
              value: pageId,
              child: GestureDetector(
                // 双击页面项可弹出删除菜单（仅登录用户可用）
                onDoubleTapDown: (details){
                  if (!isLoggedIn) return;
                  _showDeleteMenu(
                    context,
                    pageId,
                    details.globalPosition,
                  );
                },
                child: Text(
                  pageId,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            );
          }).toList(),
          // 选择页面后跳转到对应的 Wiki 页面
          onChanged: (pageId) {
            if (pageId != null) {
              Navigator.pushNamed(context, '/wiki/$pageId');
            }
          },
          // 下拉菜单样式配置
          dropdownStyleData: DropdownStyleData(
            width: 220,
            decoration: BoxDecoration(
              color: const Color.fromARGB(200, 40, 40, 40),  // 半透明深色背景
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      )
    );
  }

  /// 显示删除页面的右键菜单
  /// [pageId] 要删除的页面 ID
  /// [position] 菜单弹出的位置
  void _showDeleteMenu(
    BuildContext context,
    String pageId,
    Offset position,
  ) async {
    final result = await showMenu<String>(
      context: context,
      color: Color.fromARGB(200, 40, 40, 40),  // 半透明深色背景
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: [
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: const [
              Icon(
                Icons.delete,
                color: Colors.red,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                '删除页面',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // 用户选择了"删除"选项，弹出确认对话框
    if (result == 'delete') {
      _confirmDeletePage(context, pageId);
    }
  }

  /// 显示删除页面的确认对话框
  /// 用户确认后调用 WikiService 删除页面并刷新页面列表
  void _confirmDeletePage(BuildContext context, String pageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Text('确认删除'),
        content: Text('确定要删除页面「$pageId」吗？此操作不可恢复。'),
        actions: [
          // 取消按钮
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Color.fromARGB(170, 0, 0, 0))),
          ),
          // 删除按钮（红色文字提示危险操作）
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                // 调用服务删除页面
                await WikiService.deletePage(pageId);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('页面已删除')),
                );

                // 重新加载页面列表
                await _loadWikiPages();

              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('删除失败：$e')),
                );
              }
            },
            child: const Text(
              '删除',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建用户按钮（登录/头像）
  /// 已登录状态：显示头像，点击可退出登录
  /// 未登录状态：显示登录按钮
  Widget _buildUserButton(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        final loggedIn = snapshot.data == true;

        if (loggedIn) {
          // 已登录：显示头像，点击弹出退出确认对话框
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    title: const Text('退出登录'),
                    content: const Text('确定要退出当前账号吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('取消', style: TextStyle(color: Color.fromARGB(170, 0, 0, 0))),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('退出', style: TextStyle(color: Color.fromARGB(199, 255, 0, 0))),
                      ),
                    ],
                  ),
                );

                // 用户确认退出
                if (result == true) {
                  await AuthService.logout();
                  if (!context.mounted) return;

                  // 清除路由栈并跳转到首页
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                }
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/logged.png'),
              ),
            ),
          );
        } else {
          // 未登录：显示登录按钮
          return TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              '登录',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
