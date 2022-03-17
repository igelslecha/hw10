# hw10
** 1. Сделан скрипт ps.sh аналог команды ps ax. **
*Задаю форматирование выводимой таблицы и заголовок. *
```
fmt="%-9s%-5s%-5s%-10s%-100s\n"
printf "$fmt" PID TTY STAT TIME COMMAND
```
*Цикл для перебора процессов (нумерованных папок) *
```
for proc in `ls /proc/ | egrep "^[0-9]" | sort -n`
do
```
* Проверяю наличие информации о процессе у системы *
```
if [[ -f /proc/$proc/status ]]
       then
       PID=$proc
```
* Выясняю в каком именно TTY выполняется процесс, не нашёл нигде прямой путь, пришлось делать таким образом *
```
TTY=`ls -all /proc/$proc/fd | grep /dev/ | head -1 | cut -f 11 -d ' ' | sed -r 's/.{,5}//'`
    if [[ TTY=null ]]
        then
        TTY="?"
    fi
```
* Получилось найти только "простой статус" нигде не нашёл алгоритма выяснить "сложный" *
```
STAT=`cat /proc/$proc/status | awk '/State/{print $2}'`
```
* Получил время работы процесса в секундах, сделал вроде всё по статье, https://stackoverflow.com/questions/16726779/how-do-i-get-the-total-cpu-usage-of-an-application-from-proc-pid-stat, но к сожалению похоже не совсем верно *
```
stime=`cut /proc/$proc/stat -f 15 -d ' '`
    utime=`cut /proc/$proc/stat -f 14 -d ' '`
    cutime=`cut /proc/$proc/stat -f 16 -d ' '`
    cstime=`cut /proc/$proc/stat -f 17 -d ' '`
    let "TIME=$stime+$utime+$cutime+$cstime"
    TIK=`getconf CLK_TCK`
    let "TIME=$TIME/$TIK"
```
* Получил запущенную команду *
```
COMMAND=`tr -d '\0' < /proc/$proc/cmdline`
     if  [[ -z  "$COMMAND" ]]
          then
       COMMAND="[`awk '/Name/{print $2}' /proc/$proc/status`]"
#     else
#       COMMAND=`tr -d '\0' < /proc/1/cmdline `
     fi
```
* печатаю результат и заканчиваю работу скрипта *
```
printf "$fmt" $PID $TTY  $STAT $TIME "$COMMAND"
   fi
done
```
** 2. **
