# Самостоятельная работа 1
## Выполнил: Шокиров Егор, группа ЦИБ - 241, Вариант 1

---

## Цель работы
Научиться подключаться к базе данных PostgreSQL, создавать структуру данных, наполнять ее тестовыми данными и выполнять аналитические запросы. Построить визуализацию показателей KPI сотрудников в сервисе DataLens.

---

## Ход работы

### 1. Подключение к базе данных

Работа была выполнена на локальном сервере 

### 2. Создание структуры базы данных

В рамках работы была спроектирована база данных для управления IT-проектами. В схеме project_management_st21 были созданы четыре взаимосвязанные таблицы.

Описание созданных таблиц:
Для организации данных используются следующие сущности: таблица employees служит справочником сотрудников и хранит их идентификаторы, имена, фамилии и роли; таблица projects представляет собой реестр активных проектов с их названиями и статусами; в таблице tasks описываются задачи внутри проектов (включая внешние ключи, названия и приоритеты); а таблица assignments отвечает за назначение конкретных людей на задачи, связывая идентификаторы сотрудников и соответствующих заданий.
sql
CREATE SCHEMA IF NOT EXISTS project_management_st21;
SET search_path TO project_management_st21;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50)
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'В работе'
);

CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(project_id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    priority INTEGER CHECK (priority BETWEEN 1 AND 5)
);

CREATE TABLE assignments (
    assignment_id SERIAL PRIMARY KEY,
    task_id INTEGER REFERENCES tasks(task_id) ON DELETE CASCADE,
    employee_id INTEGER REFERENCES employees(employee_id) ON DELETE CASCADE
);
  

### 3. Наполнение данными

Для генерации репрезентативной аналитики таблицы были наполнены массивом тестовых данных, имитирующих работу крупного IT-департамента:
- 15 сотрудников различных специализаций (PM, Developers, Analysts, QA, DevOps).
- 5 ключевых задач, соответствующих основным направлениям деятельности компании.
- 50 записей в таблице назначений, реализующих сложную структуру командного взаимодействия.
sql
INSERT INTO employees (first_name, last_name, email, role) VALUES
('Иван', 'Петров', 'i.petrov@company.com', 'Project Manager'),
('Анна', 'Сидорова', 'a.sidorova@company.com', 'Senior Developer'),
('Дмитрий', 'Волков', 'd.volkov@company.com', 'Data Analyst'),
('Елена', 'Кузнецова', 'e.kuznetsova@company.com', 'QA Lead'),
('Сергей', 'Морозов', 's.morozov@company.com', 'UI/UX Designer'),
('Ольга', 'Павлова', 'o.pavlova@company.com', 'DevOps'),
('Артем', 'Соколов', 'a.sokolov@company.com', 'Frontend Developer'),
('Мария', 'Белова', 'm.belova@company.com', 'Backend Developer'),
('Игорь', 'Чернов', 'i.chernov@company.com', 'System Architect'),
('Виктория', 'Ли', 'v.li@company.com', 'Product Owner'),
('Константин', 'Рябов', 'k.ryabov@company.com', 'Security Expert'),
('Дарья', 'Смирнова', 'd.smirnova@company.com', 'Business Analyst'),
('Никита', 'Козлов', 'n.kozlov@company.com', 'Fullstack Developer'),
('Алина', 'Орлова', 'a.orlova@company.com', 'Manual QA'),
('Роман', 'Виноградов', 'r.vinogradov@company.com', 'DBA');

INSERT INTO projects (project_name, start_date, status) VALUES 
('Автоматизация учета', '2024-03-01', 'В работе'),
('Внедрение BI', '2024-01-15', 'В работе'),
('Мобильное приложение', '2023-11-01', 'В работе'),
('Обновление сайта', '2024-03-20', 'В работе'),
('Разработка CRM', '2023-09-01', 'Завершен');

INSERT INTO tasks (project_id, title, due_date, priority) VALUES
(1, 'Автоматизация учета', '2024-08-01', 1),
(2, 'Внедрение BI', '2024-05-01', 1),
(3, 'Мобильное приложение', '2024-06-15', 2),
(4, 'Обновление сайта', '2024-04-30', 2),
(5, 'Разработка CRM', '2024-03-01', 1);

INSERT INTO assignments (task_id, employee_id) VALUES (1,1),(1,3),(1,8),(1,9),(1,12),(1,15),(1,13),(1,10);
INSERT INTO assignments (task_id, employee_id) VALUES (2,1),(2,3),(2,2),(2,4),(2,6),(2,9),(2,12),(2,10),(2,15),(2,14),(2,8),(2,11);
INSERT INTO assignments (task_id, employee_id) VALUES (3,2),(3,5),(3,7),(3,13),(3,4),(3,6),(3,8),(3,9),(3,11),(3,1);
INSERT INTO assignments (task_id, employee_id) VALUES (4,5),(4,7),(4,14),(4,2),(4,13),(4,4);
INSERT INTO assignments (task_id, employee_id) VALUES (5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(5,7),(5,8),(5,9),(5,10),(5,11),(5,12),(5,13),(5,14);



(29, 2023, 1, 82, 6, 2, 4.3, 'Норма'),
(29, 2023, 4, 86, 8, 2, 4.5, 'Хорошо'),
(29, 2023, 7, 90, 10, 3, 4.7, 'Отлично'),
(29, 2023, 10, 88, 9, 2, 4.6, 'Хорошо'),
(29, 2023, 12, 93, 12, 4, 4.9, 'Премия');
 
Полный [sql_dump](sql_dump.sql)

 ### 4. Визуализация в DataLens
На основе подготовленного датасета разработан интерактивный дашборд «Project Management» для оценки загрузки персонала.
Состав аналитической панели:
1. Ресурсный план по проектам: количественный анализ распределения команд.
2. Карта концентрации ресурсов: матрица приоритетов задач (Treemap).
3. Баланс стратегических приоритетов: мониторинг фокуса компании по уровням критич

[открыть дашборд](https://datalens.ru/59zpk3t9bjtyp-analiticheskiy-dashbord-project-management)

## Результаты
Развернута локальная БД PostgreSQL с оптимизированной структурой связей «многие ко многим».
Сформирован массив данных из 50 записей, отражающий реальную загрузку 15 специалистов.
Реализована автоматизированная связка SQL-базы с сервисом DataLens.
Создана система визуализации KPI, позволяющая в реальном времени отслеживать распределение ресурсов.


## Заключение

Практическое выполнение работы позволило освоить полный цикл работы с данными: от проектирования DDL-схем и DML-наполнения до построения сложных аналитических выборок и BI-визуализаций. Полученные навыки позволяют автоматизировать отчетность и принимать управленческие решения на основе данных.

