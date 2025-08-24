@echo off
REM Script para restaurar la carpeta data de XAMPP

REM Definir rutas
SET XAMPP_PATH=C:\xampp
SET DATA_PATH=%XAMPP_PATH%\mysql\data
SET BACKUP_PATH=%XAMPP_PATH%\mysql\backup

REM Crear un timestamp para backup
for /f "tokens=1-4 delims=/: " %%a in ("%date% %time%") do (
    set TIMESTAMP=%%c%%b%%a_%%d%%e%%f
)

REM 1. Renombrar la carpeta data actual
echo Renombrando carpeta data...
ren "%DATA_PATH%" "data_bk_%TIMESTAMP%"

REM 2. Copiar la carpeta backup a una nueva carpeta data
echo Restaurando backup...
xcopy /E /I "%BACKUP_PATH%" "%DATA_PATH%"

REM 3. Copiar el archivo ibdata1 de la carpeta data antigua
echo Restaurando ibdata1...
copy "%XAMPP_PATH%\mysql\data_bk_%TIMESTAMP%\ibdata1" "%DATA_PATH%\ibdata1"

REM 4. Copiar carpetas de proyectos, omitiendo mysql, test, phpmyadmin y performance_schema
echo Copiando bases de datos de proyectos...
for /D %%D in ("%XAMPP_PATH%\mysql\data_bk_%TIMESTAMP%\*") do (
    if /I not "%%~nD"=="mysql" (
    if /I not "%%~nD"=="test" (
    if /I not "%%~nD"=="phpmyadmin" (
    if /I not "%%~nD"=="performance_schema" (
        xcopy /E /I "%%D" "%DATA_PATH%\%%~nD"
    ))))
)

echo Restauración completada.
pause
