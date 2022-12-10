# Practice 5
500 компов - предел , если больше - broadcast наводнение. Нужно делить уже на broadcast domains.

VLAN, СКС - стандарты

---

```
enable
conf t
int fa0/1
switchport mode access
switchport access vlan 2
int fa0/2
switchport mode access
switchport access vlan 3
int g0/1
switchport mode trunk
```

в 10 сети у маршрутизатора будет адрес `10.0.0.254`
в 11 сети у маршрутизатора будет адрес `11.0.0.254`


маршрутизатор 2911


у каждого роутера в ip configuration шлюзы по умолчанию должны быть адреса роутера своего влан

- [VLANs and Switch Configuration on Packet Tracer (EASY) - YouTube](https://www.youtube.com/watch?v=X0GMtmBAhOk)

---

в роутере 

enable
conf t
int g0/0.2
encapsulation dot1q 3
ip address 10.0.0.254 255.0.0.0 # для vlan 2
int g0/0.3
encapsulation dot1q 3
ip address 11.0.0.254 255.0.0.0 # для vlan 3
