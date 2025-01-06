@echo off

:: 获取当前目录的绝对路径
set "MYSQL_DIR=%~dp0"
set "MYSQL_DIR=%MYSQL_DIR:~0,-1%"

:: 获取 Mysql 服务名
set /p SVC_NAME=<"%MYSQL_DIR%\_svcname"

:: 启动 Mysql 服务
echo Starting %SVC_NAME% service...
net start %SVC_NAME%

if %errorlevel% == 0 (
    echo %SVC_NAME% service started successfully.
) else (
    echo Failed to start %SVC_NAME% service.
)
pause