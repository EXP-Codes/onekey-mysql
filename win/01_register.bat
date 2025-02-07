@echo off
setlocal enabledelayedexpansion

:: 获取当前目录的绝对路径
set "MYSQL_DIR=%~dp0"
set "MYSQL_DIR=%MYSQL_DIR:~0,-1%"

:: 获取 Mysql 服务名
set /p SVC_NAME=<"%MYSQL_DIR%\_svcname"


:: ================================
:: 1. 检查 MySQL 服务是否已注册
:: ================================
sc query %SVC_NAME% >nul 2>&1
if !errorlevel! == 0 (
    echo MySQL service %SVC_NAME% is already installed.
    pause
    exit /b

) else (
    echo MySQL service %SVC_NAME% has not installed.
)


:: ================================
:: 2. 备份并重新生成 my.ini
:: ================================
echo Recreate my.ini ...

:: 2.1. 设置字符集： chs简中，cht繁中，en英文
echo Please select the database character set:
echo 0. Exit
echo 1. UTF-8 (default)
echo 2. GBK (chs)
echo 3. big5 (cht)
echo 4. latin1 (en)
set /p CHARSET="Enter your choice (0-4) [default is 1]: "

if "!CHARSET!"=="" set CHARSET=1

if "!CHARSET!"=="0" (
    echo Exiting installation.
    pause
    exit /b
)
if "!CHARSET!"=="1" set CHARSET=utf8mb4
if "!CHARSET!"=="2" set CHARSET=gbk
if "!CHARSET!"=="3" set CHARSET=big5
if "!CHARSET!"=="4" set CHARSET=latin1

:: 2.2. 取当前日期和时间作为备份文件后缀
for /f "tokens=1-6 delims=/: " %%a in ("!date! !time!") do (
    set "year=%%a"
    set "month=%%b"
    set "day=%%c"
    set "week=%%d"
    set "hour=%%e"
    set "minute=%%f"
)
set "datetime=%year%%month%%day%%hour%%minute%"

:: 2.3. 使用模板 my.tpl.ini 重新生成 my.ini
SET "TEMPLATE_FILE=%MYSQL_DIR%\my.tpl.ini"
set "MY_INI=%MYSQL_DIR%\my.ini"
if exist "!MY_INI!" (
    echo Backing up existing my.ini to my.ini.!datetime!
    copy "!MY_INI!" "%MYSQL_DIR%\my.ini.!datetime!"
)
del "!MY_INI!" 2>nul

for /f "tokens=*" %%i in ('type "%TEMPLATE_FILE%"') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    set "line=!line:{MYSQL_DIR}=%MYSQL_DIR%!"
    set "line=!line:{CHARSET}=%CHARSET%!"
    >> "%MY_INI%" echo(!line!
    endlocal
)

:: ================================
:: 3. 重新注册 MySQL 服务（需依赖新的 my.ini）
:: ================================

:: 检查 data 目录是否存在且不为空
if exist "%MYSQL_DIR%\data\ibdata1" (
    echo Data directory is not empty.

    :: 重新注册 MySQL 服务
    echo Only Registering MySQL service...
    "%MYSQL_DIR%\bin\mysqld" --install %SVC_NAME%
    pause
    exit /b

) else (

:: ================================
:: 4. 重新初始化 MySQL 服务（需依赖新的 my.ini）
:: ================================
    echo Data directory is empty, init now ...
)

:: 4.1 初始化 data 目录（无密码初始化）
"%MYSQL_DIR%\bin\mysqld" --initialize-insecure --console

:: 4.2. 注册 MySQL 服务
"%MYSQL_DIR%\bin\mysqld" --install %SVC_NAME%

:: 4.3. 启动 MySQL 服务
net start %SVC_NAME%


:: ================================
:: 5. 重设 root 用户密码
:: ================================
set /p ROOT_PWD="Please enter a new password for the MySQL 'root' user: "
"%MYSQL_DIR%\bin\mysqladmin" -u root password !ROOT_PWD!

echo MySQL service %SVC_NAME% installed and root password set successfully.

endlocal
pause

