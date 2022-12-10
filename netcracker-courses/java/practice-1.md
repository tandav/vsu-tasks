# practice-1.md
1. git-repo for labs
2. maven project хранить в репке (!= idea project)
3.1 Person entity, fields:
    - id
    - date of birthday
    - last name
    - метод который возвращает возраст этого чувака
- repo-class в котором можно хранить людей
    - добавить метод
    - удалить метод
- no collection, на массивах


1 maven проект - pom.xml
    - все лабы - как модули этого проекта, jar

- date storage - localdate from `Joda time` - подгрузить зависимости - через maven

---
target folder - папка куда все компилится - в `.gitignore`

## maven
- юзать maven для компайла. И вообще все через maven делать. 
- maven = pom.xml + sources (какая то структура папок)
- pom - описание проекта, как что собирать
- в поме указывается что проект является главным (каталогом проектов)
    - а у него уже будут модули
        - модуль - это просто папка. В нем также pom и также src. Остальное по сути не нужно
        - в pom модулей - есть тема `<dependencies>` - там указываешь какие либы подтягиваешь
        - если все модули используют одну либу - то в главном pom их указываешь
- в поме указываются java version / компилятор
- если управлять maven из консоли (а не из  idea)- то нужно его отдельно установить. Но также нужно в PATH прописать


## GroupId and ArtifactsID
- просто описание проекта
- GroupId - допустим ru.vsu
- ArtifactsID - имя проекта / labs допустим


внутри подмодули:
- GroupId = ru.vsu (такой-же)
- ArtifactsID = lab-1

необязательно чтобы это совпадало с названиями папок / модулей

## что прописывать в `pom.xml` на данном этапе (дфи-])
- для данного проекта - просто добавить joba в dependencies
- maven-compile-plugin
- [MaickelVRN/NCLab](https://github.com/MaickelVRN/NCLab) - nfv nbgf 

---

javadoc прописывать для методов

---

SORT

- где классы - юзать интерфейсы
- сортировка
    - interface PersonSorter
        - там метод void PersonSort
    - в PersonRepo - метод void sort - имплементит этот интерфейс
    - класс bubblesorter implrments void sort 
- Юзать пакетны, не кидать все в один пакет

---

В файле ресурсов (`src/main/resources`)создать файл с расширением config.proprties и разобраться с ним что это и как работает

там `sorter = bubble` строчка

Написать класс singleton congigurator - в этом классе 

---
SEARCH

interface PersonChecker 

И классы
FioPersonChecker implements PersonChecker

В классе PersonRepo - метод search (принимает PersonChecker, value) (value - значение по которому сравнивать например фамилия если FIoPersonChecker) Н
в начале пустой массив PersonRepo result
nfv внутри for  по всем: PersonChecker.check. Типа если удовлетворяет, то возвращаешь result - массив элементов удовлетворяющих Checker

---

## PersonRepo
```
expand_repo
add_person
delete_by_index
delete_by_id
sort
get_person_by_id
search
```

---

- add logging
    - просто где нибудь добавить
    - `DEBUG` - какие методы вызываются
    - на уровне `INFO` - что массив расширился
    - если какие-то проблемы / exceptions - то `ERROR`

---

- интерфейс репки - там базовые методы 
- потом абстрактный класс от этого репозитория 
- потом от этого репозитория создаются PersonRepository, CarRepository

Rep<T>

---

короче сначала доделать 

---

# переделать все юзая Generics
нужно все что сделали - переделать с использованием generics. Добавить еще одну сущность `машина` и еще один репозиторий автомобилей `CarRepository`.

вынести общие методы в абстрактный класс `repository`. 

теперь короче persons должны храниться не в массиве а в `List`
- сортировку переделать теперь юзать collection-sort


---

person - DONE
id, last-name, birthdate
getters and setters for all, constructor

Repo
<!-- Person[] repo = new Person[16]; -->
<!-- int numberOfElements = 0; -->
<!-- начальное значение (длина репки - 16? / захардкодить) -->
<!-- - get/set by index -->
<!-- - add -->
<!-- - delete by index -->
- searchBy (много разных)
- sort (много разных)
- getters and setters for all, constructor
- generics 

---

My Ideas

Abstract Class
sort
    sorter: bubble | shell
    comparator: sortBy<T>

Checker<T> - чекер для любого типа
Checker<Person> - чекер для Person

RealClass eg. PersonRepo
sort byName, byId, ...

---
