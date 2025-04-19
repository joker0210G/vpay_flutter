vPay: Refined Project Resources Documentation

1. Project Overview

Project Name: vPay

Tagline: Versatile Payment & Earn-Now Platform  

Vision: To create a mobile-first ecosystem connecting users (primarily students initially) with hyperlocal micro-tasks and short-term job opportunities, particularly within campus environments. The platform aims to enable seamless, secure peer-to-peer payments and foster community engagement by making value exchange frictionless and opportunities easily discoverable.  





Core Problem Addressed: Fragmentation in micro-task marketplaces, complex payment flows for small tasks, underutilized student availability, and inefficient hyperlocal task discovery.  

Target Audience: College students seeking flexible income, individuals needing help with small tasks, and local businesses requiring short-term assistance.  

2. Technical Architecture & Stack

Primary Framework: Flutter (SDK Version specified in android/local.properties, Dart Language [cite: , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , 75, 158])

Architecture Style: Clean Architecture principles are advised, with a feature-first project structure observed (lib/features/auth/, lib/features/tasks/, etc.). Data handling utilizes Repositories (AuthRepository, ChatRepository, NotificationRepository, PaymentRepository, TasksRepository) interacting with data sources (Supabase).  

State Management: Flutter Riverpod (flutter_riverpod package) is implemented across features using StateNotifierProvider and Provider (e.g., authProvider, chatProvider, notificationProvider, paymentProvider, tasksProvider).

Backend: Supabase (supabase_flutter package) serves as the primary backend service [cite: , , 158]. Configuration (URL, Anon Key) is placeholder in lib/shared/config/supabase_config.dart.

Real-time Services: Firebase is used for:Authentication (firebase_auth mentioned as an option)  



Cloud Firestore (cloud_firestore mentioned as an option)  



Push Notifications (firebase_messaging package implemented) [cite: , ]

Cloud Storage (firebase_storage mentioned for image uploads)  

Navigation: GoRouter (go_router package) manages app navigation and redirection based on authentication state [cite: , , ].

Database:Primary: Supabase (likely PostgreSQL backend)

Secondary/Optional: Cloud Firestore  



Local: flutter_secure_storage [cite: , , , , , , 160], shared_preferences [cite: , , , , 158], sqflite (iOS/macOS implementation present [cite: , ], mentioned as option ), hive (mentioned as option ).  





3. Core Features & Modules

(Details extracted from lib/features/ code and supporting documents)



Authentication:Email/Password sign-up (AuthRepository.signUp) and sign-in (AuthRepository.signIn) using Supabase Auth.

User session management via authProvider monitoring Supabase auth state.

UI screens for Login (login_screen.dart) and Registration (register_screen.dart) [cite: , ].

Password reset functionality mentioned (auth_provider.dart has methods like sendPasswordResetEmail).

Social login options (Google, Facebook) are present in the UI (login_screen.dart) and mentioned in planning documents [cite: , 76, 131].

Biometric authentication via local_auth package is included [cite: , 160].

Student ID verification planned.  



Task Management:Model: TaskModel defines task attributes (ID, title, description, creator/assignee IDs, amount, timestamps, status, location, tags). Statuses include Open, InProgress, Completed, Cancelled.

Repository: TasksRepository handles fetching, creating, updating, streaming, and filtering tasks via Supabase. Includes filtering by status, amount range, and potentially location (though location filtering implementation needs verification).

State: tasksProvider manages task lists, loading states, errors, and applied filters (TaskFilter) [cite: , ].

UI:task_list_screen.dart: Displays tasks using TaskCard, includes refresh, filtering (via TaskFilterDialog), and navigation to create/detail screens.

create_task_screen.dart: Form for creating new tasks with validation for title, description, amount, and deadline selection [cite: , 91, 92, 93, 94, 95].

task_detail_screen.dart: Shows comprehensive task details and provides options to apply (updating task status and assignee) or navigate to chat.

Categories: Predefined categories like Academic Support, Campus Errands, Tech Help, etc., are listed in documentation.  



Payments:Model: PaymentModel tracks payment details (ID, task ID, payer/payee IDs, amount, status, transaction ID, timestamps, failure reason). Statuses include Pending, Processing, Completed, Failed.

Repository: PaymentRepository uses upi_india package to fetch available UPI apps and initiate transactions. It creates a payment record in Supabase, starts the UPI transaction, and updates the record based on the UPI response. Uses a placeholder UPI ID (merchant@upi).

