USE [master]
GO
/****** Object:  Database [newera]    Script Date: 1/7/2025 12:05:46 ******/
CREATE DATABASE [newera]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'newera', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\newera.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'newera_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\newera_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [newera] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [newera].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [newera] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [newera] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [newera] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [newera] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [newera] SET ARITHABORT OFF 
GO
ALTER DATABASE [newera] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [newera] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [newera] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [newera] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [newera] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [newera] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [newera] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [newera] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [newera] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [newera] SET  ENABLE_BROKER 
GO
ALTER DATABASE [newera] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [newera] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [newera] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [newera] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [newera] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [newera] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [newera] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [newera] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [newera] SET  MULTI_USER 
GO
ALTER DATABASE [newera] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [newera] SET DB_CHAINING OFF 
GO
ALTER DATABASE [newera] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [newera] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [newera] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [newera] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [newera] SET QUERY_STORE = ON
GO
ALTER DATABASE [newera] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [newera]
GO
/****** Object:  UserDefinedTableType [dbo].[EDetalle_Venta]    Script Date: 1/7/2025 12:05:46 ******/
CREATE TYPE [dbo].[EDetalle_Venta] AS TABLE(
	[IdProducto] [int] NULL,
	[Cantidad] [int] NULL,
	[Total] [decimal](18, 2) NULL
)
GO
/****** Object:  Table [dbo].[PRODUCTO]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRODUCTO](
	[IdProducto] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](500) NULL,
	[Descripcion] [varchar](500) NULL,
	[Silueta] [varchar](500) NULL,
	[Precio] [decimal](10, 2) NULL,
	[Stock] [int] NULL,
	[RutaImagen] [varchar](100) NULL,
	[NombreImagen] [varchar](100) NULL,
	[Activo] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
	[Promo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CARRITO]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CARRITO](
	[IdCarrito] [int] IDENTITY(1,1) NOT NULL,
	[IdCliente] [int] NULL,
	[Idproducto] [int] NULL,
	[Cantidad] [int] NULL,
	[PrecioUnitario] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCarrito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_obtenerCarritoCliente]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_obtenerCarritoCliente](
    @idcliente INT
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        p.IdProducto,
        p.Nombre,
        c.PrecioUnitario AS Precio, -- ✅ Precio con descuento
        c.Cantidad,
        p.RutaImagen,
        p.NombreImagen
    FROM CARRITO c
    INNER JOIN PRODUCTO p ON c.Idproducto = p.IdProducto
    WHERE c.IdCliente = @idcliente
)
GO
/****** Object:  Table [dbo].[VENTA]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VENTA](
	[IdVenta] [int] IDENTITY(1,1) NOT NULL,
	[IdCliente] [int] NULL,
	[TotalProducto] [int] NULL,
	[MontoTotal] [decimal](10, 2) NULL,
	[Contacto] [varchar](50) NULL,
	[IdProvincia] [varchar](10) NULL,
	[Telefono] [varchar](50) NULL,
	[Direccion] [varchar](500) NULL,
	[IdTransaccion] [varchar](50) NULL,
	[FechaVenta] [datetime] NULL,
	[IdCupones] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdVenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DETALLE_VENTA]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DETALLE_VENTA](
	[IdDetalleVenta] [int] IDENTITY(1,1) NOT NULL,
	[IdVenta] [int] NULL,
	[IdProducto] [int] NULL,
	[Cantidad] [int] NULL,
	[Total] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdDetalleVenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ListarCompra]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_ListarCompra](
@idcliente int
)
RETURNS TABLE
AS 
RETURN
(
	select p.RutaImagen,p.NombreImagen,p.Nombre, p.Precio,dv.Cantidad,dv.Total,v.IdTransaccion from DETALLE_VENTA Dv
	inner join PRODUCTO P ON P.IdProducto = Dv.IdProducto
	INNER JOIN VENTA V ON V.IdVenta = Dv.IdVenta
	WHERE V.IdCliente = @idcliente
)
GO
/****** Object:  Table [dbo].[CLIENTE]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLIENTE](
	[IdCliente] [int] IDENTITY(1,1) NOT NULL,
	[Nombres] [varchar](100) NULL,
	[Apellidos] [varchar](100) NULL,
	[Correo] [varchar](100) NULL,
	[Clave] [varchar](150) NULL,
	[Reestablecer] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CUPONES]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUPONES](
	[IdCupones] [int] IDENTITY(1,1) NOT NULL,
	[Codigo_cupon] [varchar](50) NOT NULL,
	[TipoDescuento] [varchar](20) NOT NULL,
	[Porcentaje_desc_cup] [decimal](5, 2) NULL,
	[Monto_desc_cup] [decimal](10, 2) NULL,
	[Cantidad_cup] [int] NOT NULL,
	[Fecha_Vencimiento] [datetime] NOT NULL,
	[FechaRegCup] [datetime] NOT NULL,
	[Activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCupones] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PROMOCIONES]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROMOCIONES](
	[IdPromocion] [int] IDENTITY(1,1) NOT NULL,
	[Silueta] [varchar](50) NULL,
	[PorcentajeDescuento] [decimal](5, 2) NULL,
	[FechaFin] [datetime] NULL,
	[Activo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPromocion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USUARIO]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USUARIO](
	[IdUsuario] [int] IDENTITY(1,1) NOT NULL,
	[Nombres] [varchar](100) NULL,
	[Apellidos] [varchar](100) NULL,
	[Correo] [varchar](100) NULL,
	[Clave] [varchar](150) NULL,
	[Reestablecer] [bit] NULL,
	[Activo] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[CLIENTE] ON 
GO
INSERT [dbo].[CLIENTE] ([IdCliente], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [FechaRegistro]) VALUES (1, N'testcliente', N'apellidotest', N'example@gmail.com', N'test1233', 0, CAST(N'2024-11-13T15:20:17.410' AS DateTime))
GO
INSERT [dbo].[CLIENTE] ([IdCliente], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [FechaRegistro]) VALUES (2, N'Lautaro', N'Aponte', N'apolauty@gmail.com', N'89dff6d289ea8a70c01eebe8e7823a3068319bc7622ddd6dac0aef3d4399f47c', 0, CAST(N'2024-11-14T05:40:27.870' AS DateTime))
GO
INSERT [dbo].[CLIENTE] ([IdCliente], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [FechaRegistro]) VALUES (3, N'Juan', N'DOe', N'juanDoe@gmail.com', N'test1233', 0, CAST(N'2024-11-14T05:41:01.207' AS DateTime))
GO
INSERT [dbo].[CLIENTE] ([IdCliente], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [FechaRegistro]) VALUES (4, N'Carlos', N'Benavides', N'Benavides23@gmail.com', N'test1233', 0, CAST(N'2024-11-14T05:41:24.370' AS DateTime))
GO
INSERT [dbo].[CLIENTE] ([IdCliente], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [FechaRegistro]) VALUES (5, N'Lautaro', N'Castellani', N'miguelangel53_276@miped.org', N'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae', 0, CAST(N'2024-11-22T11:57:38.603' AS DateTime))
GO
INSERT [dbo].[CLIENTE] ([IdCliente], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [FechaRegistro]) VALUES (6, N'Lautaro', N'Robledo', N'joaquin11_860@miped.org', N'7e7fc357fc23749f5b63f6532c85b5660f840d0cb901e9017c2fb110e1486781', 0, CAST(N'2024-11-26T12:49:06.073' AS DateTime))
GO
INSERT [dbo].[CLIENTE] ([IdCliente], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [FechaRegistro]) VALUES (7, N'Lautaro', N'Robledo', N'mariaelena50_175@miped.org', N'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae', 0, CAST(N'2024-11-26T15:44:12.137' AS DateTime))
GO
INSERT [dbo].[CLIENTE] ([IdCliente], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [FechaRegistro]) VALUES (8, N'Nicolas', N'Aponte', N'nicolas.aponte87@gmail.com', N'f6ccb3e8d609012238c0b39e60b2c9632b3cdede91e035dad1de43469768f4cc', 0, CAST(N'2024-11-26T22:03:57.520' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[CLIENTE] OFF
GO
SET IDENTITY_INSERT [dbo].[CUPONES] ON 
GO
INSERT [dbo].[CUPONES] ([IdCupones], [Codigo_cupon], [TipoDescuento], [Porcentaje_desc_cup], [Monto_desc_cup], [Cantidad_cup], [Fecha_Vencimiento], [FechaRegCup], [Activo]) VALUES (2, N'bienvenido2025', N'MONTO', CAST(0.00 AS Decimal(5, 2)), CAST(4000.00 AS Decimal(10, 2)), 0, CAST(N'2025-07-17T00:00:00.000' AS DateTime), CAST(N'2025-06-29T02:53:45.843' AS DateTime), 1)
GO
INSERT [dbo].[CUPONES] ([IdCupones], [Codigo_cupon], [TipoDescuento], [Porcentaje_desc_cup], [Monto_desc_cup], [Cantidad_cup], [Fecha_Vencimiento], [FechaRegCup], [Activo]) VALUES (3, N'INVIERNO25', N'PORCENTAJE', CAST(20.00 AS Decimal(5, 2)), CAST(0.00 AS Decimal(10, 2)), 0, CAST(N'2026-07-13T00:00:00.000' AS DateTime), CAST(N'2025-06-29T03:24:09.627' AS DateTime), 1)
GO
INSERT [dbo].[CUPONES] ([IdCupones], [Codigo_cupon], [TipoDescuento], [Porcentaje_desc_cup], [Monto_desc_cup], [Cantidad_cup], [Fecha_Vencimiento], [FechaRegCup], [Activo]) VALUES (4, N'NUEVONUEVO', N'MONTO', CAST(0.00 AS Decimal(5, 2)), CAST(400.00 AS Decimal(10, 2)), 3, CAST(N'2025-07-30T00:00:00.000' AS DateTime), CAST(N'2025-06-29T03:46:41.517' AS DateTime), 1)
GO
INSERT [dbo].[CUPONES] ([IdCupones], [Codigo_cupon], [TipoDescuento], [Porcentaje_desc_cup], [Monto_desc_cup], [Cantidad_cup], [Fecha_Vencimiento], [FechaRegCup], [Activo]) VALUES (5, N'4444', N'PORCENTAJE', CAST(50.00 AS Decimal(5, 2)), CAST(0.00 AS Decimal(10, 2)), 3000000, CAST(N'2025-07-03T00:00:00.000' AS DateTime), CAST(N'2025-06-29T03:48:38.443' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[CUPONES] OFF
GO
SET IDENTITY_INSERT [dbo].[DETALLE_VENTA] ON 
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (3, 1, 5, 3, CAST(20100.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (4, 1, 6, 5, CAST(33500.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (5, 2, 7, 9, CAST(1250.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (6, 2, 9, 4, CAST(1250.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (7, 4, 9, 4, CAST(18800.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (8, 3, 9, 2, CAST(9400.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (9, 3, 10, 2, CAST(10800.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (10, 5, 10, 2, CAST(10800.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (11, 5, 11, 2, CAST(12800.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (12, 6, 15, 4, CAST(10000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (13, 7, 7, 2, CAST(13400.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (14, 7, 8, 2, CAST(5200.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (15, 7, 19, 2, CAST(4000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (16, 8, 4, 4, CAST(10000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (17, 8, 7, 6, CAST(40200.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (18, 8, 10, 1, CAST(5400.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (19, 8, 11, 1, CAST(6400.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1016, 1008, 13, 5, CAST(12500.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1017, 1008, 22, 1, CAST(6700.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1018, 1009, 14, 3, CAST(19500.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1019, 9, 6, 1, CAST(6700.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1020, 9, 26, 2, CAST(4000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1021, 9, 28, 1, CAST(4500.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1022, 10, 15, 1, CAST(2500.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1023, 11, 9, 1, CAST(47.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1024, 11, 17, 2, CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1025, 12, 18, 3, CAST(60.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1026, 12, 23, 1, CAST(34.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1027, 13, 11, 4, CAST(256.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1028, 14, 16, 2, CAST(90.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1029, 14, 28, 1, CAST(45.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1030, 15, 5, 1, CAST(67.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1031, 16, 6, 1, CAST(67.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1032, 17, 4, 2, CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1033, 17, 5, 1, CAST(67.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1034, 18, 4, 1, CAST(25.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1035, 18, 5, 1, CAST(67.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1036, 19, 21, 3, CAST(105.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1037, 19, 10, 1, CAST(54.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1038, 1010, 15, 2, CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1039, 1011, 28, 2, CAST(90.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1040, 1011, 7, 1, CAST(67.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1041, 1014, 4, 3, CAST(75.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1042, 1014, 10, 4, CAST(216.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1043, 1015, 4, 3, CAST(75.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1044, 1016, 10, 2, CAST(108.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1045, 1017, 5, 6, CAST(402.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1046, 1018, 22, 2, CAST(34.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1047, 1018, 23, 1, CAST(28.90 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1048, 1018, 25, 1, CAST(21.25 AS Decimal(10, 2)))
GO
INSERT [dbo].[DETALLE_VENTA] ([IdDetalleVenta], [IdVenta], [IdProducto], [Cantidad], [Total]) VALUES (1049, 1018, 4, 1, CAST(25.00 AS Decimal(10, 2)))
GO
SET IDENTITY_INSERT [dbo].[DETALLE_VENTA] OFF
GO
SET IDENTITY_INSERT [dbo].[PRODUCTO] ON 
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (4, N'Gorra New Era New York Mets 39THIRTY Team Classic', N'La 39THIRTY es una gorra stretch con visera pre curvada y corona estructurada de seis paneles', N'39THIRTY', CAST(25.00 AS Decimal(10, 2)), 72, N'C:\FOTOS_GORRAS', N'4.jpg', 1, CAST(N'2024-11-13T13:38:09.007' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (5, N'Gorra New Era Golden State Warriors 59FIFTY Citrus Pop', N'La gorra de beisbol por excelencia, la emblemática gorra "fitted" o a la medida: la 59FIFTY ', N'59FIFTY', CAST(67.00 AS Decimal(10, 2)), 67, N'C:\FOTOS_GORRAS', N'5.jpg', 1, CAST(N'2024-11-13T13:40:30.050' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (6, N'Gorra New Era Los Angeles Dodgers 59FIFTY MLB Basic', N'La gorra de beisbol por excelencia, la emblemática gorra "fitted" o a la medida: la 59FIFTY', N'59FIFTY', CAST(67.00 AS Decimal(10, 2)), 98, N'C:\FOTOS_GORRAS', N'6.jpg', 1, CAST(N'2024-11-13T13:42:23.353' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (7, N'Gorra New Era New York Mets 2023 Batting Practice 59FIFTY', N'La gorra de beisbol por excelencia, la emblemática gorra "fitted" o a la medida: la 59FIFTY ', N'59FIFTY', CAST(67.00 AS Decimal(10, 2)), 113, N'C:\FOTOS_GORRAS', N'7.jpg', 1, CAST(N'2024-11-13T13:43:28.687' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (8, N'Gorra New Era New York Yankees 9FIFTY Mlb Basic', N'¡Un clásico retro y ajustable! La 9FIFTY es una gorra estructurada de corona alta', N'9FIFTY', CAST(26.00 AS Decimal(10, 2)), 200, N'C:\FOTOS_GORRAS', N'8.jpg', 1, CAST(N'2024-11-13T13:44:47.733' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (9, N'Gorra New Era Boston Red Sox Team Classic 3930', N'La 39THIRTY es una gorra stretch con visera pre curvada y corona estructurada de seis paneles', N'39THIRTY', CAST(47.00 AS Decimal(10, 2)), 199, N'C:\FOTOS_GORRAS', N'9.jpg', 1, CAST(N'2024-11-13T13:45:57.127' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (10, N'Gorra New Era Phoenix Suns White Crown Team 9FIFTY', N'¡Un clásico retro y ajustable! La 9FIFTY es una gorra estructurada de corona alta', N'9FIFTY', CAST(54.00 AS Decimal(10, 2)), 92, N'C:\FOTOS_GORRAS', N'10.jpg', 1, CAST(N'2024-11-13T13:46:42.847' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (11, N'Gorra New Era Phoenix Suns Basic 59Fifty', N'La gorra de beisbol por excelencia, la emblemática gorra "fitted" o a la medida: la 59FIFTY ', N'59FIFTY', CAST(64.00 AS Decimal(10, 2)), 195, N'C:\FOTOS_GORRAS', N'11.jpg', 1, CAST(N'2024-11-13T13:49:30.403' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (12, N'Gorra New Era Boston Celtics Throwback Corduroy 59FIFTY', N'La gorra de béisbol por excelencia, la emblemática gorra "fitted" o a la medida.', N'59FIFTY', CAST(45.00 AS Decimal(10, 2)), 100, N'C:\FOTOS_GORRAS', N'12.jpg', 1, CAST(N'2024-11-13T13:50:41.417' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (13, N'Gorra New Era New York Yankees 59FIFTY MLB Basic', N'La gorra de beisbol por excelencia, la emblemática gorra "fitted" o a la medida: la 59FIFTY', N'59FIFTY', CAST(25.00 AS Decimal(10, 2)), 195, N'C:\FOTOS_GORRAS', N'13.jpg', 1, CAST(N'2024-11-13T13:52:22.257' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (14, N'Gorra New Era Phoenix Suns NBA Basic 9FIFTY', N'¡Un clásico retro y ajustable! La 9FIFTY es una gorra estructurada de corona alta', N'9FIFTY', CAST(65.00 AS Decimal(10, 2)), 197, N'C:\FOTOS_GORRAS', N'14.jpg', 1, CAST(N'2024-11-13T13:55:36.480' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (15, N'Gorra New Era New York Yankees Pastel Patch 9FIFTY', N'¡Un clásico retro y ajustable! La 9FIFTY es una gorra estructurada de corona alta', N'9FIFTY', CAST(25.00 AS Decimal(10, 2)), 197, N'C:\FOTOS_GORRAS', N'15.jpg', 1, CAST(N'2024-11-13T13:57:06.517' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (16, N'Gorra New Era New York Knicks White Crown Team 9FIFTY', N'¡Un clásico retro y ajustable! La 9FIFTY es una gorra estructurada de corona alta', N'9FIFTY', CAST(45.00 AS Decimal(10, 2)), 98, N'C:\FOTOS_GORRAS', N'16.jpg', 1, CAST(N'2024-11-13T13:57:44.437' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (17, N'Gorra New Era San Diego Padres MLB Basic Snap 9FIFTY', N'¡Un clásico retro y ajustable! La 9FIFTY es una gorra estructurada de corona alta', N'9FIFTY', CAST(25.00 AS Decimal(10, 2)), 98, N'C:\FOTOS_GORRAS', N'17.jpg', 1, CAST(N'2024-11-13T13:58:18.570' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (18, N'Gorra New Era New York Yankees League Essential 39THIRTY', N'La 39THIRTY es una gorra stretch con visera pre curvada y corona estructurada de seis paneles', N'39THIRTY', CAST(20.00 AS Decimal(10, 2)), 147, N'C:\FOTOS_GORRAS', N'18.jpg', 1, CAST(N'2024-11-13T13:58:52.100' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (19, N'Gorra New Era New York Yankees 39THIRTY', N'La 39THIRTY es una gorra stretch con visera pre curvada y corona estructurada de seis paneles', N'39THIRTY', CAST(20.00 AS Decimal(10, 2)), 100, N'C:\FOTOS_GORRAS', N'19.jpg', 1, CAST(N'2024-11-13T13:59:27.650' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (20, N'Gorra New Era Arizona Cardinals 39THIRTY Team Classic', N'La 39THIRTY es una gorra stretch con visera pre curvada y corona estructurada de seis paneles', N'39THIRTY', CAST(10.50 AS Decimal(10, 2)), 130, N'C:\FOTOS_GORRAS', N'20.jpg', 1, CAST(N'2024-11-13T14:00:04.727' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (21, N'Gorra New Era Detroit Tigers 39THIRTY', N'La 39THIRTY es una gorra stretch con visera pre curvada y corona estructurada de seis paneles', N'39THIRTY', CAST(35.00 AS Decimal(10, 2)), 197, N'C:\FOTOS_GORRAS', N'21.jpg', 1, CAST(N'2024-11-13T14:00:34.333' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (22, N'Gorra New Era BIZARRAP 9FORTY Ajustable', N'Bizarrap y New Era se unen para crear la gorra Oficial de BZRP', N'9FORTY', CAST(20.00 AS Decimal(10, 2)), 197, N'C:\FOTOS_GORRAS', N'22.jpg', 1, CAST(N'2024-11-13T14:01:35.143' AS DateTime), 1)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (23, N'Gorra New Era New York Yankees WMNS Diamond Era 9FORTY', N'Las gorras 9FORTY tienen un toque clásico y colegial, con una visera curva y corona baja', N'9FORTY', CAST(34.00 AS Decimal(10, 2)), 98, N'C:\FOTOS_GORRAS', N'23.jpg', 1, CAST(N'2024-11-13T14:02:11.383' AS DateTime), 1)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (24, N'Gorra New Era New York Yankees Linen 9FORTY', N'Las gorras 9FORTY tienen un toque clásico y colegial, con una visera curva y corona baja ', N'9FORTY', CAST(45.00 AS Decimal(10, 2)), 150, N'C:\FOTOS_GORRAS', N'24.jpg', 1, CAST(N'2024-11-13T14:02:46.697' AS DateTime), 1)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (25, N'Gorra New Era Chicago Bulls Desert Palm 9FORTY', N'Las gorras 9FORTY tienen un toque clásico y colegial, con una visera curva y corona baja.', N'9FORTY', CAST(25.00 AS Decimal(10, 2)), 199, N'C:\FOTOS_GORRAS', N'25.jpg', 1, CAST(N'2024-11-13T14:03:23.630' AS DateTime), 1)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (26, N'Gorra New Era Chicago Bulls 39THIRTY Classic', N'La 39THIRTY es una gorra stretch con visera precurvada y corona estructurada de seis paneles', N'39THIRTY', CAST(20.00 AS Decimal(10, 2)), 138, N'C:\FOTOS_GORRAS', N'26.jpg', 1, CAST(N'2024-11-13T14:04:04.550' AS DateTime), 0)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (27, N'Gorra New Era Los Angeles Lakers 9FORTY The League', N'as gorras 9FORTY tienen un toque clásico y colegial, con una visera curva y corona baja ', N'9FORTY', CAST(35.00 AS Decimal(10, 2)), 100, N'C:\FOTOS_GORRAS', N'27.jpg', 1, CAST(N'2024-11-13T14:04:41.780' AS DateTime), 1)
GO
INSERT [dbo].[PRODUCTO] ([IdProducto], [Nombre], [Descripcion], [Silueta], [Precio], [Stock], [RutaImagen], [NombreImagen], [Activo], [FechaRegistro], [Promo]) VALUES (28, N'Gorra New Era Los Angeles Dodgers Athleisure MLB 59FIFTY', N'La gorra de béisbol por excelencia, la emblemática gorra "fitted" o a la medida: la 59FIFTY', N'59FIFTY', CAST(45.00 AS Decimal(10, 2)), 216, N'C:\FOTOS_GORRAS', N'28.jpg', 1, CAST(N'2024-11-13T14:05:19.630' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[PRODUCTO] OFF
GO
SET IDENTITY_INSERT [dbo].[PROMOCIONES] ON 
GO
INSERT [dbo].[PROMOCIONES] ([IdPromocion], [Silueta], [PorcentajeDescuento], [FechaFin], [Activo]) VALUES (1, N'9FORTY', CAST(15.00 AS Decimal(5, 2)), CAST(N'2025-12-31T00:00:00.000' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[PROMOCIONES] OFF
GO
SET IDENTITY_INSERT [dbo].[USUARIO] ON 
GO
INSERT [dbo].[USUARIO] ([IdUsuario], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [Activo], [FechaRegistro]) VALUES (1, N'Lautaro', N'Aponte', N'apolauty@gmail.com', N'54804fa8d5e7133471b88189b42d0d474b4b454bcac5c49c85c0c5f5a79834bc', 0, 0, CAST(N'2024-11-10T18:52:12.087' AS DateTime))
GO
INSERT [dbo].[USUARIO] ([IdUsuario], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [Activo], [FechaRegistro]) VALUES (2, N'Juan', N'Doe', N'juandoe@gmail.com', N'juandoe123', 1, 0, CAST(N'2024-11-11T04:11:22.173' AS DateTime))
GO
INSERT [dbo].[USUARIO] ([IdUsuario], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [Activo], [FechaRegistro]) VALUES (21, N'juan', N'perez', N'mariadelcarmen28_564@puxah.org', N'f22ecbe95d4a4dadccd4ba704ef98a055fb06246ef7dcc4133da78930892faa1', 1, 1, CAST(N'2024-11-12T01:54:49.680' AS DateTime))
GO
INSERT [dbo].[USUARIO] ([IdUsuario], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [Activo], [FechaRegistro]) VALUES (22, N'Jorge', N'Alfaro', N'jorge11_726@puxah.org', N'df8f16231a4a72d51dc6178cdc212817fb648607bd0fc73b01ea32f5b7bce593', 1, 1, CAST(N'2024-11-12T01:59:30.230' AS DateTime))
GO
INSERT [dbo].[USUARIO] ([IdUsuario], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [Activo], [FechaRegistro]) VALUES (25, N'santiago', N'aponte', N'wocete4659@lineacr.com', N'7e7fc357fc23749f5b63f6532c85b5660f840d0cb901e9017c2fb110e1486781', 0, 1, CAST(N'2024-11-13T22:48:34.787' AS DateTime))
GO
INSERT [dbo].[USUARIO] ([IdUsuario], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [Activo], [FechaRegistro]) VALUES (27, N'joaquin', N'arraya', N'zirdehikke@gufum.com', N'b460b1982188f11d175f60ed670027e1afdd16558919fe47023ecd38329e0b7f', 0, 1, CAST(N'2024-11-14T13:36:58.113' AS DateTime))
GO
INSERT [dbo].[USUARIO] ([IdUsuario], [Nombres], [Apellidos], [Correo], [Clave], [Reestablecer], [Activo], [FechaRegistro]) VALUES (29, N'Lulu', N'Robledo', N'lulurobledo84@gmail.com', N'3ebdb355028059b842b2a540562b028273c0d6e533abd9399b9d76780d9becb3', 0, 1, CAST(N'2024-11-14T17:52:42.130' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[USUARIO] OFF
GO
SET IDENTITY_INSERT [dbo].[VENTA] ON 
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (1, 1, 2, CAST(53600.00 AS Decimal(10, 2)), N'test122', N'Salta', N'3875623562', N'mitre 1330', N'qkwel231w', CAST(N'2024-11-13T15:23:04.393' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (2, 1, 2, CAST(2500.00 AS Decimal(10, 2)), N'test123', N'Salta', N'3875623562', N'mitre 1330', N'qkweo234', CAST(N'2024-12-13T15:34:15.860' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (3, 1, 2, CAST(20200.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, N'qkweo234', CAST(N'2024-11-14T03:55:50.290' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (4, 2, 4, CAST(18800.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, N'qkweo7856', CAST(N'2024-11-14T14:04:18.010' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (5, 3, 4, CAST(23600.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, N'qkweo78ere', CAST(N'2024-11-14T14:06:02.510' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (6, 3, 4, CAST(10000.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, N'qkweo78dfe', CAST(N'2024-11-14T14:15:45.953' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (7, 4, 6, CAST(22600.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, N'qkweo78dfetr', CAST(N'2024-11-14T14:17:03.587' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (8, 5, 4, CAST(62000.00 AS Decimal(10, 2)), N'test', N'Salta', N'23334223', N'av.test', N'code0001', CAST(N'2024-11-24T06:25:23.973' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (9, 5, 3, CAST(15200.00 AS Decimal(10, 2)), N'Juan perez', N'Salta', N'1223', N'av.test', N'code0001', CAST(N'2024-11-26T02:28:48.070' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (10, 5, 1, CAST(2500.00 AS Decimal(10, 2)), N'Juan perez', N'Salta', N'1223', N'av.test', N'6S325606MY503411S', CAST(N'2024-11-26T04:23:48.320' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (11, 6, 2, CAST(97.00 AS Decimal(10, 2)), N'Joaquín Salva', N'Salta', N'38756734', N'reyes católicos 1299', N'95X02082TB965592F', CAST(N'2024-11-26T13:06:52.023' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (12, 6, 2, CAST(94.00 AS Decimal(10, 2)), N'Joaquín Salva', N'Salta', N'38756734', N'reyes católicos 1299', N'78H09891SK736654L', CAST(N'2024-11-26T13:30:34.007' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (13, 6, 1, CAST(256.00 AS Decimal(10, 2)), N'Joaquín Salva', N'Salta', N'38756734', N'reyes católicos 1299', N'5NJ011049L974921L', CAST(N'2024-11-26T13:41:41.707' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (14, 6, 2, CAST(135.00 AS Decimal(10, 2)), N'Joaquín Salva', N'Salta', N'38756734', N'reyes católicos 1299', N'73029845RS680874X', CAST(N'2024-11-26T13:50:33.613' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (15, 6, 1, CAST(67.00 AS Decimal(10, 2)), N'Joaquín Salva', N'Salta', N'38756734', N'reyes católicos 1299', N'56H2955050505693X', CAST(N'2024-11-26T13:57:14.517' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (16, 6, 1, CAST(67.00 AS Decimal(10, 2)), N'Joaquín Salva', N'Salta', N'38756734', N'reyes católicos 1299', N'5FK691847G2118029', CAST(N'2024-11-26T13:59:57.850' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (17, 7, 2, CAST(117.00 AS Decimal(10, 2)), N'Joaquín Salva', N'Salta', N'38756734', N'reyes católicos 1299', N'78U939505B849563H', CAST(N'2024-11-26T15:45:20.067' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (18, 2, 2, CAST(92.00 AS Decimal(10, 2)), N'Joaquín Salva', N'Salta', N'38756734', N'reyes católicos 1299', N'09124351C4559933U', CAST(N'2024-11-26T16:34:06.947' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (19, 8, 2, CAST(159.00 AS Decimal(10, 2)), N'Joaquín Salva', N'Salta', N'38756734', N'reyes católicos 1299', N'2NG75811Y1768153H', CAST(N'2024-11-26T22:05:35.373' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (1008, 5, 2, CAST(19200.00 AS Decimal(10, 2)), N'Juan perez', N'Salta', N'23334227', N'av.test', N'code0001', CAST(N'2024-11-26T02:16:52.760' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (1009, 5, 1, CAST(19500.00 AS Decimal(10, 2)), N'Juan perez', N'Salta', N'1223', N'av.test', N'code0001', CAST(N'2024-11-26T02:19:24.480' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (1010, 2, 1, CAST(50.00 AS Decimal(10, 2)), N'Lautaro', N'Salta', N'3875623562', N'Vicente lopez 2674', N'3ST73937DH928923R', CAST(N'2025-06-23T19:07:33.667' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (1011, 2, 2, CAST(157.00 AS Decimal(10, 2)), N'guada', N'Salta', N'3424234234', N'2674 Vicente Lopez', N'72W071842L391351C', CAST(N'2025-06-26T02:05:34.177' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (1014, 2, 2, CAST(291.00 AS Decimal(10, 2)), N'guada', N'Salta', N'3424234234', N'2674 Vicente Lopez', N'81469205WE912972T', CAST(N'2025-06-30T06:02:17.673' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (1015, 2, 1, CAST(60.00 AS Decimal(10, 2)), N'lautaro', N'Salta', N'3424234234', N'2674 Vicente Lopez', N'1LG622113A9837152', CAST(N'2025-06-30T06:48:35.947' AS DateTime), 3)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (1016, 2, 1, CAST(108.00 AS Decimal(10, 2)), N'lautaro', N'Salta', N'3424234234', N'2674 Vicente Lopez', N'35S994453Y649591J', CAST(N'2025-06-30T06:51:43.620' AS DateTime), NULL)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (1017, 2, 1, CAST(2.00 AS Decimal(10, 2)), N'lautaro', N'Salta', N'3424234234', N'2674 Vicente Lopez', N'3XG41015NY595224J', CAST(N'2025-06-30T16:06:39.607' AS DateTime), 4)
GO
INSERT [dbo].[VENTA] ([IdVenta], [IdCliente], [TotalProducto], [MontoTotal], [Contacto], [IdProvincia], [Telefono], [Direccion], [IdTransaccion], [FechaVenta], [IdCupones]) VALUES (1018, 2, 4, CAST(109.15 AS Decimal(10, 2)), N'Lautyy', N'Salta', N'3424234234', N'2674 Vicente Lopez', N'30P77776FE915653T', CAST(N'2025-07-01T08:01:16.140' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[VENTA] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__CUPONES__7BB0BB754373400C]    Script Date: 1/7/2025 12:05:46 ******/
ALTER TABLE [dbo].[CUPONES] ADD UNIQUE NONCLUSTERED 
(
	[Codigo_cupon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLIENTE] ADD  DEFAULT ((0)) FOR [Reestablecer]
GO
ALTER TABLE [dbo].[CLIENTE] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[CUPONES] ADD  DEFAULT (getdate()) FOR [FechaRegCup]
GO
ALTER TABLE [dbo].[CUPONES] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[PRODUCTO] ADD  DEFAULT ((0)) FOR [Precio]
GO
ALTER TABLE [dbo].[PRODUCTO] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[PRODUCTO] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[PRODUCTO] ADD  DEFAULT ((0)) FOR [Promo]
GO
ALTER TABLE [dbo].[PROMOCIONES] ADD  DEFAULT ((0)) FOR [Activo]
GO
ALTER TABLE [dbo].[USUARIO] ADD  DEFAULT ((1)) FOR [Reestablecer]
GO
ALTER TABLE [dbo].[USUARIO] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[USUARIO] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[VENTA] ADD  DEFAULT (getdate()) FOR [FechaVenta]
GO
ALTER TABLE [dbo].[CARRITO]  WITH CHECK ADD FOREIGN KEY([IdCliente])
REFERENCES [dbo].[CLIENTE] ([IdCliente])
GO
ALTER TABLE [dbo].[CARRITO]  WITH CHECK ADD FOREIGN KEY([Idproducto])
REFERENCES [dbo].[PRODUCTO] ([IdProducto])
GO
ALTER TABLE [dbo].[DETALLE_VENTA]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[PRODUCTO] ([IdProducto])
GO
ALTER TABLE [dbo].[DETALLE_VENTA]  WITH CHECK ADD FOREIGN KEY([IdVenta])
REFERENCES [dbo].[VENTA] ([IdVenta])
GO
ALTER TABLE [dbo].[VENTA]  WITH CHECK ADD FOREIGN KEY([IdCliente])
REFERENCES [dbo].[CLIENTE] ([IdCliente])
GO
ALTER TABLE [dbo].[VENTA]  WITH CHECK ADD  CONSTRAINT [FK_VENTA_CUPONES] FOREIGN KEY([IdCupones])
REFERENCES [dbo].[CUPONES] ([IdCupones])
GO
ALTER TABLE [dbo].[VENTA] CHECK CONSTRAINT [FK_VENTA_CUPONES]
GO
ALTER TABLE [dbo].[CUPONES]  WITH CHECK ADD CHECK  (([TipoDescuento]='MONTO' OR [TipoDescuento]='PORCENTAJE'))
GO
/****** Object:  StoredProcedure [dbo].[sp_EditarCupon]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_EditarCupon](
@IdCupones int,
@Codigo_cupon VARCHAR(50),
@TipoDescuento VARCHAR(20),
@Porcentaje_desc_cup DECIMAL(5,2),
@Monto_desc_cup DECIMAL(10,2),
@Cantidad_cup INT,
@Activo BIT,
@Fecha_Vencimiento DATETIME,
@Mensaje VARCHAR(500) OUTPUT,
@Resultado INT OUTPUT
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT 1 FROM CUPONES WHERE Codigo_cupon = @Codigo_cupon AND IdCupones != @IdCupones )
	begin
		update CUPONES set
		Codigo_cupon = @Codigo_cupon,
		TipoDescuento = @TipoDescuento,
		Porcentaje_desc_cup = @Porcentaje_desc_cup,
		Monto_desc_cup = @Monto_desc_cup,
		Cantidad_cup = @Cantidad_cup,
		Fecha_Vencimiento = @Fecha_Vencimiento,
		Activo = @Activo
		WHERE IdCupones = @IdCupones

		set @Resultado = 1
	end
	else
		set @Mensaje = 'El producto ya existe'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_EditarProducto]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_EditarProducto](
@IdProducto int,
@Nombre varchar(100),
@Descripcion varchar(100),
@Silueta varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre AND IdProducto != @IdProducto )
	begin
		update PRODUCTO set
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		Silueta = @Silueta,
		Precio = @Precio,
		Stock = @Stock,
		Activo = @Activo
		WHERE IdProducto = @IdProducto

		set @Resultado = 1
	end
	else
		set @Mensaje = 'El producto ya existe'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_EditarPromo]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_EditarPromo](
@IdPromocion int,
@Silueta VARCHAR(50),
@PorcentajeDescuento DECIMAL(5,2),
@Activo BIT,
@FechaFin DATETIME,
@Mensaje VARCHAR(500) OUTPUT,
@Resultado INT OUTPUT
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT 1 FROM PROMOCIONES WHERE IdPromocion != @IdPromocion )
	begin
		update PROMOCIONES set
		Silueta = @Silueta,
		PorcentajeDescuento = @PorcentajeDescuento,
		Activo = @Activo,
		FechaFin = @FechaFin
		WHERE IdPromocion = @IdPromocion

		set @Resultado = 1
	end
	else
		set @Mensaje = 'El producto ya existe'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_EditarUsuario]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_EditarUsuario](
@IdUsuario int,
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo AND IdUsuario != @IdUsuario)
	BEGIN
		UPDATE top(1) USUARIO set
		Nombres = @Nombres,
		Apellidos = @Apellidos,
		Correo = @Correo,
		Activo = @Activo
		where IdUsuario = @IdUsuario
		
		SET @Resultado = 1
	end
	else
		set @Mensaje = 'El correo del usuario ya existe'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarCarrito]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_EliminarCarrito](
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as 
begin
	set @Resultado = 1
	declare @cantidadproducto int = (select Cantidad from CARRITO where IdCliente = @IdCliente and Idproducto=@IdProducto)

	BEGIN TRY
		BEGIN TRANSACTION OPERACION

		update PRODUCTO set Stock = Stock + @cantidadproducto where IdProducto = @IdProducto
		delete top(1) from CARRITO where IdCliente = @IdCliente and Idproducto = @IdProducto

		COMMIT TRANSACTION OPERACION

	END TRY
	BEGIN CATCH
		SET @Resultado = 0
		ROLLBACK TRANSACTION OPERACION
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarCupon]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_EliminarCupon](
@IdCupones int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (
		SELECT 1
		FROM VENTA dv
		INNER JOIN CUPONES p ON p.IdCupones = dv.IdCupones
		WHERE p.IdCupones = @IdCupones
	)

	begin
		delete top(1) from CUPONES where IdCupones = @IdCupones
		SET @Resultado = 1
	end
	else
		set @Mensaje = 'El cupón se encuentra relacionado a una venta'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarProducto]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_EliminarProducto](
@IdProducto int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS(SELECT * FROM DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	where p.IdProducto = @IdProducto)
	begin
		delete top(1) from PRODUCTO where IdProducto = @IdProducto
		SET @Resultado = 1
	end
	else
		set @Mensaje = 'El producto se encuentra relacionado a una venta'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarPromo]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_EliminarPromo](
@IdPromocion int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0

	begin
		delete top(1) from PROMOCIONES where IdPromocion  = @IdPromocion 
		SET @Resultado = 1
	end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_ExisteCarrito]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_ExisteCarrito](
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as
begin
	if exists(select * from CARRITO where IdCliente = @IdCliente and Idproducto = @IdProducto)
		set @Resultado = 1
	else
		set @Resultado = 0
end
GO
/****** Object:  StoredProcedure [dbo].[sp_OperacionCarrito]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_OperacionCarrito]
(
    @IdCliente INT,
    @IdProducto INT,
    @Sumar BIT,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 1
    SET @Mensaje = ''

    DECLARE @existecarrito BIT = IIF(EXISTS(SELECT * FROM CARRITO WHERE IdCliente = @IdCliente AND IdProducto = @IdProducto), 1, 0)
    DECLARE @stockproducto INT = (SELECT Stock FROM PRODUCTO WHERE IdProducto = @IdProducto)

    BEGIN TRY
        BEGIN TRANSACTION OPERACION

        IF (@Sumar = 1)
        BEGIN
            IF (@stockproducto > 0)
            BEGIN
                -- Obtener precio base y descuento
                DECLARE @precio_base DECIMAL(10,2) = (SELECT Precio FROM PRODUCTO WHERE IdProducto = @IdProducto)
                DECLARE @promo BIT = (SELECT Promo FROM PRODUCTO WHERE IdProducto = @IdProducto)
                DECLARE @silueta NVARCHAR(50) = (SELECT Silueta FROM PRODUCTO WHERE IdProducto = @IdProducto)
                DECLARE @descuento DECIMAL(10,2) = (
                    SELECT ISNULL(PorcentajeDescuento, 0)
                    FROM PROMOCIONES
                    WHERE Silueta = @silueta
                )
                DECLARE @precio_final DECIMAL(10,2) = 
                    IIF(@promo = 1, @precio_base * (1 - @descuento / 100.0), @precio_base)

                IF (@existecarrito = 1)
                BEGIN
                    UPDATE CARRITO 
                    SET Cantidad = Cantidad + 1
                    WHERE IdCliente = @IdCliente AND IdProducto = @IdProducto
                END
                ELSE
                BEGIN
                    INSERT INTO CARRITO (IdCliente, IdProducto, Cantidad, PrecioUnitario)
                    VALUES (@IdCliente, @IdProducto, 1, @precio_final)
                END

                UPDATE PRODUCTO 
                SET Stock = Stock - 1 
                WHERE IdProducto = @IdProducto
            END
            ELSE
            BEGIN
                SET @Resultado = 0
                SET @Mensaje = 'El producto no cuenta con stock disponible'
            END
        END
        ELSE
        BEGIN
            UPDATE CARRITO 
            SET Cantidad = Cantidad - 1 
            WHERE IdCliente = @IdCliente AND IdProducto = @IdProducto

            UPDATE PRODUCTO 
            SET Stock = Stock + 1 
            WHERE IdProducto = @IdProducto
        END

        COMMIT TRANSACTION OPERACION
    END TRY
    BEGIN CATCH
        SET @Resultado = 0
        SET @Mensaje = ERROR_MESSAGE()
        ROLLBACK TRANSACTION OPERACION
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_RegistrarCliente]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_RegistrarCliente](
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Correo = @Correo)
	BEGIN
		INSERT INTO CLIENTE(Nombres,Apellidos,Correo,Clave,Reestablecer) VALUES
		(@Nombres,@Apellidos,@Correo,@Clave,0)

		SET @Resultado = SCOPE_IDENTITY()
	END
	ELSE
		SET @Mensaje = 'El correo del usuaurio ya existe'

end
GO
/****** Object:  StoredProcedure [dbo].[sp_RegistrarCupon]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_RegistrarCupon]
    @Codigo_cupon VARCHAR(50),
    @TipoDescuento VARCHAR(20),
    @Porcentaje_desc_cup DECIMAL(5,2),
	@Monto_desc_cup DECIMAL(10,2),
    @Cantidad_cup INT,
    @Activo BIT,
    @Fecha_Vencimiento DATETIME,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    IF NOT EXISTS (SELECT 1 FROM CUPONES WHERE Codigo_cupon = @Codigo_cupon)
    BEGIN
        INSERT INTO CUPONES (
            Codigo_cupon,
            TipoDescuento,
            Porcentaje_desc_cup,
            Monto_desc_cup,
            Cantidad_cup,
            Fecha_Vencimiento,
            Activo
        )
        VALUES (
            @Codigo_cupon,
            @TipoDescuento,
            @Porcentaje_desc_cup,
            @Monto_desc_cup,
            @Cantidad_cup,
            @Fecha_Vencimiento,
            @Activo
        );

        SET @Resultado = SCOPE_IDENTITY();
        SET @Mensaje = 'Cupón registrado correctamente.';
    END
    ELSE
    BEGIN
        SET @Mensaje = 'El cupón ya existe.';
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_RegistrarProducto]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_RegistrarProducto](
@Nombre varchar(100),
@Descripcion varchar(100),
@Silueta varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	set @Resultado = 0
	IF NOT EXISTS(SELECT * FROM PRODUCTO WHERE Nombre = @Nombre)
	begin
		insert into PRODUCTO(Nombre,Descripcion,Silueta,Precio,Stock,Activo) values
		(@Nombre,@Descripcion,@Silueta,@Precio,@Stock,@Activo)

		SET @Resultado = SCOPE_IDENTITY()
	END
	ELSE
		set @Mensaje = 'El producto ya existe'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_RegistrarPromo]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_RegistrarPromo]
    @Silueta VARCHAR(50),
    @PorcentajeDescuento DECIMAL(5,2),
    @Activo BIT,
    @FechaFin DATETIME,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

	IF NOT EXISTS (SELECT 1 FROM PROMOCIONES WHERE Silueta = @Silueta)
    BEGIN
        INSERT INTO PROMOCIONES (
                Silueta,
				PorcentajeDescuento,
				Activo,
				FechaFin
        )
        VALUES (
                @Silueta ,
				@PorcentajeDescuento ,
				@Activo ,
				@FechaFin
        );

        SET @Resultado = SCOPE_IDENTITY();
        SET @Mensaje = 'Promo registrado correctamente.';
    END
	ELSE
    BEGIN
        SET @Mensaje = 'Esta silueta ya tiene promo.';
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_RegistrarUsuario]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_RegistrarUsuario](
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo)
	begin
		insert into USUARIO (Nombres, Apellidos, Correo, Clave, Activo) values (@Nombres, @Apellidos, @Correo, @Clave, @Activo)
		SET @Resultado = scope_identity()
	end
	else
		set @Mensaje = 'El correo del usuario ya existe'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_ReporteDashboard]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_ReporteDashboard]
AS
BEGIN
    DECLARE @mesActual INT = MONTH(GETDATE());
    DECLARE @anioActual INT = YEAR(GETDATE());

    SELECT
        (SELECT COUNT(*) 
         FROM CLIENTE c
         WHERE MONTH(c.FechaRegistro) = @mesActual AND YEAR(c.FechaRegistro) = @anioActual) AS [TotalCliente],

        (SELECT ISNULL(SUM(cantidad), 0) 
         FROM DETALLE_VENTA DV
         INNER JOIN VENTA V ON DV.IdVenta = V.IdVenta
         WHERE MONTH(V.FechaVenta) = @mesActual AND YEAR(V.FechaVenta) = @anioActual) AS [TotalVenta],

        (SELECT COUNT(*) 
         FROM PRODUCTO p
         WHERE MONTH(p.FechaRegistro) = @mesActual AND YEAR(p.FechaRegistro) = @anioActual) AS [TotalProducto];
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ReporteVentas]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_ReporteVentas](
@fechainicio varchar(10),
@fechafin varchar(10),
@idtransaccion varchar(50)
)
as
begin
	set dateformat dmy;
select CONVERT(char(10),v.FechaVenta,103)[FechaVenta],CONCAT(c.Nombres,' ', c.Apellidos)[Cliente],
p.Nombre[Producto], p.Precio, dv.Cantidad, dv.Total, v.IdTransaccion
from DETALLE_VENTA dv
inner join PRODUCTO p on p.IdProducto = dv.IdProducto
inner join VENTA v on v.IdVenta = dv.IdVenta
inner join CLIENTE c on c.IdCliente = v.IdCliente
where CONVERT(date,v.FechaVenta) between @fechainicio and @fechafin
and v.IdTransaccion = iif(@idtransaccion = '', v.IdTransaccion, @idtransaccion)

end
GO
/****** Object:  StoredProcedure [dbo].[sp_VentasMensuales]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_VentasMensuales]
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        MONTH(v.FechaVenta) AS Mes,
        COUNT(dv.IdDetalleVenta) AS CantidadVentas
    FROM
        DETALLE_VENTA dv
    INNER JOIN VENTA v ON dv.IdVenta = v.IdVenta
    WHERE
        YEAR(v.FechaVenta) = @Anio
    GROUP BY
        MONTH(v.FechaVenta)
    ORDER BY
        Mes;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VentasXCategoria]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_VentasXCategoria]
    @Anio INT,
    @Mes INT
AS
BEGIN
    SET NOCOUNT ON;

    WITH CategoriaVentas AS (
        SELECT
            p.Silueta AS categoria,
            COUNT(dv.IdDetalleVenta) AS cantidad_ventas_categoria
        FROM
            dbo.PRODUCTO p
        INNER JOIN
            dbo.DETALLE_VENTA dv ON p.IdProducto = dv.IdProducto
        INNER JOIN
            dbo.VENTA v ON dv.IdVenta = v.IdVenta
        WHERE
            v.FechaVenta >= DATEFROMPARTS(@Anio, @Mes, 1)
            AND v.FechaVenta < DATEADD(MONTH, 1, DATEFROMPARTS(@Anio, @Mes, 1))
        GROUP BY
            p.Silueta
    ),
    TotalVentas AS (
        SELECT
            COUNT(dv.IdDetalleVenta) AS total_general_ventas
        FROM
            dbo.DETALLE_VENTA dv
        INNER JOIN
            dbo.VENTA v ON dv.IdVenta = v.IdVenta
        WHERE
            v.FechaVenta >= DATEFROMPARTS(@Anio, @Mes, 1)
            AND v.FechaVenta < DATEADD(MONTH, 1, DATEFROMPARTS(@Anio, @Mes, 1))
    )
    SELECT
        cv.categoria,
        cv.cantidad_ventas_categoria,
        CASE
            WHEN tv.total_general_ventas = 0 THEN 0.00
            ELSE CAST(cv.cantidad_ventas_categoria AS DECIMAL(10, 2)) * 100 / tv.total_general_ventas
        END AS porcentaje_ventas
    FROM
        CategoriaVentas cv
    CROSS JOIN
        TotalVentas tv
    ORDER BY
        cantidad_ventas_categoria DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_RegistrarVenta]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_RegistrarVenta](
@IdCliente int,
@TotalProducto int,
@MontoTotal decimal(18,2),
@Contacto varchar(100),
@IdProvincia varchar(10),
@Telefono varchar(10),
@Direccion varchar(100),
@IdTransaccion varchar(50),
@IdCupones int,
@DetalleVenta [EDetalle_Venta] READONLY,
@Resultado bit output,
@Mensaje varchar(500) output
)
as
begin
	begin try
		declare @idventa int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin transaction registro

		insert into VENTA(IdCliente,TotalProducto,MontoTotal,Contacto,IdProvincia,Telefono,Direccion,IdTransaccion,IdCupones)
		values(@IdCliente,@TotalProducto,@MontoTotal,@Contacto,@IdProvincia,@Telefono,@Direccion,@IdTransaccion,@IdCupones)

		IF @IdCupones IS NOT NULL
		BEGIN
			UPDATE CUPONES SET Cantidad_cup = Cantidad_cup - 1 WHERE IdCupones = @IdCupones
		END



		set @idventa = SCOPE_IDENTITY()

		insert into DETALLE_VENTA(IdVenta,IdProducto,Cantidad,Total)
		select @idventa,IdProducto,Cantidad,Total from @DetalleVenta


		DELETE FROM CARRITO WHERE IdCliente = @IdCliente

		commit transaction registro

	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[usp_ValidarCupon]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ValidarCupon]
    @CodigoCupon VARCHAR(50),
    @MontoDescuento DECIMAL(10,2) OUTPUT,
    @PorcentajeDescuento DECIMAL(5,2) OUTPUT,
    @TipoDescuento VARCHAR(20) OUTPUT,
    @IdCupon INT OUTPUT, -- nuevo parámetro
    @Mensaje VARCHAR(200) OUTPUT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0
    SET @Mensaje = ''
    SET @IdCupon = NULL

    IF EXISTS (
        SELECT 1 FROM CUPONES 
        WHERE Codigo_cupon = @CodigoCupon 
            AND Cantidad_cup >= 1
            AND Fecha_Vencimiento >= CONVERT(DATE, GETDATE())
            AND Activo = 1
    )
    BEGIN
        SELECT 
            @MontoDescuento = Monto_desc_cup,
            @PorcentajeDescuento = Porcentaje_desc_cup,
            @TipoDescuento = TipoDescuento,
            @IdCupon = IdCupones
        FROM CUPONES 
        WHERE Codigo_cupon = @CodigoCupon

        SET @Resultado = 1
    END
    ELSE
    BEGIN
        SET @Mensaje = 'Cupón inválido, vencido, agotado o inactivo.'
    END
END
GO
/****** Object:  Trigger [dbo].[trg_ActualizarPromoEnProducto]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_ActualizarPromoEnProducto]
ON [dbo].[PROMOCIONES]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualiza todos los productos que coincidan con la silueta insertada
    UPDATE p
    SET p.Promo = 1
    FROM PRODUCTO p
    INNER JOIN inserted i ON p.Silueta = i.Silueta;
END
GO
ALTER TABLE [dbo].[PROMOCIONES] ENABLE TRIGGER [trg_ActualizarPromoEnProducto]
GO
/****** Object:  Trigger [dbo].[trg_EliminarPromo]    Script Date: 1/7/2025 12:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_EliminarPromo]
ON [dbo].[PROMOCIONES]
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET p.Promo = 0
    FROM PRODUCTO p
    INNER JOIN deleted d ON p.Silueta = d.Silueta;
END
GO
ALTER TABLE [dbo].[PROMOCIONES] ENABLE TRIGGER [trg_EliminarPromo]
GO
USE [master]
GO
ALTER DATABASE [newera] SET  READ_WRITE 
GO
