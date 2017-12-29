# SQL for Web Nerds (28K)
- http://philip.greenspun.com/sql/introduction.html   

This article is about RDBMS or relational database management systems. A tech that is used for 50 years.

---

Author starts with anoob question:

> What's wrong with a file system.

Why we cant just store our data in a files on our computers? Like text files or something. Why we need kinda *a system*, you know. 

---

And then he describes what wrong, list of problems like:
1. simultaneous access to file by many users / programs can corrupt file and loose data. An Operating system has some tools to solve concurrency problems but when it comes to business that tools look unrelieble.
2. Second is performance. popular sites getting 100 hits per second. Flat files work okay with that if they are very small. But suppose that your on-line bank with hundreds of thousand of users. You've got a chronological financial transactions file with 25 million entries. A user types his account number into a Web page and asks for his most recent deposits Your file system will get stuck searching specific entry. And while it is searching other users will also wait for their transactions.

---

Then he goes to RDBMS and show how it solve filesystem problems and features:
- ACID (Atomicity, Consistency, Isolation, Durability) All it solves by Transactions mechanism which basically means. Some change can passes or does not and the state of DB is rolls back to previous. state. You cant corrupt data.
- sophisticated indexing and caching schemes for freaking fast performance
- declarative SQL language. You only say "what you whant". Not "what to do, step by step to retrieve your data"

---

Then there is a section "How Does This RDBMS Thing Work?" 
In which author gives a brief about internal structure of RDBMS
like
- tables
- primary keys
- indexes
- what actually are Relations in relational databases  
- constraints

---

In **Brave New World** section Authors ends up with modern quick review of modern RDBMS techs.

---

## New Vocab -- then scroll and vocab
- lampooning = make fun of
- outh to = have to
- dwell on = отанавливаться на чем-то
- clumps = groups / bunch / cluster
- unobtrusiveness = ненавязчивость
- 
