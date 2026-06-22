import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/dashboard_stats_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadDashboard() async {
    emit(HomeLoading());

    try {
      // Simulate API call - في الواقع ستكون API call حقيقية
      await Future.delayed(const Duration(seconds: 1));
      
      // Using mock data for now
      final stats = DashboardStatsModel.mock();
      
      emit(HomeLoaded(stats));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }
}