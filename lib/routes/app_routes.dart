import 'package:freelance_portfolio/features/home/home_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => HomePage())],
);
