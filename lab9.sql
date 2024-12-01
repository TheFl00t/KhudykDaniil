DROP TABLE IF EXISTS  task_participant;
DROP TABLE IF EXISTS  project_file;
DROP TABLE IF EXISTS  task_file;
DROP TABLE IF EXISTS  files;
DROP TABLE IF EXISTS  project_participant;
DROP TABLE IF EXISTS  tasks;
DROP TABLE IF EXISTS  participants;
DROP TABLE IF EXISTS  projects;

CREATE TABLE projects (
	id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	name VARCHAR(255) NOT NULL UNIQUE,
	context TEXT,
	PRIMARY KEY(id)
);

CREATE TABLE participants (
	id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	name VARCHAR(255) NOT NULL,
	position VARCHAR(255),
	PRIMARY KEY(id)
);

CREATE TABLE tasks (
	id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	name VARCHAR(255) NOT NULL,
	description TEXT,
	author_id INTEGER UNSIGNED NOT NULL,
	project_id INTEGER NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (project_id) REFERENCES projects(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE project_participant (
	project_id INTEGER NOT NULL,
	participant_id INTEGER NOT NULL,
	role VARCHAR(50) DEFAULT 'executor',
	PRIMARY KEY(project_id, participant_id),
	FOREIGN KEY (project_id) REFERENCES projects(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (participant_id) REFERENCES participants(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE files (
	id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	name VARCHAR(50),
	link VARCHAR(255) NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE task_file (
	task_id INTEGER NOT NULL,
	file_id INTEGER NOT NULL,
	PRIMARY KEY(task_id, file_id),
	FOREIGN KEY (task_id) REFERENCES tasks(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (file_id) REFERENCES files(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE project_file (
	project_id INTEGER NOT NULL,
	file_id INTEGER NOT NULL,
	PRIMARY KEY(project_id, file_id),
	FOREIGN KEY (project_id) REFERENCES projects(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (file_id) REFERENCES files(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE task_participant (
	task_id INTEGER NOT NULL,
	participant_id INTEGER NOT NULL,
	role VARCHAR(50) DEFAULT 'executor',
	PRIMARY KEY(task_id, participant_id),
	FOREIGN KEY (task_id) REFERENCES tasks(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (participant_id) REFERENCES participants(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- -- -- -- --

-- Триггеры
-- Добавление участника в project_participant, если добавили в task_participant
DROP TRIGGER IF EXISTS add_participant_to_project;

DELIMITER $$

CREATE TRIGGER add_participant_to_project
AFTER INSERT ON task_participant
FOR EACH ROW
BEGIN
    INSERT INTO project_participant (project_id, participant_id, role)
    SELECT t.project_id, NEW.participant_id, NEW.role
    FROM tasks t
    WHERE t.id = NEW.task_id
      AND NOT EXISTS (
          SELECT 1
          FROM project_participant pp
          WHERE pp.project_id = t.project_id AND pp.participant_id = NEW.participant_id
      );
END $$

DELIMITER ;
-- Удаляем участника из project_participant, если он больше не участвует в любых задачах этого проекта
DROP TRIGGER IF EXISTS delete_participant_from_project;

DELIMITER $$

CREATE TRIGGER delete_participant_from_project
AFTER DELETE ON task_participant
FOR EACH ROW
BEGIN
    DELETE FROM project_participant
    WHERE project_id = (
        SELECT project_id
        FROM tasks
        WHERE id = OLD.task_id
    )
    AND participant_id = OLD.participant_id
    AND NOT EXISTS (
        SELECT 1
        FROM task_participant tp
        JOIN tasks t ON tp.task_id = t.id
        WHERE tp.participant_id = OLD.participant_id
        AND t.project_id = (
            SELECT project_id
            FROM tasks
            WHERE id = OLD.task_id
        )
        AND tp.task_id != OLD.task_id
    );
END $$

DELIMITER ;

-- Добавление файла в project_file, если добавили в task_file
DROP TRIGGER IF EXISTS add_file_to_project;

DELIMITER $$

CREATE TRIGGER add_file_to_project
AFTER INSERT ON task_file
FOR EACH ROW
BEGIN
	INSERT INTO project_file (project_id, file_id)
	SELECT t.project_id, NEW.file_id 
	FROM tasks t
	WHERE t.id = NEW.task_id
		AND NOT EXISTS (
			SELECT 1
			FROM project_file pf
			WHERE pf.project_id = t.project_id AND pf.file_id = NEW.file_id
		);
END $$

DELIMITER ;
-- Удаляем файл из project_file, если он больше не используется в любых задачах этого проекта
DROP TRIGGER IF EXISTS remove_file_from_project;

DELIMITER $$

CREATE TRIGGER remove_file_from_project
AFTER DELETE ON task_file
FOR EACH ROW
BEGIN
    DELETE FROM project_file
    WHERE project_id = (
        SELECT project_id
        FROM tasks
        WHERE id = OLD.task_id
    )
    AND file_id = OLD.file_id
		AND NOT EXISTS (
			SELECT 1
			FROM task_file tf
			JOIN tasks t ON tf.task_id = t.id
			WHERE tf.file_id = OLD.file_id
			AND t.project_id = (
            SELECT project_id
            FROM tasks
            WHERE id = OLD.task_id
			)
		);
END $$

DELIMITER ;

-- -- -- -- --

-- Заполнение таблиц
-- TABLE: projects
INSERT INTO projects (name, context)
VALUES
    ('Online Coding Platform', '...'),
    ('Code Review Tool', '...'),
    ('AI Programming Assistant', '...');

-- TABLE: participants
INSERT INTO participants (name, position)
VALUES
    ('Daniil Khudyk', 'Backend Developer'),
    ('Bob Lee', 'Frontend Developer'),
    ('Charlie Adams', 'Product Manager'),
    ('Will Smith', 'Quality Assurance Engineer'),
    ('WhoIsThis', 'UX/UI Designer');

-- TABLE: tasks
INSERT INTO tasks (name, description, author_id, project_id)
VALUES
    ('Create Database Schema', 'Design the database schema...', 1, 1),
    ('Develop User Authentication', 'Implement user...', 2, 1),
    ('Implement Code Editor', 'Create a web-based...', 1, 2),
    ('Write Test Cases for UI', 'Develop test cases to...', 4, 3);
	
-- TABLE: files
INSERT INTO files (name, link)
VALUES
    ('File1', 'https://imgur.com/a/8GnRInd'),
    ('File2', 'https://path/to/file2'),
    ('File3', 'https://path/to/file3'),
    ('File4', 'https://path/to/file4');

-- Соединение таблиц
-- TABLE: task_participant
INSERT INTO task_participant (task_id, participant_id, role)
VALUES
    (1, 1, 'Backend Developer'),
    (1, 2, 'Frontend Developer'),
    (2, 1, 'Backend Developer'),
    (2, 5, 'UX/UI Designer'),
    (3, 4, 'Quality Assurance Engineer'), 
    (4, 3, 'Product Manager'); 
	
-- TABLE: task_file
INSERT INTO task_file (task_id, file_id)
VALUES
    (1, 1),
    (1, 2),
    (1, 4),
    (2, 1),
    (2, 2),
    (3, 2),
    (3, 4),
    (4, 3);

-- -- -- -- --

--
-- ADD participant
INSERT INTO task_participant (task_id, participant_id, role)
VALUES (1, 1, '');

-- DELETE participant
DELETE FROM task_participant
WHERE task_id = 1 AND participant_id = 1;

--
-- ADD file
INSERT INTO task_file (task_id, file_id)
VALUES (1, 1);

-- DELETE file
DELETE FROM task_file
WHERE task_id = 1 AND file_id = 1;
