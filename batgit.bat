@echo off&title GIT������&color 0F
rem ���ע��
rem 1.���Ƶ��䲻����Ļ�ϳ��֣������ְ취�� 1.���ǰ��@���� @cd / 2.����� >nul �� >nul 2>nul
rem 2.bat��set�������if�������� ������������bai���ӳ�setlocal enabledelayedexpansion ���ѵ��õı���%toos%�ĳ�!toos! ������Ϊ��du�����zhi������ִ��set�����Լ���������ʱ���Ͳ���dao�ðٷֺ��ˣ�����ȿ������������ӳ٣�Ȼ��ѰٷֺŻ��ɸ�̾�š���


rem cmd /k "cd /d %code_path% & git pull"

setlocal enabledelayedexpansion
rem ����
cls
rem ���ñ���
set LESSCHARSET=utf-8
rem ��ʼ������&����
goto init
rem ��ʾ������Ϣ
goto help

:init
rem ����ͨ�ñ���
rem ��Ŀ����·��������������ȷ��������ʹ�á�
rem set code_path="E:\dnmp\www\cst-group"
set code_path="F:\batgit\batgit"
rem �Ƿ�������git��������������������ȷ��������ʹ�á�
set git_home="true"
if "%git_home%" == "true" (
	rem git.exe·��[�����û�������]
	set git_cmd="git"
) else (
	rem git.exe·��[û�����û�������]
	set git_cmd="D:\git\Git\bin\git.exe"
)
rem  �л���Ŀ·��
cd /d  %code_path%
rem goto:eof

:help
set d=%date:~0,10%
set t=%time:~0,8%
rem ��ǰʱ��
set timestamp=%d% %t%
rem �����Ŀ·��
echo ��ǰʱ�䣺%timestamp%
echo ��ǰ��Ŀ·����%code_path%
echo **************************************************************
echo *                          ������Ϣ                          *
echo *  Author��L                                                 *
echo *  Created��2020/10/10                                       *
echo **************************************************************
echo *  1: ��ȡ����                                               *
echo *  2: �ύ����                                               *
echo *  3: ��֧����                                               *
echo *  4: �ݴ����                                               *
echo *  5: ��¡��Ŀ                                               *
echo *  6: ��ǩ����                                               *
echo *  70: �鿴��־[q�˳�]                                       *
echo *  98: �鿴git�û�����                                       *
echo *  99: �޸�git�û�����                                       *
echo *  a: ����windows��Ӧ��λ��,����cmd                          *
echo *  b: ���ļ����ļ���                                       *
echo *  cmd: ���µ�cmd�����                                  *
echo **************************************************************
echo;
rem ����Ĭ��ֵ
set input=1
set /p "input=������[Ĭ��1]:"
if "%input%"==""  goto git_pull
if "%input%"=="1" goto git_pull
if "%input%"=="2" goto git_push
if "%input%"=="3" goto git_branch
if "%input%"=="4" goto ogit_stash
if "%input%"=="5" goto git_clone
if "%input%"=="6" goto git_tag
if "%input%"=="30" goto todo
if "%input%"=="70" goto git_log_list
if "%input%"=="98" goto git_user_info
if "%input%"=="99" goto git_user_update
if "%input%"=="a" goto a
if "%input%"=="b" goto b
if "%input%"=="cmd" goto cmd
goto help
goto:eof
exit


rem �ݴ����[�Ѳ���]
:git_stash
set option=0
echo 0:���ذ�����Ϣ[Ĭ��]
echo 1:�г��ݴ��б�
echo 2:����һ���ݴ���Ϣ
echo 3:�ݴ�����
echo 4:�ָ�֮ǰ����Ĺ���Ŀ¼
set /p "option=��ѡ��"
call :gotoHelp %option%
if "%option%" == "1" (
	%git_cmd% stash list
) else if "%option%" == "2" (
	%git_cmd% stash show
) else if "%option%" == "3" (
	%git_cmd% stash save stash time:%timestamp% 
) else if "%option%" == "4" (
	%git_cmd% stash pop
)
goto confirm

rem ��¡��Ŀ����[�Ѳ���]
:git_clone
set files=
set /p "files=�������¡�ļ���·����"
if "%files%" == "" (
	call :error ��¡�ļ���·������Ϊ��
)
cd /d %files%
set url=
set /p "url=�������¡��ַ��"
if "%url%" == "" (
	call :error ��¡��ַ����Ϊ��
)
%git_cmd% clone %url%
set code_path=%files%
rem ��¡���������л�·�����������г���������
echo ��ǰ·����%cd%
goto confirm

