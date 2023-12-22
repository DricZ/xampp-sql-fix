@echo off
set /p xampp="Masukkan nama folder xampp: "

echo Membersihkan isi C:\%xampp%\mysql\data_bkp
del /Q /F /S "C:\%xampp%\mysql\data_bkp\*"

echo Menyalin C:\%xampp%\mysql\data ke C:\%xampp%\mysql\data_bkp
xcopy /E /I /H /Y "C:\%xampp%\mysql\data\*" "C:\%xampp%\mysql\data_bkp"

echo Menyalin isi dari C:\%xampp%\mysql\backup ke C:\%xampp%\mysql\data
xcopy /E /I /H /Y "C:\%xampp%\mysql\backup" "C:\%xampp%\mysql\data"

echo Menyalin semua folder dan file ibdata1 dari C:\%xampp%\mysql\data_bkp ke C:\%xampp%\mysql\data
for /D %%G in ("C:\%xampp%\mysql\data_bkp\*") do (
    if not "%%~nxG"=="mysql" if not "%%~nxG"=="performance_schema" if not "%%~nxG"=="phpmyadmin" (
        xcopy /E /I /H /Y "%%G\*" "C:\%xampp%\mysql\data\%%~nxG"
    )
)
xcopy /H /Y "C:\%xampp%\mysql\data_bkp\ibdata1" "C:\%xampp%\mysql\data"

echo Membuat zip dari folder C:\%xampp%\mysql\data_bkp menggunakan PowerShell
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('C:\%xampp%\mysql\data_bkp', 'C:\%xampp%\mysql\data_bkp.zip'); }"
