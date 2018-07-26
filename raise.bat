:Main
@echo off
set VERSION=1.0.0
setlocal EnableDelayedExpansion

set "java=java"
set /a bit = 32
set /a count = 0
if exist "%ProgramFiles(x86)%" set /a bit = 64
cls

echo x%bit%   %~dp0

if not exist "raise-setting.txt" (
	echo WARN  Setting file not found. create a new one.
	call :Save
) else (
	echo INFO  Setting file found.
	
	set /a count=0
	
	for /f "Tokens=1-4 Delims=," %%L in ('findstr /n "^" "raise-setting.txt"') do (
		set /a count=count+1
		
		set "line=%%L"
		set "line=!line:*:=!"
		if !count! == 1 if defined line (
			echo INFO  Jar setting found.
			set "jar_file=!line!"
		)
		if !count! == 2 if defined line (
			set "temp_ram="&for /f "delims=0123456789" %%i in ("!line!") do set temp_ram=%%i
			if defined !temp_ram! (
				echo WARN  RAM value `!line!` is not a number. resetting to default value.
				set /a ram=2
				call :Save
			) else (
				echo INFO  RAM setting found.
				set /a "ram=!line!"
			)
		)
		if !count! == 3 if defined line (
			echo INFO  Java setting found.
			set "java_path=!line!"
		)
		if !count! == 4 if defined line (
			echo INFO  Java argument setting found.
			set "java_args=!line!"
		)
	)
)

:Menu
echo.

title RAISE v%VERSION%
echo INFO  Ranol's Advanced Interactive Server Executor : v%VERSION%

cls
if not exist "%jar_file%" (
  if defined jar_file (
    echo WARN  Jar file is not valid. Select a new one.
  ) else (
    echo INFO  Jar file not selected. Select a new one.
  )
  call :ConfigureJar
)

echo INFO  Jar file  : %jar_file%
if not defined ram (
  echo INFO  RAM not configured.
  call :ConfigureRam
)

echo INFO  RAM       : !ram! GB
if not defined java_path (
  echo INFO  Java not configured.
  call :ConfigureJava
)

echo INFO  Java      : !java_path!
if defined java_args (
  echo INFO  Java Args : !java_args!
)

echo.
echo 忙式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo 弛 RAISE %VERSION%
echo 戍式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo 弛 
echo 弛 1. Start Server
echo 弛 
echo 弛 2. Configure Jar
echo 弛 
echo 弛 3. Configure RAM
echo 弛 
echo 弛 4. Configure Java
echo 弛 
echo 弛 5. Configure Java Arguments
echo 弛 
echo 弛 6. Exit
echo 弛 
echo 戌式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
set /p "selection=Select > "
cls
if %selection% == 1 (
  call :StartServer
) else if %selection% == 2 (
  call :ConfigureJar
) else if %selection% == 3 (
  call :ConfigureRam
) else if %selection% == 4 (
  call :ConfigureJava
) else if %selection% == 5 (
  call :ConfigureJavaArgument
) else if %selection% == 6 (
  exit /b
) else (
  echo Please select one of 1, 2, 3, 4, 5, and 6
)
cls
goto Menu

:ConfigureJar
echo 忙式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo 弛 Select one of following jar files.
echo 戍式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
for /f "tokens=*" %%a in ('dir /B /O') do (
	set temp_file=%%a
	if "!temp_file:~-4!" == ".jar" (
		echo 弛 !temp_file!
	)
)
echo 戌式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
call :Loop-ConfigureJar
goto :EOF

:Loop-ConfigureJar
set /p "jar_file=Type a name of file > "

if not exist "!jar_file!" (
	echo WARN  Please type existing file.
	goto Loop-ConfigureJar
)
if not "!jar_file:~-4!" == ".jar" (
	echo WARN  Please type a jar file.
	goto Loop-ConfigureJar
)
echo INFO  Jar file selected.
echo INFO  Save the setting...
call :Save
goto :EOF

:ConfigureRam
echo 忙式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo 弛 Configure RAM
echo 戍式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo 弛 

set /a count=0
for /f %%L in ('wmic computersystem GET TotalPhysicalMemory') do (
	set /a count=count+1
	
	set "line=%%L"
	set "line=!line:*:=!"

	if !count! == 2 if defined line (
		set "temp_ram="&for /f "delims=0123456789" %%i in ("!line!") do set temp_ram=%%i
		if defined !temp_ram! (
			echo 弛 Your Physical RAM : Unknown
			set /a physical_ram=-1
		) else (
			set /a "physical_ram=!line:~0,-9!"
			
			echo 弛 Your Physical RAM : About !physical_ram! GB
		)
	)
)
echo 弛 
if !physical_ram! gtr 0 (
	echo 弛 Enter that you want to use physical RAM less than !physical_ram! GB
) else (
	echo 弛 Enter that you want to use physical RAM.
)
echo 戌式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
call :Loop-ConfigureRam
goto :EOF
 