:git_pull
set option=0
echo 0:���ذ�����Ϣ[Ĭ��]
echo 1:��ȡ��ǰ��֧
echo 2:��ȡ��֧�б�[���ڴ����޸���ȡ�ķ�֧]
set /p "option=��ѡ��"
call :gotoHelp %option%
if "%option%" == "1" (
	%git_cmd% pull
)
if "%option%" == "2" (
	rem ��ɺ��л���֧
	rem set current_branch=dev_ca_v1.0.0
	set current_branch=main
	rem ��Ҫ���µķ�֧�б�
	rem set pull_branch=dev_ca_v1.0.0 dev_v1.0.0
	set pull_branch=main,test2
	set option=0
	echo 0:���ذ�����Ϣ[Ĭ��]
	echo 1:��ȡ!pull_branch!����,�л���!current_branch!��֧
	set /p "option=��ѡ��"
	call :gotoHelp %option%
	if "!option!" == "1" (
		for %%I in (!pull_branch!) do (
			%git_cmd% checkout %%I
			%git_cmd% pull origin %%I
			if not !errorlevel!==0 (
				rem �ɹ��򷵻�0
				call :error ��ͻ��
			)
		)
		rem �������л���֧
		%git_cmd% checkout !current_branch!
	)
) 
goto confirm

rem ���ʹ���[�Ѳ���]
:git_push
set option_stash=1
echo 1:��stash�ݴ���룬��pull[Ĭ��]
echo 2:ֱ��pull
set /p "option_stash=��ѡ��:"
rem �鿴���زֿ�ĵ�ǰ״̬
if %option_stash% == "1" %git_cmd% status
rem ������ǰ��Ŀ�ľ����޸�����
rem %git_cmd% diff
rem ���浱ǰ�Ĺ������ȣ�����ݴ����͹������ĸĶ���������
if %option_stash% == "1" %git_cmd% stash save stash time:%timestamp% 
rem ��ȡԶ�ֿ̲�����´���
%git_cmd% pull
rem �ָ����µĽ��ȵ���������������̻�ϲ�git pull�����ص�Զ�ֿ̲��еĴ��룬������̿��ܻ��г�ͻ����
rem git stash������ض��ķ�֧���л���֧��stash���ݲ��䣬���Ե���ʱҪС�ġ�git stash pop����drop��stash����Ż��Զ��ı䣬��������ʱҪע��
if %option_stash% == "1" %git_cmd% stash pop
if %errorlevel%==1 (
	call :error û���κ��޸�
)
if not %errorlevel%==0 (
	rem �ɹ��򷵻�0
	call :error �����ˣ�errorlevelΪ��%errorlevel%
)
rem ����Ĭ��ֵ
set option=1
echo 1:�ύ���и���[Ĭ��]
echo 2:�Զ����ύ�ļ���Ŀ¼
set /p "option=��ѡ��:"
if %option% == "2" (
	set files=
	set /p "files=������Ҫ�ϴ����ļ���Ŀ¼��"
	call :checkEmpty "!files!" �������������
	%git_cmd% add !files!
) else (
	rem git add -A  �ύ���б仯
	rem git add -u  �ύ���޸�(modified)�ͱ�ɾ��(deleted)�ļ������������ļ�(new)
	rem git add .  �ύ���ļ�(new)�ͱ��޸�(modified)�ļ�����������ɾ��(deleted)�ļ�
	%git_cmd% add -A
)
set msg=
set /p "msg=�����ύ��commit��Ϣ:"
call :checkEmpty "%msg%" commit��Ϣ����Ϊ��
%git_cmd% commit -m %msg%
rem �����زֿ�Ĵ������͵�Զ�̴���ֿ�
%git_cmd% push
call :checkErrorLevel %errorlevel%
goto confirm

rem ��ǩ����
:git_tag
set option=0
echo 0:���ذ�����Ϣ[Ĭ��]
echo 1:��ǩ�б�[q�˳�]
echo 2:��ǩ����
set /p "option=��ѡ��"
call :gotoHelp %option%
if "%option%" == "1" (
	goto git_tag_list
) else if "%option%" == "2" (
	goto todo
)

rem ��ǩ�б�
:git_tag_list
%git_cmd% tag
goto confirm

rem ��־�б�
:git_log_list
%git_cmd% log -5
goto confirm

rem ��֧����
:git_branch
set option=0
echo 0:���ذ�����Ϣ[Ĭ��]
echo 1:��֧�б�
echo 2:������֧
echo 3:�л���֧
echo 4:���ͷ�֧
echo 5:�ϲ���֧
echo 6:ɾ����֧
set /p "option=��ѡ��"
call :gotoHelp %option%
if "%option%" == "1" (
	goto git_branch_list
) else if "%option%" == "2" (
	goto git_branch_create
	%git_cmd% branch -a
) else if "%option%" == "3" (
	goto git_branch_checkout
) else if "%option%" == "4" (
	goto git_branch_push
) else if "%option%" == "5" (
	goto git_branch_merge
) else if "%option%" == "6" (
	goto git_branch_delete
)
goto confirm