State: paymentProvider manages loading UPI apps, initiating payments, and tracking the current payment state.

UI: payment_screen.dart displays task amount, lists available UPI apps for selection, and initiates the payment flow.

Other Gateways: Razorpay and Stripe mentioned as possibilities.  





Chat & Communication:Model: ChatMessage defines message structure (ID, task ID, sender/receiver IDs, message content, timestamp, read status).

Repository: ChatRepository handles sending messages and streaming messages for a specific task ID from Supabase. Includes marking messages as read.

State: chatProvider (family provider based on taskId) manages the stream of messages for a chat.

UI: chat_screen.dart provides the chat interface using flutter_chat_ui widgets, displaying messages and allowing users to send new messages within the context of a task.

Notifications:Model: NotificationModel / shared/models/notification_model.dart defines notification details (ID, user ID, title, message, type, task ID, timestamp, read status) [cite: , ]. Types include TaskCreated, TaskAssigned, PaymentReceived, NewMessage, TaskCompleted.

Repository: NotificationRepository streams notifications for a user from Supabase and marks notifications as read.

Service: NotificationService initializes and handles Firebase Messaging (background/foreground messages) and triggers local notifications (flutter_local_notifications).

State: notificationProvider manages the list of notifications, loading state, and errors.

UI: notification_screen.dart displays a list of notifications using NotificationTile, showing icons based on type and indicating read status.

User Profiles:Model: UserModel defines user attributes (ID, email, full name, avatar URL, phone, verification status).

Profile data is fetched and potentially updated via AuthRepository interacting with the 'profiles' Supabase table.

UI mentioned in documentation (profile_screen.dart code snippets) including stats, skills, and reviews.  

Location Services:Uses Maps_flutter for map display [cite: , 76, 87, 158].

Dependencies like geolocator, geocoding mentioned for location fetching and handling. Code snippets show intent to get current location and calculate distances.  











4. Platform Support & Configuration

Cross-Platform Build: Flutter enables building for Android, iOS, Web, Windows, macOS, and Linux, with dedicated setup files present for each.

Android:Min SDK, Target SDK, Version Code/Name configured in app/build.gradle.kts.

Application ID: dev.vpay.vpay_flutter.

Permissions: INTERNET permission is standard [cite: , ]. PROCESS_TEXT query added.

Plugins Registered: app_links, firebase_core, firebase_messaging, flutter_local_notifications, flutter_secure_storage, Maps_flutter_android, image_picker_android, local_auth_android, path_provider_android, pay_android, qr_code_scanner, shared_preferences_android, sqflite_android, upi_india, url_launcher_android.

Gradle Version: 8.10.2.

iOS:Plugins Registered: app_links, firebase_core, firebase_messaging, flutter_local_notifications, flutter_secure_storage, Maps_flutter_ios, image_picker_ios, local_auth_darwin, path_provider_foundation, pay_ios, qr_code_scanner, shared_preferences_foundation, sqflite_darwin, url_launcher_ios.

Build settings configured via Xcode project files and flutter_export_environment.sh.

Web: Basic setup with index.html and manifest.json [cite: , ].

Windows:Uses CMake build system [cite: , , ].

Plugins Registered: app_links, file_selector_windows, firebase_core, flutter_secure_storage_windows, local_auth_windows, url_launcher_windows.

Runner implements Win32Window for hosting the Flutter view [cite: , ].

macOS:Uses CMake build system and Swift for runner [cite: , ].

Plugins Registered: app_links, file_selector_macos, firebase_core, firebase_messaging, flutter_local_notifications, flutter_secure_storage_macos, local_auth_darwin, path_provider_foundation, shared_preferences_foundation, sqflite_darwin, url_launcher_macos.

Linux:Uses CMake build system and C++ for runner [cite: , , ].

Application ID: dev.vpay.vpay_flutter.

Plugins Registered: file_selector_linux, flutter_secure_storage_linux, gtk, url_launcher_linux.

5. UI/UX & Design

Design System: Material Design 3 (uses-material-design: true in pubspec.yaml, ThemeData(useMaterial3: true) in app_theme.dart [cite: , ]). Cupertino widgets mentioned as option for iOS styling.  

Theming: Custom light and dark themes defined in lib/shared/theme/app_theme.dart using colors from lib/shared/theme/app_colors.dart [cite: , ]. Supports system theme mode.

