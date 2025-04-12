@echo off
REM Create feature directories
mkdir lib\features\auth\data
mkdir lib\features\auth\presentation\screens
mkdir lib\features\auth\presentation\providers

mkdir lib\features\tasks\data
mkdir lib\features\tasks\presentation\screens
mkdir lib\features\tasks\presentation\providers

mkdir lib\features\chat\data
mkdir lib\features\chat\presentation\screens
mkdir lib\features\chat\presentation\providers

REM Create shared directories
mkdir lib\shared\models
mkdir lib\shared\widgets
mkdir lib\shared\utils

REM Create feature files
echo. > lib\features\auth\data\auth_repository.dart
echo. > lib\features\auth\presentation\screens\login_screen.dart
echo. > lib\features\auth\presentation\screens\register_screen.dart
echo. > lib\features\auth\presentation\providers\auth_provider.dart

echo. > lib\features\tasks\data\tasks_repository.dart
echo. > lib\features\tasks\presentation\screens\task_list_screen.dart
echo. > lib\features\tasks\presentation\screens\task_detail_screen.dart
echo. > lib\features\tasks\presentation\providers\tasks_provider.dart

echo. > lib\features\chat\data\chat_repository.dart
echo. > lib\features\chat\presentation\screens\chat_screen.dart
echo. > lib\features\chat\presentation\providers\chat_provider.dart

REM Create shared files
echo. > lib\shared\models\user_model.dart
echo. > lib\shared\models\task_model.dart
echo. > lib\shared\widgets\loading_button.dart
echo. > lib\shared\utils\constants.dart

REM Create root files
echo. > lib\app.dart