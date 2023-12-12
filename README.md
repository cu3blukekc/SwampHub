# Пример развертывания DocHub

## Цели примера
1. Показать как можно разделить DocHub на различные репозитории в зависимости от их назначения
2. Показать как реализовать контейнеризацию выделенных репозиториев на базе Docker
3. Показать как можно оптимизировать работу с контейнерами DocHub на примере docker compose

## Суть подхода
В процессе работы с DocHub стало понятно, что процесс наполнения архитектурного озера данных и процесс реализации и доработки метамодели - это разные процессы. Данные для озера нужно катить часто, а метамодель нужно катить редко и проверять качественно. Если они развертываются в рамках одного процесса, то мы получаем конфликт между скоростью и качеством. Так же нужно учитывать что этими процессами могут заниматься разные люди.

После того как в DocHub была реализована возможность разделения метамодели и данных, было принято решение переструктурировать подход управления DocHub.

## Что было сделано
Мы определили четыре основных компонента DocHub, каждый из которых, в первую очередь, подразумевает свой процесс разработки, тестирования и развертывания
1. Метамодель ([metamodel](https://dochub.info/docs/dochub.flex_metamodel))
2. Озеро данных (manifest)
3. Бэкенд ([backend](https://dochub.info/docs/dochub.deployment#client-server))
4. Фронтенд ([frontend](https://dochub.info/docs/dochub.deployment#client-server))

Такой подход позволяет нам:
1. Управлять разными процессами по разному
2. Существенно ускорить процесс выкатки изменений (в первую очередь озера данных)
3. Улучшить качество метамодели, так как в процесс можно встроить этап полноценного тестирования

## Чего нет в примере, но чтобы хотелось
1. [Валидации](https://dochub.info/docs/dochub.rules) обновления озера данных в рамках пайплайна развертывания
2. Вынесение [плагинов](https://dochub.info/docs/dochub.plugins.intro) в отдельный компонент

## Описание примера
Все каталоги находящиеся в корневой директории можно рассматривать как отдельные репозитории.

### Файловая структура примера

```
|- backend              - конфигурация бэкенда
|  |- dochub            - подмодуль ссылающийся на оригинальный репозиторий DocHub (https://github.com/RabotaRu/DocHub)
|  |- Dockerfile        - настройка контейнера Docker
|  |- entrypoint.sh     - запуск бэкенда
|- frontend             - конфигурация фронтенда
|  |- dochub            - подмодуль ссылающийся на оригинальный репозиторий DocHub (https://github.com/RabotaRu/DocHub)
|  |- Dockerfile        - настройка контейнера Docker
|  |- entrypoint.sh     - наполнение переменных для разных стендов DocHub, запуск nginx со статикой фронтенда
|  |- nginx.conf        - конфигурация nginx, важный нюанс: фронтенд проксирует бэкенд наружу, т.е. запросы проксируются с браузера через nginx фронтенда в бэкенд
|- manifest             - манифесты архитектурного озеры данных
|  |- manifest          - подмодуль ссылающийся на репозиторий с примером данных DocHubExampleManifest (https://github.com/ValentinKozlov/DocHubExampleManifest)
|  |- Dockerfile        - настройка контейнера Docker
|  |- nginx.conf        - настройка nginx через который раздаются данные для бэкенда
|- metamodel            - манифесты архитектурного озеры данных
|  |- metamodel         - подмодуль ссылающийся на репозиторий с примером метамодели DocHubExampleMetamodel (https://github.com/ValentinKozlov/DocHubExampleMetamodel)
|  |- Dockerfile        - настройка контейнера Docker
|  |- nginx.conf        - настройка nginx через который раздаются данные для бэкенда
|- docker-compose.yaml  - пакетный запуск контейнеров Docker.
|- README.md            - описание репозитория

```
## Использование

### Быстрый старт
1. Клонируйте себе пример `git clone --recurse-submodules https://github.com/cu3blukekc/SwampHub.git` либо просто клонируйте себе репозиторий и выполните команды `git submodule init && git submodule update` 
2. Создайте в корне пустой файл .env
2. Выполните команду docker-compose up или docker compose up (v2)
3. Откройте браузер и наберите http://localhost:8080/ 
4. Успех!
5. Празднование успеха!

### Обновление подмодулей

Так как в репозитория часть проекта собирается из подмодулей, то для того чтобы их обновить был написан скрипт `update.sh`. Зайдите в корень репозитория swamp и запустите скрипт.
Вы можете обновить каждый репозиторий подключенный сабмодулем вручную. Для этого зайдите в нужный репозиторий и выполните команду `git pull`, но обратите внимание, что такие репозитории клонируются не на дефолтные ветки, а на конкретные коммиты, поэтому перед обновлением измените ветку на основную.

### Удаление подмодулей
1. Удалить секцию подмодуля из .gitmodules
2. Выполнить команду git add .gitmodules
3. Удалить подмодуль из .git/config
4. Из корня репозитория выполнить команду git rm -rf --cached path_to_submodule
5. Удалить папку с подмодулем

### Если нужно, что-то поменять на горячую
Для того чтобы сделать reload бэкенда, в DocHub существует отдельная API. Для его работы в `backend` нужно передать переменную окружения `VUE_APP_DOCHUB_RELOAD_SECRET` для доступа к перезагрузке данных архитектуры.

1. В файле `.env` и внесите значение переменной `VUE_APP_DOCHUB_RELOAD_SECRET=все что угодно`
3. Перезапустите контейнер с backend, если он был запущен
4. Внесите изменения в озеро данных или в метамодель
5. Выполните скрипт `reload_backend.sh`
6. Проверьте что новые изменения подтянулись на портал DocHub


## Вариант установки в Windows

### С использованием Docker Desktop
* [Установите Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)
* [Установите VSCode](https://code.visualstudio.com)
* [Установите Git](https://git-scm.com/downloads)
* Выполните [Быстрый старт](#быстрый-старт)

### С использованием Vagrand
#### Установка программного обеспечения
* [Устанавливаем Vagrant](https://developer.hashicorp.com/vagrant/downloads) (vagrant_2.4.0_windows_amd64.msi)
* [Устанавливаем VSCode](https://code.visualstudio.com)
* [Устанавливаем Git](https://git-scm.com/downloads)
* [Скачиваем образ `focal64 Vagrant box`](https://app.vagrantup.com/ubuntu/boxes/focal64)

#### Создание проекта
* Создаем каталог проекта, например, `D:\Dochub\`. *Далее все примеры с этим путём*
* Запускаем VSCode, в котором запускаем терминал (`CTRL+~`) и клонируем репозиторий, используя команду `git clone --recurse-submodules https://github.com/cu3blukekc/SwampHub.git`. В результате - клонирован репозиторий и каталоге `D:\Dochub\` создан подкаталог `SwampHub`
* Для обновления файлов проекта можно использовать команду `git submodule init && git submodule update`
* Размещаем в каталоге проекта `D:\Dochub\SwampHub\` файл образа `focal64 Vagrant box`, переименовав его в `Vagrant.box`
* Создаем в каталоге проекта `D:\Dochub\SwampHub\` файл настройками образа `Vagrant` следующего содержания:
  ```   
    Vagrant.configure("2") do |config|
      config.vm.box = "ubuntu/focal64"
    
      config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--ioapic", "on"]
        vb.customize ["modifyvm", :id, "--memory", "8192"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
      end
    
      portSSH = 2225
      
      portMetamodel = 8081
      portManifest = 8082
      portBackEnd = 3030
      portFrontEnd = 8080
      portPlantUML = 9000
      
      docker_compose_version ="2.9.0"
    
      config.vm.hostname = "vagrant-swamphub"
      config.vm.network "private_network", ip: "192.168.44.10"
    
      config.vm.network(:forwarded_port, guest: 22, host: portSSH,id: 'ssh')
      
      config.vm.network(:forwarded_port, guest: portFrontEnd, host: portFrontEnd)
      config.vm.network(:forwarded_port, guest: portMetamodel, host: portMetamodel)
      config.vm.network(:forwarded_port, guest: portManifest, host: portManifest)
      config.vm.network(:forwarded_port, guest: portBackEnd, host: portBackEnd)
      config.vm.network(:forwarded_port, guest: portPlantUML, host: portPlantUML)
      
      config.vm.provision :shell, inline: "apt-get update"
      config.vm.provision :shell, inline: "export DOCKER_BUILDKIT=1" # or configure in daemon.json
      config.vm.provision :shell, inline: "export COMPOSE_DOCKER_CLI_BUILD=1"
    
      # Avoid plugin conflicts
      if Vagrant.has_plugin?("vagrant-vbguest") then
        config.vbguest.auto_update = false
      end
    
  ```   
* Запускаем VSCode в каталоге проекта
* Запускаем терминал (`CTRL+~`) и вводим команду `vagrant box add --name ubuntu/focal64 Vagrant.box`
* Дождаемся сообщение об успешном завершении операции:
  ```
  ==> box: Box file was not detected as metadata. Adding it directly...
  ==> box: Adding box 'ubuntu/focal64' (v0) for provider:
  box: Unpacking necessary files from: file://D:/Dochub/SwampHub/Vagrant.box
  box:
  ==> box: Successfully added box 'ubuntu/focal64' (v0) for ''!
  ```
* Проверяем список доступных виртуальных машин, используя команду `vagrant box list`. В списке должна быть вирутальная машина
  `ubuntu/focal64 (virtualbox, 0)`. Файл `Vagrant.box` можно удалять или переносить в другой каталог.

#### Создание виртуальной машины
* Запускаем VSCode в каталоге проекта
* Запускаем терминал (`CTRL+~`) и вводим команду `vagrant plugin install vagrant-docker-compose` для установки плагина (требуется VPN)
* В каталоге проекта создаем файл `.env` следующего содержания `VUE_APP_DOCHUB_RELOAD_SECRET=[КЛЮЧ]`
* Устанавливаем каретку LF вместо CRLF. Параметр "Select end of line sequence" (`CTRL+SHIFT+P` и ввести строку `Change All End Of Line Sequence`) для файлов:
  ```
    ./reload_backend.sh
    ./update.sh
    ./scripts/build.sh
    ./scripts/copy.sh
    ./scripts/install.sh
    ./scripts/run.sh
  ```
* Вводим команду `vagrant up`. Результатом будет созданная вирутальная машина, которая отображается в Oracle VM VirtualBox с именем `SwampHub_defaul_*` и созданный
  каталог `D:\Dochub\SwampHub\.vagrant` и отобразится сообщение:
```
  ==> default: Setting hostname...
  ==> default: Configuring and enabling network interfaces...
  ==> default: Mounting shared folders...
  default: /vagrant => D:/Dev/Dochub/SwampHub
```

#### Сборка проекта
* Запускаем в Oracle VM VirtualBox и переходим в виртуальную машину с именем `SwampHub_defaul_*` (команда "Показать")
* Вводим логин и пароль: vagrant / vagrant
* Переходим в каталог `cd /vagrant`
* Запускаем скрипт обновления `./update.sh` (ожидаем завершения)
* Запускаем скрипт установки `./scripts/install.sh` (ожидаем завершения)
* Выходим из под администратора командой `exit`, вводим логин и пароль: vagrant / vagrant и ожидаем окончания установки docker (ожидаем появления сообщения `hello-world`)
* Переходим в каталог `cd /vagrant`
* Запускаем скрипт сборки проекта `./scripts/build.sh`(ожидаем завершения)

#### Запуск проекта
* Запускаем в Oracle VM VirtualBox и переходим в виртуальную машину с именем `SwampHub_defaul_*` (команда "Показать")
* Вводим логин и пароль: vagrant / vagrant
* Переходим в каталог `cd /vagrant`
* Запускаем скрипт запуска `./scripts/run.sh`
* Запускаем сайт http://localhost:8080


## Авторские права
1. Вся работа по настройке контейнеров Docker была выполнена Александром Трубниковым https://t.me/cu3blukekc
2. Примеры репозиториев с метамоделью, данными и текущая инструкция были адаптированы Валентином Козловым https://t.me/i_frog_i.
3. Репозиторий для сборки сервера PlantUML принадлежит Владиславу Маркину https://t.me/vlad_markin и был взят [отсюда](https://github.com/vlad-markin/plantuml-server/tree/dochub-v2).