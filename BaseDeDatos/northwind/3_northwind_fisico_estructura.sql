
--
START TRANSACTION;

-- Para compatibilidad con el estandar
CREATE DOMAIN BLOB BYTEA;
CREATE DOMAIN CLOB TEXT;

-- CATEGORIA
CREATE TABLE categoria (
    codigo      SMALLINT     PRIMARY KEY,
    nombre      VARCHAR(15)  UNIQUE NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    imagen      BLOB
);

-- REGION
CREATE TABLE region (
    codigo      SMALLINT    PRIMARY KEY,
    descripcion VARCHAR(10) UNIQUE NOT NULL
);

-- TERRITORIO
CREATE TABLE territorio (
    codigo      CHAR(5)     PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL,
    region      SMALLINT    NOT NULL REFERENCES region ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE INDEX territorio_region_idx ON territorio(region);

-- TRANSPORTE
CREATE TABLE transporte (
    codigo   SMALLINT    PRIMARY KEY,
    compania VARCHAR(40) UNIQUE NOT NULL,
    telefono VARCHAR(24) NOT NULL
);

-- CLIENTE
CREATE TABLE cliente (
    codigo       CHAR(5)     PRIMARY KEY,
    compania     VARCHAR(40) NOT NULL,
    nombre       VARCHAR(30) NOT NULL,
    cargo        VARCHAR(30) NOT NULL,
    direccion    VARCHAR(60) NOT NULL,
    ciudad       VARCHAR(15) NOT NULL,
    region       VARCHAR(15),
    codigopostal VARCHAR(10),
    pais         VARCHAR(15) NOT NULL,
    telefono     VARCHAR(24) NOT NULL,
    fax          VARCHAR(24),
    UNIQUE(compania, nombre)
);

-- EMPLEADO
CREATE TABLE empleado (
    codigo       SMALLINT    PRIMARY KEY,
    apellido     VARCHAR(20) NOT NULL,
    nombre       VARCHAR(10) NOT NULL,
    titulo       VARCHAR(30) NOT NULL,
    cortesia     VARCHAR(25) NOT NULL,
    nacimiento   DATE        NOT NULL,
    baja         DATE,
    direccion    VARCHAR(60) NOT NULL,
    ciudad       VARCHAR(15) NOT NULL,
    region       VARCHAR(15),
    codigopostal VARCHAR(10),
    pais         VARCHAR(15) NOT NULL,
    telefono     VARCHAR(24) NOT NULL,
    interno      VARCHAR(4),
    foto         BLOB,
    notas        CLOB,
    superior     SMALLINT    REFERENCES empleado ON UPDATE CASCADE ON DELETE SET NULL
);
CREATE INDEX empleado_superior_idx ON empleado(superior);

-- TERRITORIOS DE EMPLEADO
CREATE TABLE empleado_territorio (
    empleado   SMALLINT    NOT NULL REFERENCES empleado   ON UPDATE CASCADE ON DELETE CASCADE,
    territorio VARCHAR(20) NOT NULL REFERENCES territorio ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY(empleado, territorio)
);

-- PROVEEDOR
CREATE TABLE proveedor (
    codigo       SMALLINT    PRIMARY KEY,
    compania     VARCHAR(40) NOT NULL,
    nombre       VARCHAR(30) NOT NULL,
    cargo        VARCHAR(30) NOT NULL,
    direccion    VARCHAR(60) NOT NULL,
    ciudad       VARCHAR(15) NOT NULL,
    region       VARCHAR(15),
    codigopostal VARCHAR(10),
    pais         VARCHAR(15) NOT NULL,
    telefono     VARCHAR(24) NOT NULL,
    fax          VARCHAR(24),
    pagina       VARCHAR(100),
    UNIQUE(compania, nombre)
);

-- PRODUCTO
CREATE TABLE producto (
    codigo        SMALLINT      PRIMARY KEY,
    nombre        VARCHAR(40)   NOT NULL,
    proveedor     SMALLINT      NOT NULL REFERENCES proveedor ON UPDATE CASCADE ON DELETE RESTRICT,
    categoria     SMALLINT      NOT NULL REFERENCES categoria ON UPDATE CASCADE ON DELETE RESTRICT,
    presentacion  VARCHAR(20)   NOT NULL,
    precio        DECIMAL(12,2) NOT NULL,
    stock         SMALLINT      NOT NULL,
    pedir         SMALLINT      NOT NULL,
    minimo        SMALLINT      NOT NULL,
    discontinuado BOOLEAN       NOT NULL,
    UNIQUE(nombre, proveedor)
);
CREATE INDEX producto_proveedor_idx ON producto(proveedor);
CREATE INDEX producto_categoria_idx ON producto(categoria);

-- PEDIDO
CREATE TABLE pedido (
    codigo       SMALLINT      PRIMARY KEY,
    cliente      CHAR(5)       NOT NULL REFERENCES cliente  ON UPDATE CASCADE ON DELETE RESTRICT,
    empleado     SMALLINT      NOT NULL REFERENCES empleado ON UPDATE CASCADE ON DELETE SET NULL,
    fecha        DATE          NOT NULL,
    requerido    DATE          NOT NULL,
    enviado      DATE,
    transporte   SMALLINT      NOT NULL REFERENCES transporte ON UPDATE CASCADE ON DELETE SET NULL,
    carga        DECIMAL(12,2) NOT NULL,
    nombre       VARCHAR(40)   NOT NULL,
    direccion    VARCHAR(60)   NOT NULL,
    ciudad       VARCHAR(15)   NOT NULL,
    region       VARCHAR(15),
    codigopostal VARCHAR(10),
    pais         VARCHAR(15)   NOT NULL
);
CREATE INDEX pedido_cliente_idx    ON pedido(cliente);
CREATE INDEX pedido_empleado_idx   ON pedido(empleado);
CREATE INDEX pedido_transporte_idx ON pedido(transporte);

-- DETALLE DEL PEDIDO
CREATE TABLE detalle (
    pedido    SMALLINT      NOT NULL REFERENCES pedido   ON UPDATE CASCADE ON DELETE CASCADE,
    producto  SMALLINT      NOT NULL REFERENCES producto ON UPDATE CASCADE ON DELETE RESTRICT,
    precio    DECIMAL(12,2) NOT NULL,
    cantidad  SMALLINT      NOT NULL,
    descuento DECIMAL(12,2) NOT NULL,
    PRIMARY KEY(pedido, producto)
);

--
COMMIT;