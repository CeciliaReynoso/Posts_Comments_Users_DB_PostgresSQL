-- Active: 1729636694938@@127.0.0.1@5432@desafio3_Cecilia_Reynoso_648
CREATE DATABASE "desafio3_Cecilia_Reynoso_648";
-- Ingreso a la base de datos
CREATE TABLE usuarios(
  id SERIAL,
  email varchar(50),
  nombre varchar(50),  
  apellido varchar(50),
  rol varchar(16)
);
-- Ingreso de valores para cinco usuarios
INSERT INTO
       usuarios (email, nombre, apellido, rol)
VALUES
      ('vvelasquez@empresa.pe', 'Victor', 'Velasquez', 'administrador'),
      ('jguzman@empresa.pe', 'Juan', 'Guzman', 'usuario'),
      ('scastillo@empresa.pe', 'Susana', 'Del Castillo', 'usuario'),
      ('ochoy@empresa.pe', 'Oscar', 'Choy', 'usuario'),
      ('lallain@empresa.pe', 'Luis', 'Allain', 'usuario');
SELECT * FROM usuarios;
-- Creacion de la tabla posts
CREATE TABLE posts(
id SERIAL,
titulo VARCHAR,
contenido TEXT,
fecha_creacion TIMESTAMP,
fecha_actualizacion TIMESTAMP,
destacado BOOLEAN,
usuario_id BIGINT --conecta con el usuario redactor del post. 
);
-- Ingreso de cinco posts
INSERT INTO
       posts(titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES
      ('Titulo1', 'Contenido1', '2024-10-13 15:30:00.123456', '2024-10-13 15:32:00.123456', TRUE, 1),
      ('Titulo2', 'Contenido2', '2024-10-14 11:10:00.123456', '2024-10-14 11:12:00.123456', TRUE, 1),
      ('Titulo3', 'Contenido3', '2024-10-14 13:30:00.123456', '2024-10-14 13:32:00.123456', TRUE, 3),
      ('Titulo4', 'Contenido4', '2024-10-15 16:50:00.123456', '2024-10-15 16:52:00.123456', TRUE, 2),
      ('Titulo5', 'Contenido5', '2024-10-15 18:20:00.123456', '2024-10-15 18:22:00.123456', FALSE, NULL);
SELECT * FROM posts;
-- Creacion de la tabla Comentarios
CREATE TABLE comentarios(
id SERIAL,
contenido text,
fecha_creacion TIMESTAMP,
usuario_id BIGINT, -- conecta con el usuario que escribio el comentario
post_id BIGINT -- conecta con post_id
);
-- Valores para la tabla comentarios
INSERT INTO
       comentarios(contenido, fecha_creacion, usuario_id, post_id)
VALUES
      ('ContenidoDeComentario1', '2024-10-13 16:30:00.123456', 1, 1),
      ('ContenidoDeComentario2', '2024-10-14 12:10:00.123456', 2, 1),
      ('ContenidoDeComentario3', '2024-10-14 14:30:00.123456', 3, 1),
      ('ContenidoDeComentario4', '2024-10-15 17:05:00.123456', 1, 2),
      ('ContenidoDeComentario5', '2024-10-16 08:22:00.123456', 2, 2);
SELECT * FROM comentarios;
-- Inicio de consultas requeridas por el desafio 3
-- 2.- Cruza los datos de la tabla usuarios y posts, 
--     mostrando las siguientes columnas:nombre y email
--     del usuario junto al título y contenido del post.
SELECT usuarios.nombre, usuarios.email, posts.titulo, posts.contenido
FROM usuarios
LEFT JOIN posts
ON usuarios.id = posts.usuario_id;
-- 3.- Muestra el id, título y contenido de los posts de los administradores.
--     El administrador puede ser cualquier id.
SELECT usuarios.rol, usuarios.email, posts.id AS id_post, posts.titulo AS titulo_del_post, posts.contenido AS contenido_del_post
FROM posts
LEFT JOIN usuarios
ON usuarios.id = posts.usuario_id
WHERE rol = 'administrador';
-- 4.- Cuenta la cantidad de posts de cada usuario.
--     La tabla resultante debe mostrar el id e email del usuario junto con la
--     cantidad de posts de cada usuario.
SELECT usuarios.ID, usuarios.email, count(posts.usuario_id) AS cantidad_de_posts_por_usuario
FROM posts
LEFT JOIN usuarios
ON usuarios.id = posts.usuario_id
GROUP BY usuarios.id, usuarios.email
ORDER BY usuarios.id;
-- 5.- Muestra el email del usuario que ha creado más posts.
-- a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT usuarios.email AS usuario_con_mas_posts
FROM posts
LEFT JOIN usuarios
ON usuarios.id = posts.usuario_id
GROUP BY usuarios.id, usuarios.email
ORDER BY count(posts.usuario_id) DESC
LIMIT 1;
-- 6.- Muestra la fecha del último post de cada usuario. cumplir con usar max()
SELECT 
    p.usuario_id,
    u.email,
    p.fecha_creacion,
    p.fecha_actualizacion
FROM 
    posts p
LEFT JOIN 
    usuarios u ON p.usuario_id = u.id
WHERE 
    p.fecha_actualizacion = (
        SELECT 
            MAX(p2.fecha_actualizacion)
        FROM 
            posts p2
        WHERE 
            p2.usuario_id = p.usuario_id OR (p.usuario_id IS NULL AND p2.usuario_id IS NULL)
    )
    ORDER BY p.usuario_id;
--7.- Muestra el título y contenido del post (artículo) con más comentarios
SELECT posts.titulo AS titulo_post ,posts.contenido AS contenido_del_post,comentarios.post_id, count(comentarios.post_id) AS cant_comentarios_por_post
FROM comentarios
LEFT JOIN posts
ON posts.id = comentarios. post_id
GROUP BY comentarios.post_id, posts.titulo, posts.contenido;
ORDER BY count(*) DESC;
-- 8.- Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
--     de cada comentario asociado a los posts mostrados, junto con el email del usuario
--     que lo escribió.
SELECT
    posts.titulo AS titulo_post,
    posts.contenido AS contenido_del_post,
    usuarios.email AS creador_post,
    comentarios.contenido AS contenido_comentario,
    comentarios.usuario_id AS creador_comentario,
    u.email AS email_creador_comentario
FROM 
    posts
LEFT JOIN 
    comentarios ON posts.id = comentarios.post_id
LEFT JOIN 
    usuarios ON posts.usuario_id = usuarios.id
LEFT JOIN 
    usuarios u ON comentarios.usuario_id = u.id
ORDER BY 
    posts.titulo, comentarios.id;
-- 9.- Muestra el contenido del último comentario de cada usuario.
SELECT 
    c.usuario_id,
    u.email,
    c.fecha_creacion,
    c.contenido
FROM 
    comentarios c
LEFT JOIN 
    usuarios u ON c.usuario_id = u.id
WHERE 
    c.fecha_creacion = (
        SELECT 
            MAX(c2.fecha_creacion)
        FROM 
            comentarios c2
        WHERE 
            c2.usuario_id = c.usuario_id OR (c.usuario_id IS NULL AND c2.usuario_id IS NULL)
    )
ORDER BY 
    c.usuario_id;
-- 10.- Muestra los emails de los usuarios que no han escrito ningún comentario.
SELECT usuarios.email, count(comentarios.usuario_id) AS cantidad_de_posts_por_usuario
FROM usuarios
LEFT JOIN comentarios
ON usuarios.id = comentarios.usuario_id
GROUP BY usuarios.email
HAVING count(comentarios.usuario_id) = 0
-- Nota: Se ha guardado la query 'Setup_inicial'que contiene el punto 1: La creacion de la db y las tres tablas requeridas.
--       Separadamente, se ha guardado otra query 'Consultas' que contiene la logica para responder
--       a los requerimientos del 2 al 10 del Desafio 3 para que se puedan usar con valores distintos en las tablas.
--       Ambas queries se pueden encontrar abriendo le extención DATABASE CLIENT o en PJAdmin.
