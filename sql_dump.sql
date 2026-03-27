-- 1. ПОДГОТОВКА СРЕДЫ
CREATE SCHEMA IF NOT EXISTS project_management_st21;
SET search_path TO project_management_st21;

-- СБРОС: Удаляем таблицы со всеми зависимостями (CASCADE)
DROP TABLE IF EXISTS assignments CASCADE;
DROP TABLE IF EXISTS tasks CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS employees CASCADE;

-- 2. СОЗДАНИЕ ТАБЛИЦ (DDL)
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

-- 3. НАПОЛНЕНИЕ ДАННЫМИ (DML)

-- Сотрудники 
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

-- Проекты и Задачи
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

-- Назначения

-- 1. Автоматизация учета
INSERT INTO assignments (task_id, employee_id) VALUES (1,1),(1,3),(1,8),(1,9),(1,12),(1,15),(1,13),(1,10);
-- 2. Внедрение BI 
INSERT INTO assignments (task_id, employee_id) VALUES (2,1),(2,3),(2,2),(2,4),(2,6),(2,9),(2,12),(2,10),(2,15),(2,14),(2,8),(2,11);
-- 3. Мобильное приложение
INSERT INTO assignments (task_id, employee_id) VALUES (3,2),(3,5),(3,7),(3,13),(3,4),(3,6),(3,8),(3,9),(3,11),(3,1);
-- 4. Обновление сайта
INSERT INTO assignments (task_id, employee_id) VALUES (4,5),(4,7),(4,14),(4,2),(4,13),(4,4);
-- 5. Разработка CRM
INSERT INTO assignments (task_id, employee_id) VALUES (5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(5,7),(5,8),(5,9),(5,10),(5,11),(5,12),(5,13),(5,14);

-- 4. ПРОВЕРКА И ЭКСПОРТ
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