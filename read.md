## 注意事项```持续完善```



1.控制单句不在屏幕上出现，有两种办法： 1.语句前加@例如 @cd / 2.语句后加 >nul 或 >nul 2>nul
2.bat中set命令放在if的括号里 【开启环境变bai量延迟setlocal enabledelayedexpansion 并把调用的变量%toos%改成!toos! 这是因为在du命令的zhi括号中执行set设置以及变量调用时，就不能dao用百分号了，因此先开启环境变量延迟，然后把百分号换成感叹号。】
3.