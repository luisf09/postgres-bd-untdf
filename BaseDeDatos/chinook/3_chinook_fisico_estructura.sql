
--
START TRANSACTION;

------------
-- TABLAS --
------------

-- GENERO
CREATE TABLE genero(
    codigo INTEGER PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL UNIQUE
);

-- MEDIO
CREATE TABLE medio(
    codigo  INTEGER PRIMARY KEY,
    nombre  VARCHAR(120) NOT NULL UNIQUE
);

-- ARTISTA
CREATE TABLE artista(
    codigo INTEGER PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL UNIQUE
);

-- ALBUM
CREATE TABLE album(
    codigo  INTEGER PRIMARY KEY,
    titulo  VARCHAR(160) NOT NULL,
    artista INTEGER NOT NULL REFERENCES artista ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE(artista, titulo)
);
CREATE INDEX fk_album_artista ON album(artista);

-- PISTA
CREATE TABLE pista(
    codigo     INTEGER PRIMARY KEY,
    nombre     VARCHAR(200) NOT NULL,
    album      INTEGER NOT NULL REFERENCES album  ON UPDATE CASCADE ON DELETE RESTRICT,
    medio      INTEGER NOT NULL REFERENCES medio  ON UPDATE CASCADE ON DELETE RESTRICT,
    genero     INTEGER NOT NULL REFERENCES genero ON UPDATE CASCADE ON DELETE RESTRICT,
    compositor VARCHAR(220),
    duracion   INTEGER NOT NULL,
    bytes      INTEGER NOT NULL,
    precio     DECIMAL(10,2) NOT NULL
);
CREATE INDEX fk_pista_album  ON pista(album);
CREATE INDEX fk_pista_medio  ON pista(medio);
CREATE INDEX fk_pista_genero ON pista(genero);

-- EMPLEADO
CREATE TABLE empleado(
    codigo       INTEGER PRIMARY KEY,
    apellido     VARCHAR(20) NOT NULL,
    nombre       VARCHAR(20) NOT NULL,
    titulo       VARCHAR(30),
    reportaa     INTEGER REFERENCES empleado ON UPDATE CASCADE ON DELETE RESTRICT,
    nacimiento   TIMESTAMP NOT NULL,
    contratado   TIMESTAMP NOT NULL,
    direccion    VARCHAR(70) NOT NULL,
    ciudad       VARCHAR(40) NOT NULL,
    provincia    VARCHAR(40),
    pais         VARCHAR(40) NOT NULL,
    codigopostal VARCHAR(10),
    telefono     VARCHAR(24),
    fax          VARCHAR(24),
    correo       VARCHAR(60) NOT NULL,
    UNIQUE(apellido, nombre)
);
CREATE INDEX fk_empleado_reportaa ON empleado(reportaa);

-- CLIENTE
CREATE TABLE cliente(
    codigo       INTEGER PRIMARY KEY,
    nombre       VARCHAR(40) NOT NULL,
    apellido     VARCHAR(20) NOT NULL,
    empresa      VARCHAR(80),
    direccion    VARCHAR(70) NOT NULL,
    ciudad       VARCHAR(40) NOT NULL,
    provincia    VARCHAR(40),
    pais         VARCHAR(40) NOT NULL,
    codigopostal VARCHAR(10),
    telefono     VARCHAR(24),
    fax          VARCHAR(24),
    correo       VARCHAR(60) NOT NULL,
    soporte      INTEGER REFERENCES empleado ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE(apellido, nombre)
);
CREATE INDEX fk_cliente_soporte ON cliente(soporte);

-- FACTURA
CREATE TABLE factura(
    codigo            INTEGER PRIMARY KEY,
    cliente           INTEGER NOT NULL REFERENCES CLIENTE ON UPDATE CASCADE ON DELETE RESTRICT,
    fecha             TIMESTAMP NOT NULL,
    direccionenvio    VARCHAR(70) NOT NULL,
    ciudadenvio       VARCHAR(40) NOT NULL,
    provinciaenvio    VARCHAR(40),
    paisenvio         VARCHAR(40) NOT NULL,
    codigopostalenvio VARCHAR(10),
    total             DECIMAL(10,2) NOT NULL
);
CREATE INDEX fk_factura_cliente ON factura(cliente);

-- LINEA FACTURA
CREATE TABLE facturalinea(
    codigo   INTEGER PRIMARY KEY,
    factura  INTEGER NOT NULL REFERENCES factura ON UPDATE CASCADE ON DELETE RESTRICT,
    pista    INTEGER NOT NULL REFERENCES pista   ON UPDATE CASCADE ON DELETE RESTRICT,
    precio   DECIMAL(10,2) NOT NULL,
    cantidad INTEGER NOT NULL
);
CREATE INDEX fk_facturalinea_factura ON facturalinea(factura);
CREATE INDEX fk_facturalinea_pista   ON facturalinea(pista);

-- LISTA REPRODUCCION
CREATE TABLE listareproduccion(
    codigo INTEGER PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL UNIQUE
);

-- PISTA LISTA REPRODUCCION
CREATE TABLE pistalistareproduccion(
    lista INTEGER NOT NULL REFERENCES listareproduccion ON UPDATE CASCADE ON DELETE CASCADE,
    pista INTEGER NOT NULL REFERENCES pista             ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY(lista, pista)
);
CREATE INDEX fk_pistalistareproduccion_lista ON pistalistareproduccion(lista);
CREATE INDEX fk_pistalistareproduccion_pista ON pistalistareproduccion(pista);

--
COMMIT;