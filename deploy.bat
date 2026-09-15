@echo off
setlocal

set "DEST=C:\Sandbox\game-enjoy"
set "SRC=C:\Sandbox\UchiInu\game-enjoy_BUILD"

echo === 古いビルドファイルを削除 ===

if exist "%DEST%\Build" (
    rmdir /S /Q "%DEST%\Build"
)

if exist "%DEST%\HelloWorldNovelGame\_BurstDebugInformation_DoNotShip" (
    rmdir /S /Q "%DEST%\HelloWorldNovelGame\_BurstDebugInformation_DoNotShip"
)

if exist "%DEST%\TemplateData" (
    rmdir /S /Q "%DEST%\TemplateData"
)

if exist "%DEST%\index.html" (
    del /F /Q "%DEST%\index.html"
)

echo.
echo === 新しいビルドを移動 ===

robocopy "%SRC%" "%DEST%" /E /MOVE /R:1 /W:1

if errorlevel 8 (
    echo.
    echo ビルドファイルの移動に失敗しました。
    pause
    exit /b 1
)

echo.
echo === Git 更新 ===

cd /D "%DEST%"

git add -A

git diff --cached --quiet
if %errorlevel%==0 (
    echo Gitに変更はありません。
    pause
    exit /b 0
)

git commit -m "WebGL build update"

if errorlevel 1 (
    echo Git commit に失敗しました。
    pause
    exit /b 1
)

git push

if errorlevel 1 (
    echo Git push に失敗しました。
    pause
    exit /b 1
)

echo.
echo === 完了 ===
pause