:git_branch_delete
set option=0
echo 0:���ذ�����Ϣ[Ĭ��]
echo 1:ɾ�����ط�֧
echo 2:ɾ��Զ�̷�֧
set /p "option=��ѡ��"
call :gotoHelp %option%
echo ��֧�б�
if "%option%" == "1" %git_cmd% branch
if "%option%" == "2" %git_cmd% branch -r
set name=
set /p "name=������Ҫɾ���ķ�֧���ƣ�"
call :checkEmpty "%name%" ��֧���Ʋ���Ϊ��
for /F %%i in ('%git_cmd% symbolic-ref --short -q HEAD') do ( set current_branch=%%i)
if "%current_branch%" == "%name%" call :error ����ɾ����ǰ��֧
if "%option%" == "1" %git_cmd% branch -d %name%
if "%option%" == "2" %git_cmd% push origin --delete branch %name%
goto confirm

rem ������֧
:git_branch_create
set name=
set /p "name=�������֧���ƣ�"
call :checkEmpty "%name%" ��֧���Ʋ���Ϊ��
set option=0
echo 0:���ذ�����Ϣ[Ĭ��]
echo 1:������֧[���л�]
echo 2:������֧���л��������ķ�֧
set /p "option=�����룺"
call :gotoHelp %option%
if "%option%" == "0" goto help
if "%option%" == "1" %git_cmd% checkout %name%
if "%option%" == "2" %git_cmd% checkout -b %name%
%git_cmd% branch
set option_push=0
echo 0:���ذ�����Ϣ[Ĭ��]
echo 1:���ͷ�֧��Զ��
set /p "option_push=�Ƿ����ͷ�֧�������룺"
call :gotoHelp %option_push%
if "%option_push%" == "0" goto help
rem --set-upstream ����Զ�̷�֧
if "%option_push%" == "1" %git_cmd% push --set-upstream origin %name%
goto confirm

rem �л���֧
:git_branch_checkout
echo ��֧�б�
%git_cmd% branch -a
set name=
set /p "name=�������֧���ƣ�"
call :checkEmpty "%name%" ��֧���Ʋ���Ϊ��
%git_cmd% checkout %name%
goto confirm

rem ���ͷ�֧
:git_branch_push
set name=
set /p "name=�������֧���ƣ�"
call :checkEmpty "%name%" ��֧���Ʋ���Ϊ��
rem --set-upstream ����Զ�̷�֧
%git_cmd% push --set-upstream  origin %name%
goto confirm

rem ��֧�б�
:git_branch_list
set option=0
echo 0:���ذ�����Ϣ[Ĭ��]
echo 1:�г����ط�֧
echo 2:�г�Զ�̷�֧
echo 3:�г����б��ط�֧��Զ�̷�֧
echo 4:�г���ǰ��֧
set /p "option=��ѡ��"
call :gotoHelp %option%
if "%option%" == "1" (
	%git_cmd% branch
) else if "%option%" == "2" (
	%git_cmd% branch -r
) else if "%option%" == "3" (
	%git_cmd% branch -a
) else if "%option%" == "4" (
	%git_cmd% branch^ | find "*"
)  
goto confirm

rem �ϲ���֧
:git_branch_merge
echo 0:���ذ�����Ϣ[Ĭ��]
echo 1:dev_ca_v1.0.0 �ϲ��� dev_v1.0.0
echo 99:�Զ���ϲ�[Ŀ���֧�ϲ�����ǰ��֧]
set /p "option=��ѡ��"
call :gotoHelp %option%
if "%option%" == "1" (
	rem ��鹤�����Ƿ�ɾ�
	call :checkWorkingTree
	rem �ϲ���֧
	call :gitBranchMergeDo dev_ca_v1.0.0 dev_v1.0.0
) else if "%option%" == "99" (
	rem ��鹤�����Ƿ�ɾ�
	call :checkWorkingTree
	echo ��֧�б�
	%git_cmd% branch
	set /p "target_branch=������Ŀ���֧���ƣ�"
	call :checkEmpty "!target_branch!" Ŀ���֧���Ʋ���Ϊ��
	set /p "local_branch=�����뵱ǰ��֧���ƣ�"
	call :checkEmpty "!local_branch!" ��ǰ��֧���Ʋ���Ϊ��
	set option_branch=0
	echo 0:���ذ�����Ϣ[Ĭ��]
	echo 1:��!target_branch!�ϲ���!local_branch!
	set /p "option_branch=��ѡ��"
	call :gotoHelp !option_branch!
	if "!option_branch!" == "1" (
		call :gitBranchMergeDo !target_branch! !local_branch!
	) else (
		call :error ��������
	)
)  else (
	call :error ��������
)
goto confirm

