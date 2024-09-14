
--
START TRANSACTION;

--
CREATE TABLE categoria (
    codigo INTEGER     PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

--
CREATE TABLE producto (
    codigo    INTEGER       PRIMARY KEY,
    categoria INTEGER       NOT NULL REFERENCES categoria ON UPDATE CASCADE ON DELETE RESTRICT,
    titulo    VARCHAR(50)   NOT NULL,
    actor     VARCHAR(50)   NOT NULL,
    precio    NUMERIC(12,2) NOT NULL,
    especial  SMALLINT,
    padre     INTEGER       NOT NULL
);
CREATE INDEX producto_categoria_idx ON producto(categoria);

--
CREATE TABLE cliente (
    codigo             INTEGER     PRIMARY KEY,
    nombre             VARCHAR(50) NOT NULL,
    apellido           VARCHAR(50) NOT NULL,
    direccion1         VARCHAR(50) NOT NULL,
    direccion2         VARCHAR(50),
    ciudad             VARCHAR(50) NOT NULL,
    provincia          VARCHAR(50),
    codigopostal       INTEGER,
    pais               VARCHAR(50) NOT NULL,
    region             SMALLINT    NOT NULL,
    correo             VARCHAR(50),
    telefono           VARCHAR(50),
    tipotarjeta        INTEGER     NOT NULL,
    numerotarjeta      VARCHAR(50) NOT NULL,
    vencimientotarjeta VARCHAR(50) NOT NULL,
    usuario            VARCHAR(50) UNIQUE NOT NULL,
    clave              VARCHAR(50) NOT NULL,
    edad               SMALLINT,
    ingresos           INTEGER,
    genero             CHAR(1)
);

--
CREATE TABLE inventario (
    producto INTEGER PRIMARY KEY REFERENCES producto ON UPDATE CASCADE ON DELETE CASCADE,
    stock    INTEGER NOT NULL,
    ventas   INTEGER NOT NULL
);
CREATE INDEX inventario_producto_idx ON inventario(producto);

--
CREATE TABLE orden (
    codigo   INTEGER       PRIMARY KEY,
    fecha    DATE          NOT NULL,
    cliente  INTEGER       REFERENCES cliente ON UPDATE CASCADE ON DELETE SET NULL,
    importe  NUMERIC(12,2) NOT NULL,
    impuesto NUMERIC(12,2) NOT NULL,
    total    NUMERIC(12,2) NOT NULL
);
CREATE INDEX orden_cliente_idx ON orden(cliente);

--
CREATE TABLE linea (
    numero   INTEGER  NOT NULL,
    orden    INTEGER  NOT NULL REFERENCES orden    ON UPDATE CASCADE ON DELETE CASCADE,
    producto INTEGER  NOT NULL REFERENCES producto ON UPDATE CASCADE ON DELETE RESTRICT,
    cantidad SMALLINT NOT NULL,
    fecha    DATE     NOT NULL,
    PRIMARY KEY(orden, numero)
);
CREATE INDEX linea_producto_idx ON linea(producto);

--
COMMIT;