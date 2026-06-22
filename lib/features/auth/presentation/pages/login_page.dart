import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: isDark 
                    ? AppColors.errorDark 
                    : AppColors.errorLight,
              ),
            );
          } else if (state is AuthAuthenticated) {
            // Navigate to home page
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      
                      // Logo & Title
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: isDark 
                                ? AppColors.primaryGradientDark 
                                : AppColors.primaryGradientLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Center(
                        child: Text(
                          'app_name'.tr(),
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Center(
                        child: Text(
                          'welcome'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        label: 'email'.tr(),
                        hint: 'enter_email'.tr(),
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'field_required'.tr();
                          }
                          if (!value.contains('@')) {
                            return 'invalid_email'.tr();
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        label: 'password'.tr(),
                        hint: 'enter_password'.tr(),
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'field_required'.tr();
                          }
                          if (value.length < 6) {
                            return 'password_too_short'.tr();
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: isDark 
                                    ? AppColors.primaryDark 
                                    : AppColors.primaryLight,
                              ),
                              Text(
                                'remember_me'.tr(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to forgot password
                            },
                            child: Text(
                              'forgot_password'.tr(),
                              style: TextStyle(
                                color: isDark 
                                    ? AppColors.primaryDark 
                                    : AppColors.primaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Login Button
                      CustomButton(
                        text: 'login'.tr(),
                        onPressed: _handleLogin,
                        isLoading: state is AuthLoading,
                        icon: Icons.login,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark 
                                  ? AppColors.borderDark 
                                  : AppColors.borderLight,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or'.tr(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark 
                                  ? AppColors.borderDark 
                                  : AppColors.borderLight,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Features
                      _buildFeatureCard(
                        context,
                        icon: Icons.checklist,
                        title: 'mark_attendance'.tr(),
                        description: 'سجل حضور الطلاب بسهولة',
                        color: AppColors.successLight,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildFeatureCard(
                        context,
                        icon: Icons.folder,
                        title: 'upload_material'.tr(),
                        description: 'شارك المواد التعليمية',
                        color: AppColors.infoLight,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildFeatureCard(
                        context,
                        icon: Icons.assessment,
                        title: 'manage_grades'.tr(),
                        description: 'إدارة الدرجات والامتحانات',
                        color: AppColors.warningLight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}