/* SQL USUARIO */
CREATE TABLE `USUARIO` (
  `id_usu` int NOT NULL,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `apellidos` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NULL,
  `email` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `contrasenia` varchar(20) NOT NULL,
  `puntuacion`  INT NULL DEFAULT 0,
  `imagen` longblob
);


ALTER TABLE `USUARIO`
  ADD PRIMARY KEY (`id_usu`),
  ADD UNIQUE KEY `email` (`email`);
  
ALTER TABLE `USUARIO`
  MODIFY `id_usu` int NOT NULL AUTO_INCREMENT;
COMMIT;

/* SQL CATEGORIA */
CREATE TABLE `CATEGORIA` (
  `id_cat` int NOT NULL,
  `nombre` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL
);

ALTER TABLE `CATEGORIA`
  ADD PRIMARY KEY (`id_cat`);

ALTER TABLE `CATEGORIA`
  MODIFY `id_cat` int NOT NULL AUTO_INCREMENT;
COMMIT;

/* SQL PREGUNTA */
CREATE TABLE `PREGUNTA` (
  `id_preg` int NOT NULL,
  `titulo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `detalle` text CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `archivo` longblob COMMENT 'subir archivo',
  `visto` INT NULL DEFAULT 0,
  `id_cat` int NOT NULL
);

ALTER TABLE `PREGUNTA`
  ADD PRIMARY KEY (`id_preg`),
  ADD KEY `id_cat` (`id_cat`);

ALTER TABLE `PREGUNTA` 
  ADD `fecha` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE `PREGUNTA`
  MODIFY `id_preg` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `PREGUNTA`
  ADD CONSTRAINT `PREGUNTA_ibfk_1` FOREIGN KEY (`id_cat`) REFERENCES `CATEGORIA` (`id_cat`);

/* SQL RESPUESTA */
CREATE TABLE `RESPUESTA` (
  `id_res` int NOT NULL,
  `descripcion` text CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `id_preg` int NOT NULL,
  `archivo` longblob NULL
);

ALTER TABLE `RESPUESTA`
    ADD CONSTRAINT res_idpreg_fk
    FOREIGN KEY (`id_preg`)
    REFERENCES `PREGUNTA`(`id_preg`);

ALTER TABLE `RESPUESTA`
  ADD PRIMARY KEY (`id_res`);
  
ALTER TABLE `RESPUESTA`
  MODIFY `id_res` int NOT NULL AUTO_INCREMENT;
COMMIT;

/* SQL PREGUNTAR */
CREATE TABLE PREGUNTAR (
  cod_preg int PRIMARY KEY ,
  id_usu    int,
  id_preg   int,

  CONSTRAINT id_usu_fk FOREIGN KEY (id_usu)
  REFERENCES USUARIO(id_usu) ON DELETE CASCADE,
  CONSTRAINT  id_preg_fk FOREIGN KEY (id_preg)
  REFERENCES PREGUNTA(id_preg) ON DELETE CASCADE
);

ALTER TABLE `PREGUNTAR`
  MODIFY `cod_preg` int NOT NULL AUTO_INCREMENT;

/* SQL RESPONDER */
CREATE TABLE RESPONDER (
  cod_res   int PRIMARY KEY,
  id_usu    int,
  id_res   int,
  CONSTRAINT res_usu_fk FOREIGN KEY (id_usu)
        REFERENCES USUARIO(id_usu) ON DELETE CASCADE,
  CONSTRAINT  id_res_fk FOREIGN KEY (id_res)
        REFERENCES RESPUESTA( id_res) ON DELETE CASCADE
);

ALTER TABLE `RESPONDER`
  MODIFY `cod_res` int NOT NULL AUTO_INCREMENT;
COMMIT;

CREATE TABLE VOTAR (
  id_usu   int,
  id_res  int,
  CONSTRAINT vot_usu_fk FOREIGN KEY (id_usu)
        REFERENCES USUARIO(id_usu) ON DELETE CASCADE,
  CONSTRAINT  id_vot_fk FOREIGN KEY (id_res)
        REFERENCES RESPUESTA( id_res) ON DELETE CASCADE,
  PRIMARY KEY (id_usu, id_res) 
);

CREATE TABLE GUSTAR (
  id_usu   int,
  id_preg  int,
  CONSTRAINT gust_usu_fk FOREIGN KEY (id_usu)
        REFERENCES USUARIO(id_usu) ON DELETE CASCADE,
  CONSTRAINT  id_gust_fk FOREIGN KEY (id_preg)
        REFERENCES PREGUNTA( id_preg) ON DELETE CASCADE,
  PRIMARY KEY (id_usu, id_preg)       
);

/* VISTA PARA CONSEGUIR CANTIDAD DE RESPUESTAS DE UNA PREGUNTA */
CREATE VIEW countRespuestas AS 
SELECT p.id_preg, IFNULL(COUNT(r.id_preg),0) "respuestas"
FROM PREGUNTA p
LEFT JOIN RESPUESTA r ON p.id_preg = r.id_preg
GROUP BY p.id_preg;

/* VISTA PARA CONSEGUIR CANTIDAD LIKES DE UNA PREGUNTA */
CREATE VIEW countLikes AS 
SELECT p.id_preg, IFNULL(COUNT(g.id_preg),0) "like"
FROM PREGUNTA p
LEFT JOIN GUSTAR g ON g.id_preg = p.id_preg
GROUP BY p.id_preg;

/* VISTA PARA CONSEGUIR CANTIDAD VOTOS DE UNA RESPUESTA */
CREATE VIEW countVotos AS 
SELECT r.id_res, IFNULL(COUNT(v.id_res),0) "voto"
FROM RESPUESTA r
LEFT JOIN VOTAR v ON v.id_res = r.id_res
GROUP BY r.id_res;

/* VISTA PARA LA VISUALIZACI??N PREGUNTAS */
CREATE VIEW vistaPreguntas AS
SELECT u.id_usu "id_usu", u.nombre "usuario", u.puntuacion "valoracion", p.titulo "titulo", c.nombre "categoria", p.fecha "fecha", p.id_preg "id_preg", p.detalle "detalle", p.visto "vistos", c.id_cat "id_cat", cl.like "likes", cr.respuestas "respuestas"
FROM USUARIO u, PREGUNTA p, CATEGORIA c, PREGUNTAR pr, countLikes cl, countRespuestas cr
WHERE u.id_usu = pr.id_usu
AND p.id_cat = c.id_cat
AND p.id_preg = pr.id_preg
AND cl.id_preg = p.id_preg 
AND cr.id_preg = p.id_preg 
ORDER BY p.id_preg;

/* VISTA PARA LA VISUALIZACI??N DE RESPUESTAS */
CREATE VIEW vistaRespuestas AS
SELECT u.id_usu "id_usu", u.nombre "usuario", u.puntuacion "valoracion", r.descripcion "descripcion", r.id_res "id_res", p.id_preg "id_preg", cv.voto "votos"
FROM USUARIO u, RESPUESTA r, RESPONDER rr, PREGUNTA p, countVotos cv
WHERE u.id_usu = rr.id_usu
AND r.id_res = rr.id_res
AND p.id_preg = r.id_preg
AND cv.id_res = r.id_res
ORDER BY r.id_res;



/* INSERTAR DATOS BASE */
INSERT INTO `CATEGORIA`(`nombre`) VALUES ('Aviacion');
INSERT INTO `CATEGORIA`(`nombre`) VALUES ('Dirigibles');
INSERT INTO `CATEGORIA`(`nombre`) VALUES ('Aeroespacio');
INSERT INTO `CATEGORIA`(`nombre`) VALUES ('Parques aeronauticos');
INSERT INTO `CATEGORIA`(`nombre`) VALUES ('Seguridad Aerea');

INSERT INTO `USUARIO`(`nombre`, `apellidos`, `email`, `contrasenia`) VALUES ('Fernando','Gonzalez','fernando@gmail.com','fernando');
INSERT INTO `USUARIO`(`nombre`, `apellidos`, `email`, `contrasenia`) VALUES ('Pepe','Fernandez','pepe@gmail.com','pepe');
INSERT INTO `USUARIO`(`nombre`, `apellidos`, `email`, `contrasenia`) VALUES ('Angel','Rodriguez','angel@gmail.com','angel');
INSERT INTO `USUARIO`(`nombre`, `apellidos`, `email`, `contrasenia`) VALUES ('Mauro','Arambarri','mauro@gmail.com','mauro');
INSERT INTO `USUARIO`(`nombre`, `apellidos`, `email`, `contrasenia`) VALUES ('Kike','Garcia','kike@gmail.com','kike');
INSERT INTO `USUARIO`(`nombre`, `email`, `contrasenia`) VALUES ('Amaia','amaia@gmail.com','amaia');

INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`,`fecha`) VALUES ('??Qu?? es la regla Paretto y d??nde podr??a aplicarse este princicpio?','No hab??a conocido esta ley hasta el d??a de hoy, pero imagino que su aplicaci??n en la meteorolog??a aeron??utica tiene que ver con la utilizaci??n de una escala meteorol??gica menor (mesoescala e incluso microescala) que son aquellas escalas en la que est??n los fen??menos que afectan a la aeronavegaci??n (tormentas, downburst, microburst, etc). Tienen una extensi??n y una duraci??n menor que la escala sin??ptica (ser??an el 20 de esa ley, pero generar??an el 80% de los problemas que afectan a la navegaci??n a??rea).',1,8, '2022-11-4 21:25:32');
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`,`fecha`) VALUES ('??Qu?? problemas puede causar una tormenta en los alrededores de un aeropuerto?','Un avi??n en la aproximaci??n final puede encontrar una fuerte ascendencia debida a la parte exterior del torbellino horizontal creado por rebote del "downburst". Quiz?? la reacci??n del piloto sea la de bajar el morro del avi??n, lo cual no puede ser m??s desaconsejable, ya que inmediatamente se encontrar?? la intensa corriente descendente y con tal presentaci??n del avi??n, las consecuencias pueden ser fatales.',2,31, '2022-11-14 22:25:32');
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`,`fecha`) VALUES ('??Qu?? significa VNE? ??Qu?? pasa si no se cumple?','No debe confundirse el "downburst" con el tornado; son fen??menos de extensi??n parecida y a veces efectos similares, pero hay una diferencia esencial: en el "downburst" las corrientes son descendentes, mientras que en el tornado se combinan ascendentes y en espiral. Acaso para la peque??a aviaci??n revistan especial peligrosidad los procedentes de las tormentas secas por ser mas dif??ciles de localizar y en buena parte de los casos casi imposible identificar visualmente.',3,21, '2022-11-15 15:25:32');
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`,`fecha`) VALUES ('??Por qu?? es importante el pron??stico del viento en un aeropuerto?','La turbulencia por cortante de viento (o cizalladura del viento) se produce cuando hay un cambio brusco en la velocidad y/o direcci??n del viento. A grandes alturas este tipo de turbulencia se denomina CAT (Turbulencia en aire claro) y se asocia en general a la corriente en chorro. No se asocia a nubosidad de all?? su nombre y por lo tanto no puede reconocerse a simple vista.',4,56, '2022-11-20 11:25:32');
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`,`fecha`) VALUES ('??Qu?? significa "alternate"?','La turbulencia mec??nica se debe a los torbellinos que se generan en el aire al chocar con diferentes obst??culos en la superficie. Puede verse incrementada en el caso de aire inestable y tambi??n debido a la presencia de una barrera orogr??fica. Las ondas de monta??a generan turbulencia moderada o severa y su manifestaci??n visible son los altoc??mulos lenticulares que se forman en esas ondas.',5,3, '2022-11-20 07:25:32');
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`,`fecha`) VALUES ('??Est??n todos los vuelos del planeta controlados por radar?','Lo que se intenta arreglar mediante radares extra, helipuertos, etc??tera. Lo mismo ocurre en otros pa??ses, interesados en erradicarlo para evitar accidentes y, tambi??n, aviones clandestinos.',1,9, '2022-11-11 11:11:32');
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`,`fecha`) VALUES ('??Puede un rayo alcanzar a un avi??n y hacerlo caer?','Eso s??, cuando ocurre, se revisa bien el avi??n por si acaso, especialmente la zona delantera.',3,2, '2022-11-22 21:25:32');
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`) VALUES ('??Por qu?? las ventanillas son redondas?','Por puro aerodinamismo. El Havilland Comet, que fue el primer avi??n comercial, ten??a ventanas cuadradas y, tras accidentes varios, algunos mortales, se vio que fue un importante error de dise??o. Todo debido a que la presi??n dentro y fuera de la cabina afecta a las esquinas de las ventanas cuadradas, provocando fallas estructurales.',2,1);
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`) VALUES ('??Por qu?? no est??n alineadas las ventanillas y los asientos?','Adem??s, el peque??o agujero ubicado en la parte baja de las ventanas ayuda a regular la presi??n que la ventana resiste, y asegura que sean los paneles exteriores los que se rompen en caso de emergencia.',4,3);
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`) VALUES ('??Una turbulencia puede ser suficientemente fuerte como para abatir un avi??n?','Se trata de una armonizaci??n casi imposible de conseguir, ya que los aviones tienen un dise??o espec??fico en su fuselaje que implica, claro, a las ventanillas. Mientras que el dise??o de este depende de las constructoras, el interior permite mayores cambios por las compa????as.',5,8);
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`) VALUES ('??Qu?? pasa si todos los motores del avi??n se rompen o apagan al mismo tiempo?','De hecho, el aparato se convertir??a en un planeador y har??a justo eso: planear hasta el aeropuerto o zona espec??fica de aterrizaje m??s cercana.',1,11);
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`) VALUES ('??Es verdad que los aviones tiran los desechos del ba??o en el aire?','suelen ser restos que no se han derretido bien de una gotera o fuga, no de un avi??n en perfecto funcionamiento.',1,14);
INSERT INTO `PREGUNTA`(`titulo`, `detalle`, `id_cat`,`visto`) VALUES (' ??Por qu?? no se puede usar el tel??fono m??vil durante un vuelo?', 'necesito poder estuchar musica en spotify (no premium) durante el vuelo para no sufrir un ataque de panico',1,8);


INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('La regla o ley de Paretto (la Regla del 80/20) significa que el 20% de algo es esencial y el 80% es trivial. El 20% de los defectos causan el 80% de los problemas, el 20% del trabajo consume el 80% del tiempo y los recursos. La regla del 80/20 tambi??n se aplica a las ventas (el 20% de los clientes produce el 80% de los beneficios; o el 20% de los vendedores realiza el 80% de las ventas) o a cualquier otra cosa (el 20% del diario trae el 80% de las noticias importantes, o que el 20% de los empleados causan el 80% de los problemas).',1);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('Las aeronaves que llegan o parten del aeropuerto podr??an encontrarse con granizo, engelamiento, turbulencia e incluso en casos extremos con fuertes descendentes (microrr??fagas o downburst: macroburst o microburst) que podr??an tener graves consecuencias. Las llamadas en ingl??s "downburst" al llegar al suelo se extienden con violencia. No s??lo se forman los temidos "downburst" en las fases de comienzo del estado de madurez de un proceso tormentoso, es decir, en el llamado "revent??n" en muchos pa??ses de habla hispana, sino que tambi??n se pueden presentar en tormentas secas.',1);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('VNE es la velocidad de nunca exceder. Se marca con una l??nea roja en muchos indicadores de velocidad a??rea y var??a en cada aeronave. Exceder VNE da lugar a una p??rdida de control e incluso puede producir fallas estructurales. No es seguro volar en o cerca de VNE en condiciones de turbulencia.',2);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('Cambios en la direcci??n o velocidad del viento tienen implicancias directas en las operaciones del aer??dromo. De acuerdo a la direcci??n del viento se define qu?? cabecera de pista se emplear?? en las operaciones de despegue y aterrizaje. Adem??s, las aeronaves tienen limitaciones respecto de la componente de viento cruzado (que a su vez var??an si la pista est?? seca o mojada).',3);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('Significa alternativa, o aeropuerto de alternativa. En los planes de vuelo se establecen de antemano a qu?? aeropuertos se va a dirigir la aeronave en caso de que el aeropuerto de destino se encuentre cerrado o en caso de que la aeronave tenga alg??n problema y no pueda llegar al aeropuerto de destino. El aeropuerto de alternativa a seleccionar para cualquier destino,deber?? garantizar con la mayor probabilidad de ??xito el aterrizaje en caso que el aeropuerto de destino se encuentre bajo m??nimos, contemplando las limitaciones de techo y visibilidad (no de distancia de vuelo) de la categor??a que reviste el piloto.',4);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('Se usa el QNH. EL QNH es la presi??n al nivel del mar deducida de la existente en el aer??dromo, considerando la atm??sfera en condiciones est??ndar. La utilidad de esta presi??n de referencia se debe a que en las cartas de navegaci??n y de aproximaci??n a los aer??dromos, las altitudes se indican respecto al nivel del mar. Con esta presi??n de referencia, al despegar o aterrizar el alt??metro deber??a indicar la altitud real del aer??dromo.',2);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('No. Al contrario, hay muchas zonas llamadas de sombra. Las principales son los oc??anos, pero tambi??n en grandes desiertos e incluso en pa??ses con mucha orograf??a.',6);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('No. La fabricaci??n actual de los aviones impide que el aparato se caiga por el impacto de un rayo. De hecho, es relativamente frecuente que los rayos choquen con un avi??n, pero las aeronaves no se ven afectadas (m??nimo hay un reporte anual de este suceso).',7);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('Hay personas que han visto caer agua azul petrificada, como la que se usa en los retretes, pero suelen ser restos que no se han derretido bien de una gotera o fuga',9);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('No. Solo ha ocurrido una vez en la historia de la aviaci??n que un aparato se precipitara por culpa de una turbulencia y fue debido a una suma de varios factores, adem??s de sobrevolar una zona que estaba prohibida.',10);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('Aunque la posibilidad de que ocurra es extremadamente baja (y solo se recuerda un caso en toda la historia de la aviaci??n), los propios pilotos mantienen la calma.',11);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('No. De hecho, es imposible que los retretes se vac??en en el aire porque la v??lvula que permite realizar esa acci??n est?? ubicada en el exterior del aparato. Hay personas que han visto caer agua azul petrificada, como la que se usa en los retretes,',12);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('No. Solo ha ocurrido una vez en la historia de la aviaci??n que un aparato se precipitara por culpa de una turbulencia y fue debido a una suma de varios factores, adem??s de sobrevolar una zona que estaba prohibida.',2);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('Aunque la posibilidad de que ocurra es extremadamente baja (y solo se recuerda un caso en toda la historia de la aviaci??n), los propios pilotos mantienen la calma.',2);
INSERT INTO `RESPUESTA`(`descripcion`,`id_preg`) VALUES ('Uno de los mayores problemas durante una tormenta es el aterrizaje. El Internet est?? lleno de videos que muestran c??mo los aviones quedan atrapados en corrientes y son movidos de un lado a otro por los vientos cruzados durante el aterrizaje.',2);


INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (6,1);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (2,2);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (3,3);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (4,4);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (5,5);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (1,6);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (4,7);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (2,8);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (3,9);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (4,10);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (5,11);
INSERT INTO `PREGUNTAR`(`id_usu`, `id_preg`) VALUES (1,12);

INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (1,1);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (2,2);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (3,3);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (4,4);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (5,5);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (6,6);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (1,7);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (3,8);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (6,9);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (5,10);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (5,11);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (2,12);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (1,13);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (3,14);
INSERT INTO `RESPONDER`(`id_usu`, `id_res`) VALUES (2,15);

INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (1,1);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (2,1);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (3,1);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (1,2);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (1,3);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (2,2);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (5,4);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (3,2);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (5,9);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (4,12);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (4,4);
INSERT INTO `VOTAR`(`id_usu`,`id_res`) VALUES (2,4);

INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (1,1);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (2,3);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (2,10);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (4,2);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (3,9);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (2,8);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (4,7);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (4,12);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (1,5);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (3,5);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (5,11);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (5,2);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (4,9);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (5,9);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (1,9);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (2,9);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (5,1);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (6,2);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (6,3);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (6,4);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (6,5);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (3,3);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (4,3);
INSERT INTO `GUSTAR`(`id_usu`,`id_preg`) VALUES (1,3);