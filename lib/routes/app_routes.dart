import 'package:go_router/go_router.dart';
import 'package:portfolio/features/home/home_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => HomePage())],
);
