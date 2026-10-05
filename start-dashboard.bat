@echo off
title AI Workflow dashboard
cd /d "%~dp0"
python dashboard\server.py
if errorlevel 1 pause
