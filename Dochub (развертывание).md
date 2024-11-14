## Установка программного обеспечения	
- Устанавливаем Vagrant https://developer.hashicorp.com/vagrant/downloads (vagrant_2.4.0_windows_amd64.msi)
- Устанавливаем Visual Studio Code (https://code.visualstudio.com)
- Устанавливаем Git (https://git-scm.com/downloads)
- Скачиваем образ focal64 Vagrant box (https://app.vagrantup.com/ubuntu/boxes/focal64)

## Создание проекта

| №            | Шаг     | # In stock |
|--------------|-----------|------------|
| 1 | 1.99      | *7*        |
| Bananas      | **1.89**  | 5234       |

- Создаем каталог проекта, например, "D:\Dochub\"
- Клонируем репозиторий `git clone --recurse-submodules https://github.com/cu3blukekc/SwampHub.git`. Результат - клонирован репозиторий, создан каталог `SwampHub`
- Выполнить команду `git submodule init && git submodule update`. Результат - 

3. Размещаем в каталоге проекта `D:\Dochub\SwampHub\` файл образа focal64 Vagrant box, переименовав его в `Vagrant.box`
4. Создаем в каталоге проекта `D:\Dochub\SwampHub\` файл настройками образа `Vagrant` следующего содержания:
```   
   Vagrant.configure("2") do |config|
      config.vm.box = "ubuntu/focal64"
   end
```   
5. Запускаем VS Code в каталоге проекта.
6. Запускаем терминал (`CTRL+~`) и вводим команду `vagrant box add --name ubuntu/focal64 Vagrant.box`. 
7. Дождаемся сообщение об успешном завершении операции:
```
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'ubuntu/focal64' (v0) for provider:
box: Unpacking necessary files from: file://D:/Dochub/SwampHub/Vagrant.box
box:
==> box: Successfully added box 'ubuntu/focal64' (v0) for ''!
```
8. Проверяем список доступных виртуальных машин, используя команду `vagrant box list`. В списке должна быть вирутальная машина
`ubuntu/focal64 (virtualbox, 0)`

## Создаение виртуальной машины 
1. Запускаем VS Code в каталоге проекта
2. Запускаем терминал (`CTRL+~`) и вводим команду `vagrant plugin install vagrant-docker-compose` для установки плагина (требуется VPN)
3. Вводим команду `vagrant up`. Результатом будет созданная вирутальная машина, которая отображается в Oracle VM VirtualBox с именем `SwampHub_defaul_*`
4. Размещаем в каталоге проекта создаем файл `.env` следующего содержания `VUE_APP_DOCHUB_RELOAD_SECRET=[КЛЮЧ]`
5. Устанавливаем вариант LF вместо CRLF параметра "Select end of line sequence"

## Сборка проекта
1. Запускаем в Oracle VM VirtualBox и переходим в виртуальную машину с именем `SwampHub_defaul_*` (команда "Показать")
2. Вводим логин и пароль: vagrant / vagrant
3. Переходим в каталог `cd /vagrant`
4. Запускаем скрипты установки `./scripts/install.sh`, `./scripts/install2.sh`
    * `Устанавливаем docker-compose sudo apt install docker-compose`
5. Запускаем скрипт сборки проекта `./scripts/build.sh` и ожидаем завершения сборки
6. Запускаем скрипт запуска `./scripts/run.sh`
 
## Запуск проекта
1. Запускаем в Oracle VM VirtualBox и переходим в виртуальную машину с именем `SwampHub_defaul_*` (команда "Показать")
2. Вводим логин и пароль: vagrant / vagrant
3. Переходим в каталог `cd /vagrant`
4. Запускаем скрипт запуска `./scripts/run.sh`
5. Запускаем сайт http://localhost:8080

## Подключение плагина

1.     Клонируешь
репозиторий: https://github.com/RabotaRu/DocHub.git (он нужен только чтобы забрать файлики плагинов)

2.     В каталог своего проекта «..\SwampHub\backend\dochub\plugins»
кидаешь папку «..\DocHub-master\plugins\devtool»

3.     В каталог своего проекта «..\SwampHub\frontend\dochub\plugins» кидаешь папку «..\DocHub-master\plugins\devtool»

4.     В файлы
«..\SwampHub\backend\dochub\plugins.json», «..\SwampHub\backend\dochub\frontend.json» добавляешь строку «"plugins/devtool"»,
получиться должно вот так:


{
    "inbuilt": [
        "plugins/html",
        "plugins/markaper",
        "plugins/charts",
        "plugins/devtool"
    ]
}

5.     В какой-то файл своего проекта добавляешь: 

docs:

  dochub.plugins.devtool_new:
    location: DevTool
    type: devtool