Fonts: Custom fonts (Poppins, Righteous) configured in pubspec.yaml.

Key UI Packages: cached_network_image for image handling, shimmer for loading states, flutter_chat_ui for messaging interface [cite: , 77, 158].

Responsive Design: Planning documents mention using MediaQuery, LayoutBuilder, and flutter_screenutil.  



6. Development & Operations

Version Control: Git is standard. Branching strategy (main, develop, feature branches) recommended.  

Code Quality: flutter_lints package used for static analysis, configured in analysis_options.yaml.

Dependencies: Managed via pubspec.yaml. Key libraries listed in previous documentation.

Testing:Strategies outlined: Unit, Widget, and Integration tests for Flutter; Backend testing (Jest/Supertest for Node, Pytest for Python); API testing (Postman); Physical device testing (Firebase Test Lab).  





Basic test files present for iOS (RunnerTests.swift) and macOS (RunnerTests.swift) [cite: , ].

CI/CD: GitHub Actions and Codemagic mentioned as potential tools.  

Deployment: Standard procedures for App Store and Google Play outlined in documentation.  





7. Future Roadmap & Potential

(Based on vPay Task Categories and Future Development Roadmap.pdf)



Feature Enhancements: Scheduled/recurring tasks, task bundles, skill-based matching, advanced messaging, dispute resolution, multiple payment methods, tipping, enhanced verification, task templates.  

Community Building: Group/department task boards, verified locations, community ratings/leaderboards, task teams.  

Expansion: Multi-campus networks, neighborhood/city-wide expansion.  

Enterprise Solutions: Business accounts, bulk task posting, verified business status, subscription packages, recruitment integration.  

Advanced Tech: AI task matching, automated scheduling, voice commands, task insurance.  

Monetization Expansion: Business subscriptions, verification badges, urgent task fees, insurance, data insights, API access, white-labeling.

Primary Brand Colors:

Primary: #001C3C
Primary Dark: #001428
Primary Light: #002B5C
Secondary Brand Colors:

Secondary: #50EDFE
Secondary Dark: #00D6E9
Secondary Light: #7FF4FF
Accent Colors:

Accent: #2F89FC
Accent Dark: #1877F2
Link Blue: #2F89FC
Status Colors:

Success: #00C853
Warning: #FFB300
Error: #FF3D00
Info: #2196F3
Light Theme Colors:

Background: #F8F9FA
Surface: #FFFFFF (white)
Text Primary: #1A1A1A
Text Secondary: #757575
Divider: #E0E0E0
Dark Theme Colors:

Background: #121212
Surface: #1E1E1E
Text Primary: #FFFFFF (white)
Text Secondary: #B3B3B3
Divider: #323232
Opacity Colors (Black):

Black 05: #0D000000
Black 10: #1A000000
Black 20: #33000000
Black 50: #80000000
Black 70: #B3000000
Black 80: #CC000000
Opacity Colors (White):

White 05: #0DFFFFFF
White 10: #1AFFFFFF
White 20: #33FFFFFF
White 50: #80FFFFFF
White 70: #B3FFFFFF
White 80: #CCFFFFFF





App Blueprint
Authentication — Email/Password (Supabase Auth), Social Login (UI present), Biometric (local_auth), Password Reset, Planned: Student ID Verification.
Task Management — Task Model (Open, InProgress, Completed, Cancelled), TasksRepository (Supabase), tasksProvider (Riverpod), UI (task_list, create_task, task_detail), Categories defined.
Payments — Payment Model (Pending, Processing, Completed, Failed), PaymentRepository (upi_india - placeholder UPI ID), paymentProvider (Riverpod), UI (payment_screen), Potential: Razorpay, Stripe.
Chat & Communication — ChatMessage Model, ChatRepository (Supabase), chatProvider (Riverpod - family), UI (flutter_chat_ui).
Notifications — Notification Model, NotificationRepository (Supabase), NotificationService (Firebase Messaging, local notifications), notificationProvider (Riverpod), UI (notification_screen).
User Profiles — UserModel, Profile data via AuthRepository/Supabase 'profiles' table, UI mentioned (profile_screen).
Location Services — maps_flutter, geolocator/geocoding mentioned.
Color
9+
Layout
Planning to use MediaQuery, LayoutBuilder, flutter_screenutil.
Typography
Fonts: Poppins, Righteous (configured in pubspec.yaml).