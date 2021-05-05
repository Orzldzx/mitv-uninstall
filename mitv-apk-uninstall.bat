@echo off


@rem 进入脚本所在目录
cd /d %~dp0


set /a conn=0
set /p ipaddr=please input connect HOST[:PORT]: 


:main
cls
echo please choose execution:
echo    1.  connect host
echo    2.  list APK
echo    3.  install APK
echo    4.  start APK
echo    5.  kill app process
echo    6.  clear App
echo    7.  uninstall APK
echo    0.  exit

set /p choose=please input choose: 
if %choose%==1 goto connect
if %choose%==2 goto list
if %choose%==3 goto install
if %choose%==4 goto startapp
if %choose%==5 goto killapp
if %choose%==6 goto clearapp
if %choose%==7 goto uninstall
if %choose%==0 goto close
pause


:connect
@rem 连接
adb connect %ipaddr%:5555
if %errorlevel% == 0 (
    set /a conn=1
    echo ----------%ipaddr% connect success
    adb devices
) else (
    echo ----------%ipaddr% connect failure
)
pause
goto main


:list
@rem 查看所有apk
setlocal enabledelayedexpansion
if not %conn% == 1 (
    goto connect
)
adb shell pm list packages
endlocal
pause
goto main


:install
@rem 设置apk路径
setlocal enabledelayedexpansion
set /p apk_path=input apk_path:
if not exist %apk_path% (
    echo %apk_path% not exist!
)
if not %conn% == 1 (
    goto connect
)
adb install -r -t %apk_path%
echo ----------%apk_path% install success
endlocal
pause
goto main


:startapp
@rem 启动apk
setlocal enabledelayedexpansion
set /p apk_intent=input apk_intent:
if not %conn% == 1 (
    goto connect
)
adb shell am start -n %apk_intent%
echo ----------%apk_package% start success
endlocal
pause
goto main


:killapp
@rem 强制停止apk
setlocal enabledelayedexpansion
set /p apk_package=input apk_package:
if not %conn% == 1 (
    goto connect
)
adb shell am force-stop %apk_package%
echo ----------%apk_package% kill app success
endlocal
pause
goto main


:clearapp
@rem 清理apk数据
setlocal enabledelayedexpansion
set /p apk_package=input apk_package:
if not %conn% == 1 (
    goto connect
)
adb shell pm clear %apk_package%
echo ----------%apk_package% clear app success
endlocal
pause
goto main


:uninstall 
@rem 卸载apk
setlocal enabledelayedexpansion
if not %conn% == 1 (
    goto connect
)
for /f "eol=# tokens=1 delims= " %%i in (%~dp0mitv-apk-list.txt) do (
    adb uninstall %%i
    :: adb shell pm uninstall --user 0 %%i
    echo ----------%%i uninstall app success
)
endlocal
pause
goto main


:close
@rem 断开连接
setlocal enabledelayedexpansion
if %conn% == 1 (
    adb disconnect %ipaddr%:5555
    echo ----------%ipaddr% disconnect success
)
echo 按任意键退出. . . && pause > nul
endlocal
exit
