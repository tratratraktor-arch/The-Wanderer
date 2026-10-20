@echo off
chcp 65001 >nul
title Обновление бота SGL
set SERVER=root@45.141.177.182
set TMPF=%TEMP%\sgl_bot_upload.py

echo Ищу самый свежий bot*.py в папке Загрузки...
powershell -NoProfile -Command "$f = Get-ChildItem -Path \"$env:USERPROFILE\Downloads\" -Filter 'bot*.py' | Sort-Object LastWriteTime -Descending | Select-Object -First 1; if (-not $f) { exit 1 }; Copy-Item $f.FullName $env:TEMP\sgl_bot_upload.py -Force; Write-Host ('Найден: ' + $f.Name + ' от ' + $f.LastWriteTime)"
if errorlevel 1 (
  echo Файл bot.py не найден в папке Загрузки. Скачай его из чата и запусти снова.
  pause
  exit /b 1
)

echo.
echo Отправляю на сервер (введи пароль root)...
scp "%TMPF%" %SERVER%:/opt/sglbot/bot.py
if errorlevel 1 (
  echo Не удалось отправить файл.
  pause
  exit /b 1
)

echo.
echo Перезапускаю бота (введи пароль root ещё раз)...
ssh %SERVER% "systemctl restart sglbot && sleep 5 && systemctl is-active sglbot && journalctl -u sglbot --since '1 minute ago' --no-pager | tail -5"

echo.
echo Готово. Если выше написано active - бот работает.
pause
