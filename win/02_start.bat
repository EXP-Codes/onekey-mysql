@echo off

:: 获取 Mysql 服务名
set /p SVC_NAME=<_svcname

:: 启动 Mysql 服务
echo Starting %SVC_NAME% service...
net start %SVC_NAME%

if %errorlevel% == 0 (
    echo %SVC_NAME% service started successfully.
) else (
    echo Failed to start %SVC_NAME% service.
)
pause