::rem �ϲ���֧����һ������Ŀ���֧���ڶ���������ǰ��֧
:gitBranchMergeDo
rem �л�����һ��������֧[Ŀ���֧]
%git_cmd% checkout %1
%git_cmd% pull
if not %errorlevel%==0 (
	call :error ��ȡ���ֳ�ͻ,���ֶ����
)
rem �л����ڶ���������֧[��ǰ��֧]
%git_cmd% checkout %2
%git_cmd% pull
if not %errorlevel%==0 (
	call :error ��ȡ���ֳ�ͻ,���ֶ����
)
rem ��Ŀ���֧�ϲ�����ǰ��֧
%git_cmd% merge %1
if not %errorlevel%==0 (
	%git_cmd% status
	call :error �ϲ����ֳ�ͻ,���ֶ����
)
if %errorlevel%==0 (
	set option=0
	echo 0:���ذ�����Ϣ[Ĭ��]
	echo 1:push���ͺϲ�����,%1���ͺϲ��� %2��֧
	set /p "option=��ѡ��"
	call :gotoHelp !option!
	if "!option!" == "1" (
		%git_cmd% push
	) else (
		call :error ��������,����ʧ��,���ֶ�push����
	)
)
goto:eof

::rem ��鹤�����Ƿ�ɾ�
:checkWorkingTree
%git_cmd% diff --exit-code>nul
if not %errorlevel%==0 (
	call :error �ϲ�ǰ��֤�������ɾ�����������δ�ݴ�ĸ���
)
%git_cmd% diff --cached --exit-code>nul
if not %errorlevel%==0 (
	call :error �ϲ�ǰ��֤�������ɾ�����������δcommit���ļ�
)
rem %git_cmd% ls-files --other --exclude-standard --directory
rem if not %errorlevel%==0 (
rem 	call :error �ϲ�ǰ��֤�������ɾ�����������δ���ٵ��ļ�
rem )
goto:eof

rem ��ȡgit�û���Ϣ[�Ѳ���]
:git_user_info
echo -------�鿴git�û�-------
%git_cmd% config user.name
%git_cmd% config user.email
echo -------------------------
goto confirm

:git_user_update
echo ɾ�������exit����ִ��
rem û��֤���ܣ���ʱ��ֹ
exit
echo -------�޸�git�û���email-------
echo PS:�������û���
set /p "name="
if "%name%" == "" (
	echo �û�������Ϊ��
	exit
)
echo ������email
set /p "email="
if "%email%" == "" (
	echo email����Ϊ��
	goto confirm
)
%git_cmd% config --global user.name "%name%"
%git_cmd% config --global user.email "%email%"
echo -------------�޸ĳɹ�-------------
goto confirm

:checkEmpty
if "%1%" == "" (
	call :error "%2"
	goto confirm
	pause>nul
	exit;
)
goto:eof

:gotoHelp
if "%1%" == "" goto help
if "%1%" == "0" goto help
goto :eof

:checkErrorLevel
if not %1% == 0 (
	call :error �����ˣ�errorlevelΪ��%1%
	goto confirm
	pause>nul
	exit;
)
goto:eof

:todo
echo *******************************
echo *             δ����          *
echo *******************************
goto confirm

:confirm
echo;
call :colorText 0b "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
call :colorText 0a "[[�������]]"
set op=0
echo 0:���ذ�����Ϣ[Ĭ��]
echo 1:�˳�
echo cmd:���µ�cmd�����
set /p "op=��ѡ��"
if "%op%" == "1" (
	goto exit
) else if "%op%" == "cmd" (
	goto cmd
)
call :colorText 0b "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo;
goto help

rem call���ã�%1Ϊ����
:error
call :colorText 0C "++++++++++++++++++++++++�����˳�++++++++++++++++++++++++++++++"
echo %1
call :colorText 0C "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
goto confirm
pause>nul
exit;

:exit
rem �˳�
exit;

:cmd
rem ��cmd����
start cmd /k echo %cd%
goto help

rem ����������ɫ 0C��ɫ,0a��ɫ,0b��ɫ,06��ɫ,�� cmd ������ color /? �鿴
:colorText
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "COLOR_DEL=%%a"
)
echo off
<nul set /p ".=%COLOR_DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
echo;
goto :eof

:colorRedText
call :colorText 0C %1
goto:eof

:command
%1
goto confirm

:a
set exe=cmd
set /p "exe=������windows��Ӧ��λ��[����cmd]"
if "%exe%" == "" (
	echo ���ҵ�Ӧ�ò���Ϊ��
	goto confirm
)
where %exe%
goto confirm

:b
set files=%code_path%
echo �������ļ����ļ���·��,
set /p "files=[Ĭ��%code_path%]"
if "%files%" == "" (
	start ""  %files%
) else (
	start ""  %code_path%
)
goto confirm