Отчет по самостоятельной работе №1

Выполнил: Шокиров Егор Русланович

Группа: ЦИБ - 241

Вариант: 1

Цель работы

Научиться подключаться к базе данных PostgreSQL, создавать структуру данных, наполнять ее тестовыми данными и выполнять аналитические запросы. Построить визуализацию показателей KPI сотрудников в сервисе DataLens.

1. Подключение к базе данных

Работа была выполнена на локальном сервере. Для взаимодействия с СУБД PostgreSQL использовалась библиотека psycopg2. Проверка соединения произведена в среде Jupyter Notebook.

import psycopg2

# Параметры подключения к локальному серверу
connection = psycopg2.connect(
    user="postgres",
    password="your_password",
    host="127.0.0.1",
    port="5432",
    database="bi_sql_data_student"
)

cursor = connection.cursor()
print("Подключение к базе данных PostgreSQL на локальном сервере прошло успешно")


2. Создание структуры таблиц (DDL)

В рамках работы была спроектирована база данных для управления IT-проектами. В схеме project_management_st21 были созданы четыре таблицы, связанные между собой внешними ключами для обеспечения целостности данных.

SQL-код создания таблиц:

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
    end_date DATE,
    status VARCHAR(20) DEFAULT 'В работе'
);

CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(project_id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    due_date DATE,
    priority INTEGER CHECK (priority BETWEEN 1 AND 5)
);

CREATE TABLE assignments (
    assignment_id SERIAL PRIMARY KEY,
    task_id INTEGER REFERENCES tasks(task_id) ON DELETE CASCADE,
    employee_id INTEGER REFERENCES employees(employee_id) ON DELETE CASCADE,
    assigned_date DATE DEFAULT CURRENT_DATE
);


3. Наполнение данными (DML)

Для генерации репрезентативной аналитики таблицы были наполнены массивом тестовых данных:

15 сотрудников различных специализаций (разработка, аналитика, менеджмент).

5 ключевых задач, соответствующих основным направлениям деятельности компании.

50 записей в таблице назначений, реализующих кросс-функциональное взаимодействие.

-- Пример заполнения справочника проектов
INSERT INTO projects (project_name, start_date, status) VALUES 
('Автоматизация учета', '2024-03-01', 'В работе'),
('Внедрение BI', '2024-01-15', 'В работе'),
('Мобильное приложение', '2023-11-01', 'В работе'),
('Обновление сайта', '2024-03-20', 'В работе'),
('Разработка CRM', '2023-09-01', 'Завершен');


4. Аналитические запросы

Для формирования датасета в DataLens был составлен сложный аналитический запрос с использованием операторов JOIN. Запрос объединяет информацию о задачах, сотрудниках и статусах проектов в единую плоскую таблицу.

SELECT 
    t.title AS task_name,
    e.first_name || ' ' || e.last_name AS employee,
    e.role AS employee_role,
    t.priority,
    p.status AS project_status
FROM tasks t
JOIN projects p ON t.project_id = p.project_id
JOIN assignments a ON t.task_id = a.task_id
JOIN employees e ON a.employee_id = e.employee_id;


открыть файл dump

5. Визуализация в DataLens

На основе подготовленного датасета был разработан интерактивный дашборд «Project Management». Визуализация позволяет оценивать загрузку персонала и приоритизацию ресурсов в реальном времени.

Состав дашборда:

Ресурсный план по проектам: количественный анализ команд.

Карта концентрации ресурсов: матрица приоритетов.

Баланс стратегических приоритетов: мониторинг фокуса компании.

открыть дашборд

6. Результаты

В ходе выполнения самостоятельной работы были достигнуты следующие результаты:

Развернута и настроена локальная база данных PostgreSQL с оптимизированной структурой связей.

Сформирован качественный массив данных (50 записей), отражающий сложную структуру назначений сотрудников.

Реализован процесс связки SQL-базы с аналитическим сервисом визуализации.

Создана аналитическая панель, предоставляющая прозрачную отчетность по KPI и распределению ресурсов IT-департамента.

7. Заключение

Выполненная работа позволила на практике освоить полный цикл работы с данными: от проектирования DDL-схем и DML-наполнения до построения сложных аналитических выборок и BI-дашбордов. Полученные навыки позволяют автоматизировать отчетность и принимать управленческие решения на основе данных.
