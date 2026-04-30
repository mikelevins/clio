@echo off
REM ************************************************************************
REM
REM Name:          make.bat
REM Project:       clio-example-howto
REM Purpose:       Windows equivalent of the Makefile
REM Author:        mikel evins
REM Copyright:     2026 by mikel evins
REM
REM ************************************************************************
REM
REM Usage:
REM   make.bat                       (default: build)
REM   make.bat build
REM   make.bat refresh-clio-assets
REM   make.bat clean
REM
REM Variables (set in the environment before invoking):
REM   CLIO_DIR -- path to the Clio repository checkout. Default: ..\..
REM   LISP     -- name of the Lisp implementation. Default: sbcl
REM ************************************************************************

setlocal

if not defined CLIO_DIR set CLIO_DIR=..\..
if not defined LISP     set LISP=sbcl

if "%~1"=="" goto build
if /i "%~1"=="build" goto build
if /i "%~1"=="refresh-clio-assets" goto refresh
if /i "%~1"=="clean" goto clean

echo Unknown target: %~1
echo Valid targets: build, refresh-clio-assets, clean
exit /b 1

:build
echo Building executable...
%LISP% --non-interactive ^
    --eval "(asdf:load-system :clio)" ^
    --eval "(setf clio:*deployment-mode* :deployed)" ^
    --eval "(asdf:load-system :clio-example-howto)" ^
    --eval "(asdf:make :clio-example-howto)"
if errorlevel 1 exit /b %errorlevel%
echo Assembling deploy bundle...
if exist deploy rmdir /s /q deploy
mkdir deploy\public\clio
move howto.exe deploy\ >nul
xcopy /e /i /q public\css deploy\public\css >nul
xcopy /e /i /q "%CLIO_DIR%\public" deploy\public\clio >nul
echo Done.
echo Deploy bundle: deploy\
echo Run with:      cd deploy ^&^& howto.exe
goto :eof

:refresh
echo Refreshing public\clio from %CLIO_DIR%\public...
if exist public\clio rmdir /s /q public\clio
mkdir public\clio
xcopy /e /i /q "%CLIO_DIR%\public" public\clio >nul
echo Done.
goto :eof

:clean
if exist howto.exe del /q howto.exe
if exist howto del /q howto
if exist deploy rmdir /s /q deploy
goto :eof
