@echo off

:: 获取 Mysql 服务名
set /p SVC_NAME=<_svcname

:: 停止 Mysql 服务
echo Stopping %SVC_NAME% service...
net stop %SVC_NAME%

if %errorlevel% == 0 (
    echo %SVC_NAME% service stopped successfully.
) else (
    echo Failed to stop %SVC_NAME% service.
)
pause