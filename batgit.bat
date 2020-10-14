@echo off&title GIT批处理&color 0F
rem 编写教程
rem 控制单句不在屏幕上出现，有两种办法： 1.语句前加@例如 @cd / 2.语句后加 >nul 或 >nul 2>nul


rem 清屏
cls
rem 设置编码
set LESSCHARSET=utf-8
rem 初始化变量&数据
goto init
rem 显示帮助信息
goto help

:init
rem 设置通用变量
rem 项目代码路径【必须设置正确才能正常使用】
rem set code_path="E:\dnmp\www\cst-group"
set code_path="F:\batgit\batgit"
rem 是否已设置git环境变量【必须设置正确才能正常使用】
set git_home="true"
if "%git_home%" == "true" (
	rem git.exe路径[已设置环境变量]
	set git_cmd="git"
) else (
	rem git.exe路径[没有设置环境变量]
	set git_cmd="D:\git\Git\bin\git.exe"
)
rem  切换项目路径
cd /d  %code_path%
rem goto:eof

:help
set d=%date:~0,10%
set t=%time:~0,8%
rem 当前时间
set timestamp=%d% %t%
rem 输出项目路径
echo 当前时间：%timestamp%
echo 当前项目路径：%code_path%
echo **************************************************************
echo *                          帮助信息                          *
echo *  Author：L                                                 *
echo *  Created：2020/10/10                                       *
echo **************************************************************
echo *  1: 拉取管理                                               *
echo *  2: 提交管理                                               *
echo *  3: 分支管理                                               *
echo *  4: 暂存管理                                               *
echo *  5: 克隆项目                                               *
echo *  50: 查看分支                                              *
echo *  51: 新建分支                                              *
echo *  52: 合并分支                                              *
echo *  60: 查看标签[q退出]                                       *
echo *  61: 打标签                                                *
echo *  70: 查看日志[q退出]                                       *
echo *  98: 查看git用户配置                                       *
echo *  99: 修改git用户配置                                       *
echo *  a: 查找windows下应用位置,例：cmd                          *
echo *  b: 打开文件或文件夹                                       *
echo *  cmd: 打开新的cmd命令窗口                                  *
echo **************************************************************
echo;
rem 设置默认值
set input=1
set /p "input=请输入[默认1]:"
if "%input%"==""  goto git_pull
if "%input%"=="1" goto git_pull
if "%input%"=="2" goto git_push
if "%input%"=="3" goto git_branch
if "%input%"=="4" goto ogit_stash
if "%input%"=="5" goto git_clone
if "%input%"=="30" goto tod
if "%input%"=="50" goto git_branch_list
if "%input%"=="51" goto todo
if "%input%"=="52" goto git_branch_merge
if "%input%"=="60" goto git_tag_list
if "%input%"=="70" goto git_log_list
if "%input%"=="98" goto git_user_info
if "%input%"=="99" goto git_user_update
if "%input%"=="a" goto a
if "%input%"=="b" goto b
if "%input%"=="cmd" goto cmd
goto help
goto:eof
exit


rem 暂存管理[已测试]
:git_stash
set option=0
echo 0:返回帮助信息[默认]
echo 1:列出暂存列表
echo 2:最新一个暂存信息
echo 3:暂存数据
echo 4:恢复之前缓存的工作目录
set /p "option=请选择："
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

rem 克隆项目代码[已测试]
:git_clone
set files=
set /p "files=请输入克隆文件夹路径："
if "%files%" == "" (
	call :error 克隆文件夹路径不能为空
)
cd /d %files%
set url=
set /p "url=请输入克隆地址：
if "%url%" == "" (
	call :error 克隆地址不能为空
)
%git_cmd% clone %url%
set code_path=%files%
rem 克隆完需自行切换路径，否则运行出可能问题
echo 当前路径：%cd%
goto confirm

:git_pull
set option=0
echo 0:返回帮助信息[默认]
echo 1:拉取当前分支
echo 2:拉取分支列表[需在代码修改拉取的分支]
set /p "option=请选择：
if "%option%" == "1" (
	%git_cmd% pull
) else if "%option%" == "2" (
	echo -------更新所有分支-------
	rem 完成后切换分支
	set current_branch=dev_ca_v1.0.0
	rem 需要更新的分支列表
	set pull_branch=dev_ca_v1.0.0 dev_v1.0.0
	for %%I in (%pull_branch%) do (
		%git_cmd% checkout %%I
		%git_cmd% pull origin %%I
		if not %errorlevel%==0 (
			rem 成功则返回0
			call :error 冲突了
		)
	)
	rem 更新完切换分支
	%git_cmd% checkout %current_branch%
	echo -------更新完成----------
	echo -------当前分支%current_branch%----------
	goto confirm
) 
goto confirm