:Loop-ConfigureRam
set /p "temp_ram=Type a RAM value > "
set "temp_ram2="&for /f "delims=0123456789" %%i in ("%temp_ram%") do set temp_ram2=%%i
if defined temp_ram2 (
	echo WARN  Please type a numeric characters.
	goto Loop-ConfigureRam
)
set /a temp_ram=temp_ram
if !physical_ram! gtr 0 if %temp_ram% gtr !physical_ram! (
	echo WARN  Please type a valid value, maximum : !physical_ram! GB
	goto Loop-ConfigureRam
)
if %temp_ram% leq 0 (
	echo WARN  Please type a valid value, minimum : 1 GB
	goto Loop-ConfigureRam
)
set /a ram=%temp_ram%
echo INFO  RAM configured.
call :Save
goto :EOF

:ConfigureJava
echo 忙式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo 弛 Configure Java
echo 戍式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo 弛 1. Search Java in default directory
if %bit% == "32" (
  echo 弛 (in `%ProgramFiles%`)
) else (
  echo 弛 (in `%ProgramFiles%` and `%ProgramFiles(x86)%`)
)
echo 弛 
echo 弛 2. Use my input as path of Java
echo 戌式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
call :Loop-ConfigureJava
goto :EOF

:Loop-ConfigureJava
set /p "selection=Select > "
if %selection% == 1 (
  call :ConfigureJava-Default
) else if %selection% == 2 (
  call :ConfigureJava-Specific
) else (
  echo Please select 1 or 2
  goto Loop-ConfigureJava
)
goto :EOF

:ConfigureJava-Default
if not exist "%ProgramFiles%\Java" if not exist "%ProgramFiles(x86)%\Java" (
  echo Java not installed
  echo Please install Java via choose one of following links
  echo.
  echo.
  echo # Oracle JRE 10.0.2
  echo http://www.oracle.com/technetwork/java/javase/downloads/jre10-downloads-4417026.html
  echo.
  echo # Oracle JDK 10.0.2
  echo http://www.oracle.com/technetwork/java/javase/downloads/jdk10-downloads-4416644.html
  echo.
  echo # Oracle JRE 8u181
  echo http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html
  echo.
  echo # Oracle JDK 8u181
  echo http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
  echo.
  echo # Open JDK 10
  echo http://jdk.java.net/java-se-ri/10
  echo.
  echo # Open JDK 9
  echo http://jdk.java.net/java-se-ri/9
  echo.
  echo # Open JDK 8
  echo http://jdk.java.net/java-se-ri/8
  echo.
  echo # Open JDK 7
  echo http://jdk.java.net/java-se-ri/7
  goto :eof
)
echo 忙式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo 弛 Found Java executables
echo 戍式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
set x64_found=0
set x86_found=0
set /a length64=0
set /a length86=0
if exist "%ProgramFiles%\Java" (
  set x64_found=1
  if %bit% == 64 (
    echo 弛 x64
  ) else (
    echo 弛 x32
  )
  echo 戍成式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
  pushd "%ProgramFiles%\Java"
  for /f "tokens=*" %%a in ('dir /B') do (
    echo 弛弛 %%a
    set "java64[!length64!]=%%a"
    set /a "length64+=1"
  )
  popd
)
if exist "%ProgramFiles(x86)%\Java" (
  set x86_found=1
  if %x64_found% NEQ 0 (
    echo 戍扛式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
  )
  echo 弛 x86
  echo 戍成式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
  pushd "%ProgramFiles(x86)%\Java"
  for /f "tokens=*" %%a in ('dir /B') do (
    echo 弛弛 %%a
    set "java86[!length86!]=%%a"
    set /a "length86+=1"
  )
  popd
)
echo 戌扛式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
call :Loop-ConfigureJava-Default
goto :EOF

:Loop-ConfigureJava-Default
set /p "selection=Select java version > "
set /a ok=0
for /l %%i in (0, 1, !length64!) do (
  if %ok% == 0 if "%selection%" == "!java64[%%i]!" (
    echo Java set.
    set "java_path=%ProgramFiles%\Java\%selection%\bin\java.exe"
    call :Save
    set /a ok=1
  )
)
for /l %%i in (0, 1, !length86!) do (
  if %ok% == 0 if "%selection%" == "!java86[%%i]!" (
    echo Java set.
    set "java_path=%ProgramFiles(x86)%\Java\%selection%\bin\java.exe"
    call :Save
    set /a ok=1
  )
)
if %ok% == 0 (
  echo Invalid java version
  goto Loop-ConfigureJava-Default
)
goto :EOF

:ConfigureJava-Specific
echo 忙式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo 弛 Enter your custom java path (maybe it can break your server)
echo 戌式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
set /p "java_path=Enter > "
call :Save
goto :EOF

:ConfigureJavaArgument
echo 忙式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo 弛 Enter your custom java argument (maybe it can break your server)
echo 戌式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
set "input="
set /p "input=Enter > "
set java_args=%input%
call :Save
goto :EOF

:StartServer
echo INFO  Start the server
"!java_path!" !java_args! -Xmx!ram!G -jar !jar_file!
cls
goto :EOF

:Save
(
	::   Jar File
	echo.!jar_file!
	::   RAM (GB)
	echo.!ram!
	::   Java Path
	echo.!java_path!
	::   Java Argument
	echo.!java_args!
) > raise-setting.txt
goto :EOF