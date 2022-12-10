# Practice 4
- TFTP - с FTP не имеет ничего общего. Юзает UDP. Не поддерживает папки, не поддерживает auth. Юзается  to upgrade devices.
- TFTP32

---

- DHCP - режим автополучения адреса. 
- Иначе - new hardware configuring by manually. Сначала консольный голубой порт. COM - порт. Они вытеснены usb на обычных компах. Но в телекоме еще юзается. 3 провода (земля, прием, передача) раньше, щас 9 контактов, похож на VGA

- команда `show running-config` - показывает всю инфу о роутере
- flash память хранит кофигурацию `running config` `startup config`. (stores in nvram)


---

- поставить пароль: `enable secret <my_pass>`
- отменить пароль - `no enable secret`

`enable password <my_pass>` - 

---

ssh работает на основе ssl (пары ключей). Нужен сертификат еще полный чтобы сгенерировать пару ключей.

есть локал

---

Можно copy-paste в терминал в роутере

---
no ip domain-lookup - off shit , когда ошибаешься долго ждать