rem 推送代码[已测试]
:git_push
rem 查看本地仓库的当前状态
%git_cmd% status
rem 常看当前项目的具体修改内容
rem %git_cmd% diff
rem 保存当前的工作进度，会把暂存区和工作区的改动保存起来
%git_cmd% stash save stash time:%timestamp% 
rem 获取远程仓库的最新代码
%git_cmd% pull
rem 恢复最新的进度到工作区，这个过程会合并git pull到本地的远程仓库中的代码，这个过程可能会有冲突警告
rem git stash不针对特定的分支，切换分支后，stash内容不变，所以弹出时要小心。git stash pop或者drop后，stash的序号会自动改变，连续弹出时要注意
%git_cmd% stash pop
if %errorlevel%==1 (
	call :error 没有任何修改
)
if not %errorlevel%==0 (
	rem 成功则返回0
	call :error 出错了，errorlevel为：%errorlevel%
)
rem 设置默认值
set op=1
echo 1:提交所有更改[默认]
echo 2:自定义提交文件或目录
set /p "op=请选择:
if %op% == "2" (
	set files=
	set /p "files=请输入要上传的文件或目录："
	call :checkEmpty "%files%" 不能输入空数据
	%git_cmd% add %files%
) else (
	rem git add -A  提交所有变化
	rem git add -u  提交被修改(modified)和被删除(deleted)文件，不包括新文件(new)
	rem git add .  提交新文件(new)和被修改(modified)文件，不包括被删除(deleted)文件
	%git_cmd% add -A
)
set msg=
set /p "msg=输入提交的commit信息:"
call :checkEmpty "%msg%" commit信息不能为空
%git_cmd% commit -m %msg%
rem 将本地仓库的代码推送到远程代码仓库
%git_cmd% push
call :checkErrorLevel %errorlevel%
goto confirm

rem 标签列表
:git_tag_list
%git_cmd% tag
goto confirm

rem 日志列表
:git_log_list
%git_cmd% log -5
goto confirm

rem 分支管理
:git_branch
set option=0
echo 0:返回帮助信息[默认]
echo 1:分支列表
echo 2:创建分支
echo 3:切换分支
echo 4:推送分支
echo 5:合并分支
set /p "option=请选择："
if "%option%" == "0" goto help
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
)
goto confirm

rem 创建分支
:git_branch_create
set name=
set /p "name=请输入分支名称："
call :checkEmpty "%name%" 分支名称不能为空
set option=0
echo 0:返回帮助信息[默认]
echo 1:创建分支[不切换]
echo 2:创建分支并切换到创建的分支
set /p "option=请输入："
if "%option%" == "0" goto help
if "%option%" == "1" %git_cmd% checkout %name%
if "%option%" == "2" %git_cmd% checkout -b %name%
%git_cmd% branch
set option_push=0
echo 0:返回帮助信息[默认]
echo 1:推送分支到远程
set /p "option_push=是否推送分支，请输入："
if "%option_push%" == "0" goto help
rem --set-upstream 关联远程分支
if "%option_push%" == "1" %git_cmd% push --set-upstream origin %name%
goto confirm

rem 切换分支
:git_branch_checkout
echo 分支列表：
%git_cmd% branch -a
set name=
set /p "name=请输入分支名称："
call :checkEmpty "%name%" 分支名称不能为空
%git_cmd% checkout %name%
goto confirm

rem 推送分支
:git_branch_push
set name=
set /p "name=请输入分支名称："
call :checkEmpty "%name%" 分支名称不能为空
rem --set-upstream 关联远程分支
%git_cmd% push --set-upstream  origin %name%
goto confirm

rem 分支列表
:git_branch_list
set option=0
echo 0:返回帮助信息[默认]
echo 1:列出本地分支
echo 2:列出远程分支
echo 3:列出所有本地分支和远程分支
echo 4:列出当前分支
set /p "option=请选择："
if "%option%" == "0" goto help
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

