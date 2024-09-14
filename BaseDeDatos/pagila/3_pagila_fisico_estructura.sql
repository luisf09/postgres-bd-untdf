
--
START TRANSACTION;

--------------
-- DOMINIOS --
--------------

-- Por compatibilidad con los estandars
CREATE DOMAIN BLOB AS BYTEA;
CREATE DOMAIN CLOB AS TEXT;

-- TIPO CALIFICACION
CREATE DOMAIN CALIFICACION AS VARCHAR(5) CHECK(VALUE IN ('G', 'PG', 'PG-13', 'R', 'NC-17'));

-- TIPO AÑO
CREATE DOMAIN AÑO AS INTEGER CHECK(VALUE BETWEEN 1900 AND 2100);

------------
-- TABLAS --
------------

-- ACTOR
CREATE TABLE actor (
    codigo      INTEGER     PRIMARY KEY,
    nombre      VARCHAR(45) NOT NULL,
    apellido    VARCHAR(45) NOT NULL,
    actualizado TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CATEGORIA
CREATE TABLE categoria (
    codigo      INTEGER     PRIMARY KEY,
    nombre      VARCHAR(25) NOT NULL,
    actualizado TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- IDIOMA
CREATE TABLE idioma (
    codigo      INTEGER     PRIMARY KEY,
    nombre      VARCHAR(20) UNIQUE NOT NULL,
    actualizado TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- PELICULA
CREATE TABLE pelicula (
    codigo           INTEGER      PRIMARY KEY,
    titulo           VARCHAR(255) NOT NULL,
    descripcion      CLOB,
    año              AÑO,
    idioma           SMALLINT     NOT NULL REFERENCES idioma ON UPDATE CASCADE ON DELETE RESTRICT,
    idiomaoriginal   SMALLINT              REFERENCES idioma ON UPDATE CASCADE ON DELETE RESTRICT,
    duracion         SMALLINT     NOT NULL DEFAULT 3,
    precio           NUMERIC(4,2) NOT NULL DEFAULT 4.99,
    largo            SMALLINT,
    costo            NUMERIC(5,2) NOT NULL DEFAULT 19.99 ,
    calificacion     CALIFICACION NOT NULL DEFAULT 'G',
    actualizado      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    caracteristicas  VARCHAR(100)[],
    texto            TSVECTOR NOT NULL
);
CREATE INDEX pelicula_idioma_idx ON pelicula(idioma);
CREATE INDEX pelicula_idiomaoriginal_idx ON pelicula(idiomaoriginal);

-- PELICULA Y ACTOR
CREATE TABLE pelicula_actor (
    actor       INTEGER   NOT NULL REFERENCES actor    ON UPDATE CASCADE ON DELETE RESTRICT,
    pelicula    INTEGER   NOT NULL REFERENCES pelicula ON UPDATE CASCADE ON DELETE CASCADE,
    actualizado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(pelicula, actor)
);
CREATE INDEX pelicula_actor_actor_idx ON pelicula_actor(actor);

-- PELICULA Y CATEGORIA
CREATE TABLE pelicula_categoria (
    pelicula    INTEGER   NOT NULL REFERENCES pelicula  ON UPDATE CASCADE ON DELETE CASCADE,
    categoria   INTEGER   NOT NULL REFERENCES categoria ON UPDATE CASCADE ON DELETE RESTRICT,
    actualizado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(pelicula, categoria)
);
CREATE INDEX pelicula_categoria_categoria_idx ON pelicula_categoria(categoria);

-- PAIS
CREATE TABLE pais (
    codigo      INTEGER     PRIMARY KEY,
    nombre      VARCHAR(50) UNIQUE NOT NULL,
    actualizado TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CIUDAD
CREATE TABLE ciudad (
    codigo      INTEGER     PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL,
    pais        INTEGER     NOT NULL REFERENCES pais ON UPDATE CASCADE ON DELETE RESTRICT,
    actualizado TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(pais, nombre)
);
CREATE INDEX ciudad_pais_idx ON ciudad(pais);

-- DOMICILIO
CREATE TABLE domicilio (
    codigo       INTEGER     PRIMARY KEY,
    direccion    VARCHAR(50) NOT NULL,
    direccion2   VARCHAR(50),
    distrito     VARCHAR(20) NOT NULL,
    ciudad       INTEGER     NOT NULL REFERENCES ciudad ON UPDATE CASCADE ON DELETE RESTRICT,
    codigopostal VARCHAR(10),
    telefono     VARCHAR(20) NOT NULL,
    actualizado TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX domicilio_ciudad_idx ON domicilio(ciudad);

-- TIENDA
CREATE TABLE tienda (
    codigo      INTEGER    PRIMARY KEY,
    gerente     INTEGER    NOT NULL,
    direccion   INTEGER    NOT NULL REFERENCES domicilio ON UPDATE CASCADE ON DELETE RESTRICT,
    actualizado TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX tienda_direccion_idx ON tienda(direccion);

-- CLIENTE
CREATE TABLE cliente (
    codigo      INTEGER     PRIMARY KEY,
    tienda      INTEGER     NOT NULL REFERENCES tienda ON UPDATE CASCADE ON DELETE RESTRICT,
    nombre      VARCHAR(45) NOT NULL,
    apellido    VARCHAR(45) NOT NULL,
    correo      VARCHAR(50),
    domicilio   INTEGER     NOT NULL REFERENCES domicilio ON UPDATE CASCADE ON DELETE RESTRICT,
    activo      BOOLEAN     NOT NULL DEFAULT TRUE,
    creado      DATE        NOT NULL DEFAULT CURRENT_DATE,
    actualizado TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    active      INTEGER
);
CREATE INDEX cliente_tienda_idx    ON cliente(tienda);
CREATE INDEX cliente_domicilio_idx ON cliente(domicilio);

-- EMPLEADO
CREATE TABLE empleado (
    codigo      INTEGER     PRIMARY KEY,
    nombre      VARCHAR(45) NOT NULL,
    apellido    VARCHAR(45) NOT NULL,
    domicilio   INTEGER     NOT NULL REFERENCES domicilio ON UPDATE CASCADE ON DELETE RESTRICT,
    correo      VARCHAR(50),
    tienda      INTEGER     NOT NULL REFERENCES tienda ON UPDATE CASCADE ON DELETE RESTRICT,
    activo      BOOLEAN     NOT NULL DEFAULT TRUE,
    usuario     VARCHAR(16) NOT NULL,
    clave       VARCHAR(40),
    actualizado TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    foto        BLOB
);
CREATE INDEX empleado_domicilio_idx ON empleado(domicilio);
CREATE INDEX empleado_tienda_idx    ON empleado(tienda);

-- Le agregamos a la tienda la referencia al empleado, separado porque hay circularidad
ALTER TABLE tienda ADD CONSTRAINT tienda_gerente_fk FOREIGN KEY(gerente) REFERENCES domicilio ON UPDATE CASCADE ON DELETE RESTRICT;

-- INVENTARIO
CREATE TABLE inventario (
    codigo      INTEGER    PRIMARY KEY,
    pelicula    INTEGER    NOT NULL REFERENCES pelicula ON UPDATE CASCADE ON DELETE CASCADE,
    tienda      INTEGER    NOT NULL REFERENCES tienda ON UPDATE CASCADE ON DELETE CASCADE,
    actualizado TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX inventario_pelicula_idx ON inventario(pelicula);
CREATE INDEX inventario_tienda_idx   ON inventario(tienda);

-- ALQUILER
CREATE TABLE alquiler (
    codigo      INTEGER    PRIMARY KEY,
    fecha       TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    inventario  INTEGER    NOT NULL REFERENCES inventario ON UPDATE CASCADE ON DELETE RESTRICT,
    cliente     INTEGER    NOT NULL REFERENCES cliente    ON UPDATE CASCADE ON DELETE RESTRICT,
    devolucion  TIMESTAMP,
    empleado    INTEGER    NOT NULL REFERENCES empleado ON UPDATE CASCADE ON DELETE RESTRICT,
    actualizado TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX alquiler_inventario_idx ON alquiler(inventario);
CREATE INDEX alquiler_cliente_idx    ON alquiler(cliente);
CREATE INDEX alquiler_empleado_idx   ON alquiler(empleado);

-- PAGO
CREATE TABLE pago (
    codigo   INTEGER      PRIMARY KEY,
    cliente  INTEGER      NOT NULL REFERENCES cliente  ON UPDATE CASCADE ON DELETE RESTRICT,
    empleado INTEGER      NOT NULL REFERENCES empleado ON UPDATE CASCADE ON DELETE RESTRICT,
    alquiler INTEGER      NOT NULL REFERENCES alquiler ON UPDATE CASCADE ON DELETE RESTRICT,
    monto    NUMERIC(5,2) NOT NULL,
    fecha    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX pago_cliente_idx  ON pago(cliente);
CREATE INDEX pago_empleado_idx ON pago(empleado);
CREATE INDEX pago_alquiler_idx ON pago(alquiler);

--
COMMIT;