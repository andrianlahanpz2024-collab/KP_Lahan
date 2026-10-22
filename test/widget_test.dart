import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_3/screens/home/home_screen.dart';
import 'package:lab_3/screens/settings/settings_screen.dart';
import 'package:lab_3/screens/settings/edit_profile_screen.dart';
import 'package:lab_3/screens/settings/change_password_screen.dart';
import 'package:lab_3/main.dart';

void main() {
  testWidgets('App renders login screen with title', (WidgetTester tester) async {
    await tester.pumpWidget(const BikeDiaryApp());
    expect(find.text('Bike Diary'), findsWidgets);
    expect(find.text('Sign In'), findsWidgets);
  });

  testWidgets('HomeScreen renders map controls and Start Tracking',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.text('Ready to ride'), findsOneWidget);
    expect(find.text('Start Tracking'), findsOneWidget);
    expect(find.text('Trek Marlin 7'), findsOneWidget);
  });

  testWidgets('SettingsScreen renders Profile and Options',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Alex Morgan'), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
  });

  testWidgets('EditProfileScreen renders fields and Save button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: EditProfileScreen()));
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
  });

  testWidgets('ChangePasswordScreen renders password fields and Update button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChangePasswordScreen()));
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Update Password'), findsOneWidget);
  });
}