rem 合并分支
:git_branch_merge
echo 0:返回帮助信息[默认]
echo 1:dev_ca_v1.0.0 合并到 dev_v1.0.0
echo 99:自定义合并[目标分支合并到当前分支]
set /p "option=请选择："
call :gotoHelp %option%
if "%option%" == "1" (
	rem 检查工作区是否干净
	call :checkWorkingTree
	rem 合并分支
	call :gitBranchMergeDo dev_ca_v1.0.0 dev_v1.0.0
) else if "%option%" == "99" (
	rem 检查工作区是否干净
	call :checkWorkingTree
	echo 分支列表：
	%git_cmd% branch
	set /p "target_branch=请输入目标分支名称："
	call :checkEmpty "%target_branch%" 目标分支名称不能为空
	set /p "local_branch=请输入当前分支名称："
	call :checkEmpty "%local_branch%" 当前分支名称不能为空
	set option_branch=0
	echo 0:返回帮助信息[默认]
	echo 1:把%target_branch%合并到%local_branch%
	set /p "option_branch=请选择："
	call :gotoHelp "%option_branch%"
	if "%option_branch%" == "1" (
		call :gitBranchMergeDo %target_branch% %local_branch%
	) else (
		call :error 输入有误
	)
)  else (
	call :error 输入有误
)
goto confirm

::rem 合并分支。第一个参数目标分支，第二个参数当前分支
:gitBranchMergeDo
rem 切换到第一个参数分支[目标分支]
%git_cmd% checkout %1
%git_cmd% pull
if not %errorlevel%==0 (
	call :error 拉取出现冲突,请手动解决
)
rem 切换到第二个参数分支[当前分支]
%git_cmd% checkout %2
%git_cmd% pull
if not %errorlevel%==0 (
	call :error 拉取出现冲突,请手动解决
)
rem 把目标分支合并到当前分支
%git_cmd% merge %1
if not %errorlevel%==0 (
	%git_cmd% status
	call :error 合并出现冲突,请手动解决
)
if %errorlevel%==0 (
	set option=0
	echo 0:返回帮助信息[默认]
	echo 1:push推送合并代码,%1推送合并到 %2分支
	set /p "option=请选择："
	call :gotoHelp %option%
	if "%option%" == "1" (
		%git_cmd% push
	) else (
		call :error 输入有误,推送失败,请手动push推送
	)
)
goto:eof

::rem 检查工作区是否干净
:checkWorkingTree
%git_cmd% diff --exit-code>nul
if not %errorlevel%==0 (
	call :error 合并前保证工作区干净。工作区有未暂存的更改
)
%git_cmd% diff --cached --exit-code>nul
if not %errorlevel%==0 (
	call :error 合并前保证工作区干净。工作区有未commit的文件
)
rem %git_cmd% ls-files --other --exclude-standard --directory
rem if not %errorlevel%==0 (
rem 	call :error 合并前保证工作区干净。工作区有未跟踪的文件
rem )
goto:eof

rem 获取git用户信息[已测试]
:git_user_info
echo -------查看git用户-------
%git_cmd% config user.name
%git_cmd% config user.email
echo -------------------------
goto confirm

:git_user_update
echo 删除代码的exit才能执行
rem 没验证功能，暂时终止
exit
echo -------修改git用户名email-------
echo PS:请输入用户名
set /p "name="
if "%name%" == "" (
	echo 用户名不能为空
	exit
)
echo 请输入email
set /p "email="
if "%email%" == "" (
	echo email不能为空
	goto confirm
)
%git_cmd% config --global user.name "%name%"
%git_cmd% config --global user.email "%email%"
echo -------------修改成功-------------
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
	call :error 出错了，errorlevel为：%1%
	goto confirm
	pause>nul
	exit;
)
goto:eof

:todo
echo *******************************
echo *             未开发          *
echo *******************************
goto confirm

:confirm
echo;
call :colorText 0b "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
call :colorText 0a "[[处理完成]]"
set op=0
echo 0:返回帮助信息[默认]
echo 1:退出
echo cmd:打开新的cmd命令窗口
set /p "op=请选择："
if "%op%" == "1" (
	goto exit
) else if "%op%" == "cmd" (
	goto cmd
)
call :colorText 0b "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo;
goto help

rem call调用，%1为参数
:error
call :colorText 0C "++++++++++++++++++++++++错误退出++++++++++++++++++++++++++++++"
echo %1
call :colorText 0C "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
goto confirm
pause>nul
exit;

:exit
rem 退出
exit;

:cmd
rem 打开cmd命令
start cmd /k echo %cd%
goto help

rem 设置字体颜色 0C红色,0a绿色,0b蓝色,06黄色,在 cmd 中输入 color /? 查看
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
set /p "exe=请输入windows下应用位置[例：cmd]"
if "%exe%" == "" (
	echo 查找的应用不能为空
	goto confirm
)
where %exe%
goto confirm

:b
set files=%code_path%
echo 请输入文件或文件夹路径,
set /p "files=[默认%code_path%]"
if "%files%" == "" (
	start ""  %files%
)else (
	start ""  %code_path%
)
goto confirm