@echo off

:: 获取当前目录的绝对路径
set "MYSQL_DIR=%~dp0"
set "MYSQL_DIR=%MYSQL_DIR:~0,-1%"

:: 获取 Mysql 服务名
set /p SVC_NAME=<"%MYSQL_DIR%\_svcname"

:: 卸载 Mysql 注册的服务
echo Removing %SVC_NAME% service...
net stop %SVC_NAME%
sc delete %SVC_NAME%

if %errorlevel% == 0 (
    echo %SVC_NAME% service removed successfully.
) else (
    echo Failed to remove %SVC_NAME% service.
)

pause